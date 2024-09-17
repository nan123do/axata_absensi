import 'dart:convert';
import 'dart:typed_data';

import 'package:axata_absensi/components/loading_screen.dart';
import 'package:axata_absensi/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/components/filter_multimap.dart';
import 'package:axata_absensi/components/filter_singlemap.dart';
import 'package:axata_absensi/models/Absensi/dataabsen_model.dart';
import 'package:axata_absensi/models/Pegawai/datapegawai_model.dart';
import 'package:axata_absensi/models/Shift/datashift_model.dart';
import 'package:axata_absensi/pages/absensi/views/addabsensi_view.dart';
import 'package:axata_absensi/pages/absensi/views/detailabsensi_view.dart';
import 'package:axata_absensi/pages/home/views/selectshift.dart';
import 'package:axata_absensi/services/absensi_service.dart';
import 'package:axata_absensi/components/filter_helper.dart';
import 'package:axata_absensi/services/online/online_absensi_service.dart';
import 'package:axata_absensi/services/online/online_shift_service.dart';
import 'package:axata_absensi/services/online/online_user_service.dart';
import 'package:axata_absensi/services/shift_service.dart';
import 'package:axata_absensi/utils/datehelper.dart';
import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AbsensiController extends GetxController {
  final ScrollController scrollC = ScrollController();
  TextEditingController tarifC = TextEditingController(text: '');
  TextEditingController keteranganC = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isLoadingNextPage = false.obs;
  RxBool firstData = true.obs;
  RxString telat = '0'.obs;
  RxString tepatWaktu = '0'.obs;
  RxString selectedDate = 'Hari Ini'.obs;
  DateTime dateFrom = DateTime.now();
  DateTime dateTo = DateTime.now();
  RxString selectedLaporan = 'Semua'.obs;
  RxString selectedPegawai = 'Semua'.obs;
  List<String> listLaporan = ['Semua', 'Tepat Waktu', 'Telat'];
  List<Map<String, Object>> listPegawai = [];
  List<DataPegawaiModel> listPegawaiAll = [];

  // Add Data
  DateTime now = DateTime.now();
  RxInt totalAbsen = 0.obs;
  RxString pegawai = '-'.obs;
  RxString kodePegawai = '-'.obs;
  RxBool statusCheckOut = false.obs;
  Rx<DataShiftModel?> selectedShift = Rx<DataShiftModel?>(null);
  Rx<TimeOfDay> timeIn = TimeOfDay(hour: DateTime.now().hour, minute: 0).obs;
  Rx<TimeOfDay> timeOut = TimeOfDay(hour: DateTime.now().hour, minute: 0).obs;
  Rx<DateTime> dateMasuk = DateTime.now().obs;
  Rx<DateTime> dateKeluar = DateTime.now().obs;

  AbsensiService serviceAbsensi = AbsensiService();
  ShiftService serviceShift = ShiftService();
  UserService serviceUser = UserService();
  List<DataAbsenModel> listAbsen = [];
  List<DataShiftModel> listShift = [];
  RxBool isPaginating = false.obs;
  var rotationAngle = 0.0.obs;

  // Pagination
  var page = 1.obs;
  String nextUrl = '';

  @override
  void onInit() {
    super.onInit();
    scrollC.addListener(() {
      if (GlobalData.globalKoneksi == Koneksi.online) {
        // Check if the scroll position reached the bottom of the list
        if (scrollC.position.pixels == scrollC.position.maxScrollExtent) {
          isPaginating(true);
          page.value = page.value + 1;
          getNextData();
        }
      }
    });

    isLoading.value = true;
    getInit();
  }

  getInit() async {
    try {
      if (PegawaiData.isAdmin == false) {
        isPegawaiData();
      } else {
        await handleDataPegawai();
      }

      await handleDataShift();

      // list Absen
      refreshData();
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      firstData.value = true;
    }
  }

  getNextData() async {
    if (isLoadingNextPage.isTrue) return;
    isLoadingNextPage.value = true;
    if (isPaginating.isFalse) {
      listAbsen = [];
    }

    try {
      // Get All absen
      await handleDataAbsensi();

      if (selectedLaporan.value != 'Semua') {
        filterLaporan();
      }
    } catch (e) {
      CustomToast.errorToast(
        "Error",
        'Gagal mengambil data, silahkan coba lagi',
      );
    } finally {
      isLoadingNextPage.value = false;
    }
  }

  refreshData() async {
    isLoading.value = true;
    firstData.value = false;
    if (isPaginating.isFalse) {
      listAbsen = [];
    }

    try {
      // Get All absen
      await handleDataAbsensi();

      if (selectedLaporan.value != 'Semua') {
        filterLaporan();
      }
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  handleDataAbsensi() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineAbsensiService serviceAbsensiOnline = OnlineAbsensiService();
      PaginatedAbsensi paginate = await serviceAbsensiOnline.getDataAbsensi(
        namaPegawai: selectedPegawai.value,
        dateFrom: DateFormat('yyyy-MM-dd').format(dateFrom),
        dateTo: DateFormat('yyyy-MM-dd').format(dateTo),
        nameSorting: 'JAM MASUK',
        sort: 'Descending',
        page: isPaginating.isTrue ? page.value : 1,
      );

      if (isPaginating.isFalse) {
        listAbsen = paginate.results;
      } else {
        listAbsen.addAll(paginate.results);
        isPaginating(false);
      }
      totalAbsen.value = paginate.count;
      telat.value = AxataTheme.currency.format(paginate.telat);
      tepatWaktu.value =
          AxataTheme.currency.format(paginate.count - paginate.telat);
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      listAbsen = await serviceAbsensi.getDataAbsensi(
        namaPegawai: selectedPegawai.value,
        dateFrom: DateFormat('yyyy-MM-dd').format(dateFrom),
        dateTo: DateFormat('yyyy-MM-dd').format(dateTo),
        nameSorting: 'JAM MASUK',
        sort: 'Descending',
      );
      totalAbsen.value = listAbsen.length;
      getTelat();
    }
  }

  handleDataShift() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineShiftService serviceOnline = OnlineShiftService();
      listShift = await serviceOnline.getShift(
        hari: '',
        status: '1',
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      listShift = await serviceShift.getShift(
        hari: '',
        status: '1',
      );
    }
  }

  handleDataPegawai() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineUserService serviceUserOnline = OnlineUserService();
      List<DataPegawaiModel> pegawai = await serviceUserOnline.getDataPegawai();
      listPegawaiAll = pegawai;
      listPegawai = pegawai.map((item) {
        return {'name': item.nama, 'checked': false};
      }).toList();
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      List<DataPegawaiModel> pegawai =
          await serviceUser.getDataPegawai(namaPegawai: '');
      listPegawaiAll = pegawai;
      listPegawai = pegawai.map((item) {
        return {'name': item.nama, 'checked': false};
      }).toList();
    }
  }

  isPegawaiData() {
    selectedDate = 'Bulan Ini'.obs;
    dateFrom = DateTime(dateFrom.year, dateFrom.month, 1);
    dateTo = DateTime(dateTo.year, dateTo.month + 1, 0);

    selectedPegawai.value = PegawaiData.nama;
  }

  onDateChanged(DateTime newDateFrom, DateTime newDateTo, String selected) {
    dateFrom = newDateFrom;
    dateTo = newDateTo;
    // dateFromText = DateFormat('dd MMMM yyyy', 'id_ID').format(dateFrom);
    // dateToText = DateFormat('dd MMMM yyyy', 'id_ID').format(dateTo);
    selectedDate.value = selected;

    refreshData();
  }

  void filterLaporan() {
    List<DataAbsenModel> listTepat = [];
    List<DataAbsenModel> listTelat = [];
    for (var item in listAbsen) {
      String hasil = '-';
      if (item.jamKerja != '') {
        List<String> jadwal = item.jamKerja.split('-');
        hasil = jadwal[0];
        if (isTimeBeforeJadwalCheckIn(
          DateFormat('HH:mm').format(item.jamMasuk),
          hasil,
        )) {
          listTepat.add(item);
        } else {
          listTelat.add(item);
        }
      }
    }
    switch (selectedLaporan.value) {
      case 'Tepat Waktu':
        listAbsen = listTepat;
        break;
      case 'Telat':
        listAbsen = listTelat;
        break;
      default:
    }
  }

  void getTelat() {
    int count = 0;
    Set<String> uniqueDates = {};

    for (DataAbsenModel item in listAbsen) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(item.jamMasuk);

      // Menghitung jumlah hari unik
      if (!uniqueDates.contains(formattedDate)) {
        uniqueDates.add(formattedDate);
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
    telat.value = AxataTheme.currency.format(count);
    tepatWaktu.value = AxataTheme.currency.format(listAbsen.length - count);
  }

  void openModalFilterJenis(BuildContext context) {
    String laporan = selectedLaporan.value;
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        List<Map> tempPegawai = listPegawai;
        return Container(
          height: 0.4.sh,
          padding: EdgeInsets.symmetric(
            horizontal: 60.w,
            vertical: 40.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(
                    left: 10.w,
                  ),
                  children: [
                    FilterMapPage(
                      title: 'Pegawai',
                      data: tempPegawai,
                      onDataChanged: (value) {
                        tempPegawai = value;
                      },
                    ),
                    SizedBox(height: 12.h),
                    FilterSingleMapPage(
                      title: 'Absensi',
                      selected: selectedLaporan.value,
                      data: listLaporan,
                      onDataChanged: (String value) {
                        laporan = value;
                      },
                    ),
                  ],
                ),
              ),
              AxataTheme.styleJarak12,
              GestureDetector(
                onTap: () {
                  selectedLaporan.value = laporan;
                  selectedPegawai.value =
                      FilterCustomHelper.selectedMultiFilter(tempPegawai);
                  Get.back();
                  refreshData();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 20.h,
                  ),
                  alignment: Alignment.center,
                  decoration: AxataTheme.styleGradient,
                  child: Text(
                    'Terapkan',
                    style: AxataTheme.oneBold.copyWith(
                      color: AxataTheme.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        );
      },
    );
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

  goAddPage() {
    pegawai.value = '-';
    kodePegawai.value = '-';
    selectedShift = Rx<DataShiftModel?>(null);
    timeIn.value =
        TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
    timeOut.value =
        TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
    tarifC.text = '';
    keteranganC.text = '';
    statusCheckOut.value = false;
    Get.to(
      () => const AddAbsensiView(
        type: 'tambah',
      ),
    );
  }

  goDetailPage(DataAbsenModel data) async {
    Get.back();

    // Get Color
    String jamKerja = '-';
    if (data.jamKerja != '') {
      List<String> jadwal = data.jamKerja.split('-');
      jamKerja = jadwal[0];
    }

    Color color = isTimeBeforeJadwalCheckIn(
      DateFormat('HH:mm').format(data.jamMasuk),
      jamKerja,
    )
        ? AxataTheme.green
        : AxataTheme.red;

    if (GlobalData.globalKoneksi == Koneksi.online) {
      final response = await http.head(Uri.parse(
          'http://${GlobalData.globalAPI}${GlobalData.globalPort}${data.foto}'));

      if (response.statusCode == 200) {
        // Jika gambar tersedia, lakukan navigasi
        Get.to(
          () => DetailAbsensiView(
            tanggal: data.jamMasuk,
            color: color,
            url: data.foto,
          ),
        );
      } else {
        Get.to(
          () => DetailAbsensiView(
            tanggal: data.jamMasuk,
            color: color,
            url: null,
          ),
        );
      }
    } else {
      if (data.foto != '') {
        LoadingScreen.show();
        String base64Str =
            await serviceAbsensi.getGambarBase64(foto: data.foto);
        LoadingScreen.hide();
        Uint8List bytes = base64Decode(base64Str);
        Get.to(
          () => DetailAbsensiView(
            foto: bytes,
            tanggal: data.jamMasuk,
            color: color,
          ),
        );
      } else {
        Get.to(
          () => DetailAbsensiView(
            foto: null,
            tanggal: data.jamMasuk,
            color: color,
          ),
        );
      }
    }
  }

  goUbahPage(DataAbsenModel data) {
    Get.back();
    pegawai.value = data.nama;
    kodePegawai.value =
        listPegawaiAll.firstWhere((item) => item.nama == data.nama).kode;
    selectedShift.value =
        listShift.firstWhere((item) => item.id == data.idShift);

    // handle time
    dateMasuk.value =
        DateTime(data.jamMasuk.year, data.jamMasuk.month, data.jamMasuk.day);
    dateKeluar.value =
        DateTime(data.jamKeluar.year, data.jamKeluar.month, data.jamKeluar.day);
    timeIn.value =
        TimeOfDay(hour: data.jamMasuk.hour, minute: data.jamMasuk.minute);
    timeOut.value =
        TimeOfDay(hour: data.jamKeluar.hour, minute: data.jamKeluar.minute);

    if (data.jamMasuk == data.jamKeluar) {
      statusCheckOut.value = false;
    } else {
      statusCheckOut.value = true;
    }

    tarifC.text = AxataTheme.currency.format(data.tarif);
    keteranganC.text = data.keterangan;
    Get.to(
      () => AddAbsensiView(
        type: 'ubah',
        id: data.id,
      ),
    );
  }

  void goDialogAbsensi(
    DataAbsenModel data,
  ) {
    Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.symmetric(vertical: 25.h),
      titleStyle: const TextStyle(fontSize: 0),
      content: Column(
        children: [
          GestureDetector(
            onTap: () => goDetailPage(data),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'Lihat Foto',
                style: AxataTheme.threeSmall,
              ),
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () => goUbahPage(data),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'Ubah',
                style: AxataTheme.threeSmall,
              ),
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () {
              handleHapus(data.id, data.foto);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'Hapus',
                style: AxataTheme.threeSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void afterSelectPegawai(DataPegawaiModel data) {
    pegawai.value = data.nama;
    kodePegawai.value = data.kode;

    update();
    Get.back();
  }

  // Fungsi untuk menambah rotasi sebesar 90 derajat
  void rotateImage() {
    rotationAngle.value += 90.0;
    if (rotationAngle.value >= 360.0) {
      rotationAngle.value = 0.0; // Reset jika rotasi mencapai 360 derajat
    }
  }

  Future<void> pilihShift() async {
    String namaHari = DateFormat('EEEE', 'id_ID').format(dateMasuk.value);
    List<DataShiftModel> list = listShift
        .where(
          (shift) => shift.hari.trim() == namaHari && shift.statusAktif,
        )
        .toList();

    DataShiftModel? shift = await Get.to(
      () => SelectShiftPage(
        list: list,
      ),
    );
    if (shift != null) {
      selectedShift.value = shift;
    }
  }

  handleDatePick(BuildContext context, bool isMasuk) {
    updateDate(DateTime newDate, String newDateText) {
      if (newDate.isBefore(now)) {
        if (isMasuk) {
          dateMasuk.value = newDate;
        } else {
          dateKeluar.value = newDate;
        }
      } else {
        CustomToast.errorToast(
            'Eroor', 'Tanggal tidak boleh lebih dari hari ini');
      }
    }

    DateHelper.listDatePickerV2(
      context,
      'dd/MM/yyyy',
      isMasuk ? dateMasuk.value : dateKeluar.value,
      '',
      updateDate,
    );
  }

  handleTimePick(BuildContext context, bool isMasuk) {
    updateTime(TimeOfDay newTime, String newDateText) {
      if (isMasuk) {
        timeIn.value = newTime;
      } else {
        timeOut.value = newTime;
      }
    }

    DateHelper.datePickerTime(
      context,
      isMasuk ? timeIn.value : timeOut.value,
      updateTime,
    );
  }

  handleTambah() async {
    if (pegawai.value != '-' &&
        selectedShift.value != null &&
        tarifC.text != '') {
      isLoading.value = true;
      try {
        String jadwalMasuk =
            DateHelper.strHMStoHM(selectedShift.value!.jamMasuk);
        String jadwalKeluar =
            DateHelper.strHMStoHM(selectedShift.value!.jamKeluar);

        DateTime masuk = dateMasuk.value;
        masuk = DateTime(masuk.year, masuk.month, masuk.day, timeIn.value.hour,
            timeIn.value.minute);
        DateTime keluar = dateKeluar.value;
        keluar = DateTime(keluar.year, keluar.month, keluar.day,
            timeOut.value.hour, timeOut.value.minute);

        if (statusCheckOut.isFalse) {
          keluar = masuk;
        }

        if (masuk == keluar && statusCheckOut.isTrue) {
          CustomToast.errorToast(
              'Error', 'jam masuk dan jam keluar tidak boleh sama');
        } else {
          if (GlobalData.globalKoneksi == Koneksi.online) {
            OnlineAbsensiService serviceOnline = OnlineAbsensiService();
            await serviceOnline.simpanAbsensi(
              keterangan: keteranganC.text,
              idShift: selectedShift.value!.id.toString(),
              jamKerja: '$jadwalMasuk-$jadwalKeluar',
              tarif: tarifC.text,
              iduser: kodePegawai.value,
              masuk: DateFormat('yyyy-MM-dd HH:mm:ss').format(masuk),
              keluar: DateFormat('yyyy-MM-dd HH:mm:ss').format(keluar),
            );
          } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
            await serviceAbsensi.simpanAbsensi(
              keterangan: keteranganC.text,
              idShift: selectedShift.value!.id.toString(),
              jamKerja: '$jadwalMasuk-$jadwalKeluar',
              tarif: tarifC.text,
              kodePegawai: kodePegawai.value,
              masuk: DateFormat('yyyy-MM-dd HH:mm:ss').format(masuk),
              keluar: DateFormat('yyyy-MM-dd HH:mm:ss').format(keluar),
            );
          }
          Get.back();
          CustomToast.successToast("Success", "Absen Berhasil Disimpan");
        }
      } catch (e) {
        CustomToast.errorToast("Error", e.toString());
      } finally {
        isLoading.value = false;
        refreshData();
      }
    } else {
      CustomToast.errorToast('Error', 'Semua form harus diisi');
    }
  }

  handleUbah(String id) async {
    if (pegawai.value != '-' &&
        selectedShift.value != null &&
        tarifC.text != '') {
      isLoading.value = true;
      try {
        String jadwalMasuk =
            DateHelper.strHMStoHM(selectedShift.value!.jamMasuk);
        String jadwalKeluar =
            DateHelper.strHMStoHM(selectedShift.value!.jamKeluar);

        DateTime masuk = dateMasuk.value;
        masuk = DateTime(masuk.year, masuk.month, masuk.day, timeIn.value.hour,
            timeIn.value.minute);
        DateTime keluar = dateKeluar.value;
        keluar = DateTime(keluar.year, keluar.month, keluar.day,
            timeOut.value.hour, timeOut.value.minute);

        if (statusCheckOut.isFalse) {
          keluar = masuk;
        }

        if (masuk == keluar && statusCheckOut.isTrue) {
          CustomToast.errorToast(
              'Error', 'jam masuk dan jam keluar tidak boleh sama');
        } else {
          if (GlobalData.globalKoneksi == Koneksi.online) {
            OnlineAbsensiService serviceOnline = OnlineAbsensiService();
            await serviceOnline.ubahAbsensi(
              id: id,
              keterangan: keteranganC.text,
              idShift: selectedShift.value!.id.toString(),
              jamKerja: '$jadwalMasuk-$jadwalKeluar',
              tarif: tarifC.text,
              iduser: kodePegawai.value,
              masuk: DateFormat('yyyy-MM-dd HH:mm:ss').format(masuk),
              keluar: DateFormat('yyyy-MM-dd HH:mm:ss').format(keluar),
            );
          } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
            await serviceAbsensi.ubahAbsensi(
              id: id,
              keterangan: keteranganC.text,
              idShift: selectedShift.value!.id.toString(),
              jamKerja: '$jadwalMasuk-$jadwalKeluar',
              tarif: tarifC.text,
              kodePegawai: kodePegawai.value,
              masuk: DateFormat('yyyy-MM-dd HH:mm:ss').format(masuk),
              keluar: DateFormat('yyyy-MM-dd HH:mm:ss').format(keluar),
            );
          }
          Get.back();
          CustomToast.successToast("Success", "Absen Berhasil Diubah");
          getInit();
        }
      } catch (e) {
        CustomToast.errorToast("Error", e.toString());
      } finally {
        isLoading.value = false;
        refreshData();
      }
    } else {
      CustomToast.errorToast('Error', 'Semua form harus diisi');
    }
  }

  void handleHapus(String id, String foto) async {
    isLoading.value = true;
    try {
      if (GlobalData.globalKoneksi == Koneksi.online) {
        OnlineAbsensiService serviceOnline = OnlineAbsensiService();
        await serviceOnline.hapusAbsensi(id: id);
      } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
        await serviceAbsensi.hapusAbsensi(id: id, foto: foto);
      }
      Get.back();
      CustomToast.successToast("Success", "Absen Berhasil Dihapus");
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
      refreshData();
    }
  }
}
