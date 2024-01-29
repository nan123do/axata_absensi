import 'dart:async';

import 'package:axata_absensi/components/custom_dialog.dart';
import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/models/Absensi/dataabsen_model.dart';
import 'package:axata_absensi/models/Shift/datashift_model.dart';
import 'package:axata_absensi/pages/home/views/selectshift.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/services/absensi_service.dart';
import 'package:axata_absensi/services/helper_service.dart';
import 'package:axata_absensi/services/shift_service.dart';
import 'package:axata_absensi/utils/datehelper.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:flutter/material.dart';
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
    isLoading.value = true;
    getInit();
  }

  getInit() async {
    // Get Data Absensi
    try {
      // Mendapatkan tanggal awal bulan ini
      DateTime firstDayOfMonth = DateTime(dateFrom.year, dateFrom.month, 1);

      // Mendapatkan tanggal akhir bulan ini
      DateTime lastDayOfMonth = DateTime(dateTo.year, dateTo.month + 1, 0);

      String kodeSetting = serviceHelper.getKodeSetting('StatusShift');
      statusShift.value = await serviceHelper.strSetting(
        kodeSetting: kodeSetting,
      );

      // Get All Shift
      listShiftAll = await serviceShift.getShift(
        hari: '',
        status: '1',
      );
      String namaHariIni = DateFormat('EEEE', 'id_ID').format(DateTime.now());
      listShift =
          listShiftAll.where((shift) => shift.hari == namaHariIni).toList();
      if (statusShift.value == '0') {
        List<DataShiftModel> defaultShift = listShiftAll
            .where(
                (shift) => shift.hari == namaHariIni && shift.nama == 'default')
            .toList();
        afterSelectShift(defaultShift.first);
      } else {
        listShift = listShiftAll;
        listShift.removeWhere((item) => item.nama == 'default');
      }

      // Get All absen
      listAbsen = await serviceAbsensi.getDataAbsensi(
        namaPegawai:
            PegawaiData.nama == '' ? GlobalData.username : PegawaiData.nama,
        dateFrom: DateFormat('yyyy-MM-dd').format(firstDayOfMonth),
        dateTo: DateFormat('yyyy-MM-dd').format(lastDayOfMonth),
        nameSorting: 'JAM MASUK',
        sort: 'Descending',
      );
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
      if (PegawaiData.kodepegawai == '') {
        CustomToast.errorToast("Error", "Anda bukan pegawai");
        lanjutCheckin = false;
      } else if (selectedShift == null) {
        CustomToast.errorToast("Error", "Shift belum dipilih");
        lanjutCheckin = false;
      } else {
        DateTime absenMasuklast = await serviceAbsensi.cekAbsenMasuk();
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

  Future<void> handleAfterCheckOut() async {
    isLoading.value = true;
    try {
      DateTime firstDayOfMonth = DateTime(dateFrom.year, dateFrom.month, 1);
      DateTime lastDayOfMonth = DateTime(dateTo.year, dateTo.month + 1, 0);

      // Get All absen
      listAbsen = await serviceAbsensi.getDataAbsensi(
        namaPegawai:
            PegawaiData.nama == '' ? GlobalData.username : PegawaiData.nama,
        dateFrom: DateFormat('yyyy-MM-dd').format(firstDayOfMonth),
        dateTo: DateFormat('yyyy-MM-dd').format(lastDayOfMonth),
        nameSorting: 'JAM MASUK',
        sort: 'Descending',
      );
      if (listAbsen.isNotEmpty) {
        getTelat();
        getAbsenHariIni();
        handleAbsensiTerakhir();
      }

      // Refresh Data
      doneCheckIn.value = '';
      doneCheckOut.value = '';
      isEmptySelectedShift.value = true;
      selectedShift = null;
      jadwalCheckIn.value = '-';
      jadwalCheckOut.value = '-';
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkOut() async {
    isLoadingCheckIn.value = true;
    try {
      String idAbsensi = await serviceAbsensi.cekIDAbsensi();
      if (idAbsensi == '0') {
        CustomToast.errorToast(
            "Error", "Anda belum absen masuk tidak bisa absen keluar!");
      } else {
        TimeOfDay jadwalOut = DateHelper.stringToTime(jadwalCheckOut.value);
        bool beforeCheckOut =
            DateHelper.isTimeBeforeEndTime(TimeOfDay.now(), jadwalOut);
        if (beforeCheckOut) {
          CustomAlertDialog.showDialogAlert(
            title: 'Belum Waktunya Check Out',
            message: 'Apakah anda ingin\ncheck-out sekarang?',
            type: 'info',
            onConfirm: () async {
              await serviceAbsensi.simpanAbsenKeluar(id: idAbsensi);
              Get.back();
              CustomToast.successToast("Success", "Berhasil Check Out");

              // Refresh Data
              doneCheckIn.value = '';
              doneCheckOut.value = '';
              isEmptySelectedShift.value = true;
              selectedShift = null;
              jadwalCheckIn.value = '-';
              jadwalCheckOut.value = '-';
              handleAfterCheckOut();
            },
            onCancel: () => Get.back(),
          );
        } else {
          serviceAbsensi.simpanAbsenKeluar(id: idAbsensi);
          CustomToast.successToast("Success", "Berhasil Check Out");
          doneCheckIn.value = '';
          doneCheckOut.value = '';
        }
      }
    } catch (e) {
      CustomToast.errorToast("Error", "Terjadi Kesalahan : ${e.toString()}");
    } finally {
      isLoadingCheckIn.value = false;
    }
  }

  bool isTimeBeforeJadwalCheckIn(String absen, String jadwal) {
    if (absen == '-' || jadwal == '-') {
      return false;
    } else {
      TimeOfDay time1 = DateHelper.stringToTime(absen);
      TimeOfDay time2 = DateHelper.stringToTime(jadwal);
      return DateHelper.isTimeBeforeEndTime(time1, time2);
    }
  }

  void pilihShift() {
    if (listShift.isEmpty) {
      CustomToast.errorToast("Error", "Tidak ada shift hari ini!");
    } else {
      isEmptySelectedShift.value = true;
      Get.to(
        SelectShiftPage(
          list: listShift,
          controller: this,
        ),
      );
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
