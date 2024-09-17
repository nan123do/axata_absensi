import 'dart:async';

import 'package:axata_absensi/components/custom_dialog.dart';
import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/models/Absensi/dataabsen_model.dart';
import 'package:axata_absensi/models/Shift/datashift_model.dart';
import 'package:axata_absensi/pages/home/views/selectshift.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/services/absensi_service.dart';
import 'package:axata_absensi/services/helper_service.dart';
import 'package:axata_absensi/services/online/online_absensi_service.dart';
import 'package:axata_absensi/services/online/online_shift_service.dart';
import 'package:axata_absensi/services/shift_service.dart';
import 'package:axata_absensi/utils/datehelper.dart';
import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/locationhelper.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingCheckIn = false.obs;
  RxString telat = '0'.obs;
  RxString hariMasuk = '0'.obs;

  // Absensi Today
  TimeOfDay timeIn = const TimeOfDay(hour: 8, minute: 0);
  RxString jadwalCheckIn = '-'.obs;
  TimeOfDay timeOut = const TimeOfDay(hour: 11, minute: 22);
  RxString jadwalCheckOut = '-'.obs;
  RxString doneCheckIn = ''.obs;
  RxString doneCheckOut = ''.obs;
  RxString statusShift = '0'.obs;

  RxString timeCheckIn = ''.obs;
  String dateText =
      DateFormat('EEEE dd MMMM yyyy', 'id_ID').format(DateTime.now());
  Timer? timer;

  AbsensiService serviceAbsensi = AbsensiService();
  ShiftService serviceShift = ShiftService();
  HelperService serviceHelper = HelperService();
  List<DataAbsenModel> listAbsen = [];
  List<DataShiftModel> listShiftAll = [];
  List<DataShiftModel> listShift = [];

  // DateTime
  DateTime dateFrom = DateTime.now();
  DateTime dateTo = DateTime.now();

  // Shift
  DataShiftModel? selectedShift;
  RxBool isEmptySelectedShift = true.obs;

  @override
  void onInit() {
    super.onInit();

    if (PegawaiData.isSuperUser == false) {
      getInit();
    }
  }

  getInit() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    isLoading.value = true;
    // Get Data Absensi
    try {
      // Mendapatkan tanggal awal bulan ini
      DateTime firstDayOfMonth = DateTime(dateFrom.year, dateFrom.month, 1);

      // Mendapatkan tanggal akhir bulan ini
      DateTime lastDayOfMonth = DateTime(dateTo.year, dateTo.month + 1, 0);

      await handleStatusShift();

      // Get All Shift
      await handleDataShift();

      // Get Shift Hari Ini
      String namaHariIni = DateFormat('EEEE', 'id_ID').format(DateTime.now());

      if (GlobalData.statusShift == false) {
        List<DataShiftModel> defaultShift = listShiftAll
            .where((shift) =>
                shift.hari.trim() == namaHariIni && shift.nama == 'default')
            .toList();
        if (defaultShift.isNotEmpty) {
          afterSelectShift(defaultShift.first);
        } else {
          if (PegawaiData.isAdmin == false) {
            CustomToast.errorToast("Error", 'Tidak ada shift hari ini');
          }
        }
      } else {
        listShift = listShiftAll;
        listShift.removeWhere((item) => item.nama == 'default');
        listShift = listShiftAll
            .where((shift) =>
                shift.hari.trim() == namaHariIni && shift.statusAktif)
            .toList();
        getDefaultShift();
      }

      // Get All absen
      await handleDataAbsensi(firstDayOfMonth, lastDayOfMonth);

      if (listAbsen.isNotEmpty) {
        getTelat();
        getAbsenHariIni();
        handleAbsensiTerakhir();
      }
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }

    isLoading.value = false;
  }

  handleStatusShift() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      statusShift.value = GlobalData.statusShift ? '1' : '0';
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      String status = await serviceHelper.strSetting(kodeSetting: 'I02');
      GlobalData.statusShift = status == '1' ? true : false;
      statusShift.value = status;
    }
  }

  handleDataShift() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineShiftService serviceOnline = OnlineShiftService();
      listShiftAll = await serviceOnline.getShift(
        hari: '',
        status: '1',
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      listShiftAll = await serviceShift.getShift(
        hari: '',
        status: '1',
      );
    }
  }

  handleDataAbsensi(DateTime start, DateTime end) async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineAbsensiService serviceAbsensiOnline = OnlineAbsensiService();
      PaginatedAbsensi paginate = await serviceAbsensiOnline.getDataAbsensi(
        namaPegawai:
            PegawaiData.nama == '' ? GlobalData.username : PegawaiData.nama,
        dateFrom: DateFormat('yyyy-MM-dd').format(start),
        dateTo: DateFormat('yyyy-MM-dd').format(end),
        nameSorting: 'JAM MASUK',
        sort: 'Descending',
      );
      listAbsen = paginate.results;
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      listAbsen = await serviceAbsensi.getDataAbsensi(
        namaPegawai:
            PegawaiData.nama == '' ? GlobalData.username : PegawaiData.nama,
        dateFrom: DateFormat('yyyy-MM-dd').format(start),
        dateTo: DateFormat('yyyy-MM-dd').format(end),
        nameSorting: 'JAM MASUK',
        sort: 'Descending',
      );
    }
  }

  void getDefaultShift() {
    if (listShift.isNotEmpty) {
      selectedShift = determineShift(listShift);
      if (selectedShift != null) {
        isEmptySelectedShift.value = false;
        TimeOfDay jadwalMasuk =
            DateHelper.stringToTime(selectedShift!.jamMasuk);
        TimeOfDay jadwalKeluar =
            DateHelper.stringToTime(selectedShift!.jamKeluar);
        jadwalCheckIn.value =
            '${jadwalMasuk.hour}:${jadwalMasuk.minute.toString().padLeft(2, '0')}';

        jadwalCheckOut.value =
            '${jadwalKeluar.hour}:${jadwalKeluar.minute.toString().padLeft(2, '0')}';
      }
    } else {
      if (PegawaiData.isAdmin == false) {
        CustomToast.errorToast("Error", 'Tidak ada shift hari ini');
      }
    }
  }

  DataShiftModel determineShift(
    List<DataShiftModel> shifts,
  ) {
    TimeOfDay currentTime = TimeOfDay.now();
    for (var shift in shifts) {
      final TimeOfDay start = DateHelper.stringToTime(shift.jamMasuk);

      // Konversi ke menit untuk perbandingan
      int startMin = start.hour * 60 + start.minute;
      int endMin = start.hour * 60 + start.minute;
      int currentMin = currentTime.hour * 60 + currentTime.minute;

      // Cek jika waktu saat ini dalam range shift
      if (currentMin >= startMin && currentMin <= endMin) {
        return shift;
      }
    }

    // Jika tidak ada shift yang cocok, cari shift berikutnya atau default ke shift sebelumnya
    DataShiftModel? nextShift;
    int minDifference = 1440;
    for (var shift in shifts) {
      final TimeOfDay start = DateHelper.stringToTime(shift.jamMasuk);
      int startMin = start.hour * 60 + start.minute;
      int difference = startMin - currentTime.hour * 60 - currentTime.minute;

      if (difference > 0 && difference < minDifference) {
        nextShift = shift;
        minDifference = difference;
      }
    }

    return nextShift ?? shifts.last;
  }

  void getTelat() {
    int count = 0;
    int counthari = 0;
    Set<String> uniqueDates = {};

    for (DataAbsenModel item in listAbsen) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(item.jamMasuk);

      // Menghitung jumlah hari unik
      if (!uniqueDates.contains(formattedDate)) {
        uniqueDates.add(formattedDate);
        counthari++;
      }

      if (item.jamKerja == '') {
        count++;
      } else {
        List<String> jadwal = item.jamKerja.split('-');
        // Cek Check In
        bool checkin = isTimeBeforeJadwalCheckIn(
            DateFormat('HH:mm').format(item.jamMasuk), jadwal[0]);
        if (checkin == false) {
          count++;
        }
      }
    }
    telat.value = count.toString();
    hariMasuk.value = counthari.toString();
  }

  void handleAbsensiTerakhir() {
    DataAbsenModel data = listAbsen[0];
    if (data.jamMasuk == data.jamKeluar) {
      doneCheckIn.value = DateFormat('HH:mm', 'id_ID').format(data.jamMasuk);
      if (data.idShift != '') {
        isEmptySelectedShift.value = false;
        selectedShift = listShiftAll.firstWhere(
          (shift) => shift.id == data.idShift,
        );
        List<String> jadwal = data.jamKerja.split('-');
        jadwalCheckIn.value = jadwal[0];
        jadwalCheckOut.value = jadwal[1];
      }
    }
  }

  void getAbsenHariIni() {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);

    List<DataAbsenModel> absenHariIni = [];

    for (var absen in listAbsen) {
      final absenDate = DateFormat('yyyy-MM-dd').format(absen.jamMasuk);

      if (absenDate == today) {
        absenHariIni.add(absen);
      }
    }

    if (absenHariIni.isNotEmpty) {
      DataAbsenModel data = absenHariIni[0];
      if (data.jamMasuk == data.jamKeluar) {
        doneCheckIn.value = DateFormat('HH:mm').format(data.jamMasuk);
        if (data.jamMasuk != data.jamKeluar) {
          doneCheckOut.value = DateFormat('HH:mm').format(data.jamMasuk);
        }
      }
    }
  }

  Future<void> checkIn() async {
    isLoadingCheckIn.value = true;
    try {
      bool lanjutCheckin = true;
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        CustomToast.errorToast("Error", "Aktifkan izin lokasi");
        lanjutCheckin = false;
        return;
      } else if (await LocationHelper.isUsingMockLocation() &&
          PegawaiData.isNotNando()) {
        CustomToast.errorToast("Opsi Pengembang Aktif",
            "Nonaktifkan opsi pengembang dan coba lagi");
        lanjutCheckin = false;
      } else if (PegawaiData.kodepegawai == '' && PegawaiData.isAdmin == true) {
        CustomToast.errorToast("Error", "Anda bukan pegawai");
        lanjutCheckin = false;
      } else if (selectedShift == null) {
        CustomToast.errorToast("Error", "Shift belum dipilih");
        lanjutCheckin = false;
      } else {
        DateTime absenMasuklast = await handleCekAbsenMasuk();
        if (absenMasuklast.isBefore(DateTime.now())) {
          CustomToast.errorToast("Error",
              "Anda tidak bisa absen masuk karena masih belum absen keluar!");
          lanjutCheckin = false;
        }
      }

      if (lanjutCheckin) {
        Get.toNamed(Routes.CHECKIN);
      }
    } catch (e) {
      CustomToast.errorToast("Error", "Terjadi Kesalahan : ${e.toString()}");
    } finally {
      isLoadingCheckIn.value = false;
    }
  }

  Future<DateTime> handleCekAbsenMasuk() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineAbsensiService serviceOnline = OnlineAbsensiService();
      return await serviceOnline.cekAbsenMasuk();
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      return await serviceAbsensi.cekAbsenMasuk();
    }
    return DateTime.now();
  }

  Future<void> checkOut() async {
    isLoadingCheckIn.value = true;
    try {
      String idAbsensi = await handleCekIdAbsensi();
      if (idAbsensi == '0') {
        CustomToast.errorToast(
            "Error", "Anda belum absen masuk tidak bisa absen keluar!");
      } else {
        TimeOfDay timenow = TimeOfDay.now();
        TimeOfDay jadwalOut = DateHelper.stringToTime(jadwalCheckOut.value);
        TimeOfDay jadwalIn = DateHelper.stringToTime(jadwalCheckIn.value);
        bool beforeCheckOut =
            DateHelper.isTimeBeforeEndTime(timenow, jadwalOut);
        bool afterCheckIn = DateHelper.isTimeBeforeEndTime(jadwalIn, timenow);
        if (beforeCheckOut && afterCheckIn) {
          CustomAlertDialog.showDialogAlert(
            title: 'Belum Waktunya Absen Keluar',
            message: 'Apakah anda ingin\nabsen keluar sekarang?',
            type: 'info',
            onConfirm: () async {
              await handleSimpanAbsenKeluar(idAbsensi);
              Get.back();
              CustomToast.successToast("Success", "Berhasil Absen Keluar");

              // Refresh Data
              doneCheckIn.value = '';
              doneCheckOut.value = '';
              if (GlobalData.statusShift) {
                isEmptySelectedShift.value = true;
                selectedShift = null;
                jadwalCheckIn.value = '-';
                jadwalCheckOut.value = '-';
              }
              getInit();
            },
            onCancel: () => Get.back(),
          );
        } else {
          await handleSimpanAbsenKeluar(idAbsensi);
          CustomToast.successToast("Success", "Berhasil Absen Keluar");
          doneCheckIn.value = '';
          doneCheckOut.value = '';
          if (GlobalData.statusShift) {
            isEmptySelectedShift.value = true;
            selectedShift = null;
            jadwalCheckIn.value = '-';
            jadwalCheckOut.value = '-';
          }
          getInit();
        }
      }
    } catch (e) {
      CustomToast.errorToast("Error", "Terjadi Kesalahan : ${e.toString()}");
    } finally {
      isLoadingCheckIn.value = false;
    }
  }

  Future<String> handleCekIdAbsensi() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineAbsensiService serviceOnline = OnlineAbsensiService();
      return await serviceOnline.cekIDAbsensi();
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      return await serviceAbsensi.cekIDAbsensi();
    }
    return '';
  }

  handleSimpanAbsenKeluar(String idAbsensi) async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineAbsensiService serviceOnline = OnlineAbsensiService();
      await serviceOnline.simpanAbsenKeluar(id: idAbsensi);
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      await serviceAbsensi.simpanAbsenKeluar(id: idAbsensi);
    }
  }

  bool isTimeBeforeJadwalCheckIn(String absen, String jadwal) {
    if (absen == '-' || jadwal == '-') {
      return false;
    } else {
      TimeOfDay time1 = DateHelper.stringToTime(absen);
      TimeOfDay time2 = DateHelper.stringToTime(jadwal);
      time2 = addOneMinute(time2);
      return DateHelper.isTimeBeforeEndTime(time1, time2);
    }
  }

  TimeOfDay addOneMinute(TimeOfDay time) {
    return TimeOfDay(hour: time.hour, minute: time.minute + 1);
  }

  Future<void> pilihShift() async {
    if (listShift.isEmpty) {
      CustomToast.errorToast("Error", "Tidak ada shift hari ini!");
    } else {
      isEmptySelectedShift.value = true;
      selectedShift = await Get.to(
        SelectShiftPage(
          list: listShift,
        ),
      );
      if (selectedShift != null) {
        afterSelectShift(selectedShift!);
      }
    }
  }

  void afterSelectShift(DataShiftModel data) {
    selectedShift = data;
    isEmptySelectedShift.value = false;
    // Handle jadwal shift
    TimeOfDay jadwalMasuk = DateHelper.stringToTime(data.jamMasuk);
    TimeOfDay jadwalKeluar = DateHelper.stringToTime(data.jamKeluar);
    jadwalCheckIn.value =
        '${jadwalMasuk.hour}:${jadwalMasuk.minute.toString().padLeft(2, '0')}';

    jadwalCheckOut.value =
        '${jadwalKeluar.hour}:${jadwalKeluar.minute.toString().padLeft(2, '0')}';

    update();
    Get.back();
  }
}
