import 'dart:async';

import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/models/Absensi/dataabsen_model.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/services/absensi_service.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;

  // Absensi Today
  RxBool isTimeCheckIn = false.obs;
  RxBool isTimeCheckOut = false.obs;
  TimeOfDay timeIn = const TimeOfDay(hour: 8, minute: 0);
  RxString jadwalCheckIn = ''.obs;
  TimeOfDay timeOut = const TimeOfDay(hour: 11, minute: 22);
  RxString jadwalCheckOut = ''.obs;
  RxString doneCheckIn = ''.obs;
  RxString doneCheckOut = ''.obs;

  RxString timeCheckIn = ''.obs;
  String dateText =
      DateFormat('EEEE dd MMMM yyyy', 'id_ID').format(DateTime.now());
  Timer? timer;

  AbsensiService serviceAbsensi = AbsensiService();
  List<DataAbsenModel> listAbsen = [];

  // DateTime
  DateTime dateFrom = DateTime.now();
  DateTime dateTo = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getInit();
  }

  getInit() async {
    // Init Jadwal
    jadwalCheckIn =
        '${timeIn.hour}:${timeIn.minute.toString().padLeft(2, '0')}'.obs;
    isTimeCheckIn = isTimeCheckInOut(true).obs;
    doneCheckIn.value = '07:50';

    jadwalCheckOut =
        '${timeOut.hour}:${timeOut.minute.toString().padLeft(2, '0')}'.obs;
    isTimeCheckOut = isTimeCheckInOut(false).obs;

    // Get Data Absensi
    try {
      // Mendapatkan tanggal awal bulan ini
      DateTime firstDayOfMonth = DateTime(dateFrom.year, dateFrom.month, 1);

      // Mendapatkan tanggal akhir bulan ini
      DateTime lastDayOfMonth = DateTime(dateTo.year, dateTo.month + 1, 0);

      listAbsen = await serviceAbsensi.getDataAbsensi(
        namaPegawai:
            PegawaiData.nama == '' ? GlobalData.username : PegawaiData.nama,
        dateFrom: DateFormat('yyyy-MM-dd').format(firstDayOfMonth),
        dateTo: DateFormat('yyyy-MM-dd').format(lastDayOfMonth),
      );
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }

    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _getUpdateCheckTime();
    });

    isLoading.value = false;
  }

  _getUpdateCheckTime() {
    isTimeCheckIn.value = isTimeCheckInOut(true);
    isTimeCheckOut.value = isTimeCheckInOut(false);
  }

  bool isTimeBeforeCurrentTime(TimeOfDay myTime, TimeOfDay current) {
    // Dapatkan waktu saat ini
    TimeOfDay currentTime = current;

    // Bandingkan myTime dengan waktu saat ini
    if (myTime.hour < currentTime.hour ||
        (myTime.hour == currentTime.hour &&
            myTime.minute < currentTime.minute)) {
      // myTime sebelum waktu saat ini
      return true;
    } else {
      // myTime setelah atau sama dengan waktu saat ini
      return false;
    }
  }

  bool isTimeCheckInOut(bool isCheckin) {
    TimeOfDay time = isCheckin ? timeIn : timeOut;

    // Mengurangkan satu menit dari waktu
    TimeOfDay adjustedTime = const TimeOfDay(hour: 0, minute: 0);
    if (isCheckin) {
      adjustedTime = TimeOfDay(hour: time.hour - 2, minute: time.minute);
    } else {
      adjustedTime = TimeOfDay(hour: time.hour, minute: time.minute - 1);
    }

    return isTimeBeforeCurrentTime(adjustedTime, TimeOfDay.now());
  }

  void checkIn() {
    isLoading.value = true;
    try {
      Get.toNamed(Routes.CHECKIN);
      // CustomToast.successToast("Success", "Berhasil Check In");
    } catch (e) {
      CustomToast.errorToast("Error", "Terjadi Kesalahan : ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void checkOut() {
    isLoading.value = true;
    try {
      doneCheckOut.value = '12:50';
      CustomToast.successToast("Success", "Berhasil Check Out");
    } catch (e) {
      CustomToast.errorToast("Error", "Terjadi Kesalahan : ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  bool isTimeBeforeJadwalCheckIn(String value) {
    if (value == '-') {
      return false;
    } else {
      TimeOfDay currentTime = stringToTime(value);
      return isTimeBeforeCurrentTime(currentTime, timeIn);
    }
  }

  bool isTimeAfterJadwalCheckOut(String value) {
    if (value == '-') {
      return false;
    } else {
      TimeOfDay currentTime = stringToTime(value);
      return isTimeBeforeCurrentTime(timeOut, currentTime);
    }
  }

  TimeOfDay stringToTime(String value) {
    List<String> timeComponents = value.split(':');
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1]);

    return TimeOfDay(hour: hour, minute: minute);
  }
}
