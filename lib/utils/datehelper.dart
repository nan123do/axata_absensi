import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateHelper {
  static DateTime convertStringToDateTime(String dateString) {
    List<String> formats = [
      'yyyy-MM-dd HH:mm:ss',
      'dd/MM/yyyy HH:mm:ss',
      'yyyy-MM-ddTHH:mm:ss',
      'yyyy-MM-dd',
      'HH:mm:ss',
      'dd/MM/yyyy',
    ];

    for (String format in formats) {
      try {
        DateTime dateTime = DateFormat(format).parse(dateString);
        return dateTime;
      } catch (e) {
        // Coba format berikutnya jika konversi gagal
      }
    }

    // Jika tidak ada format yang sesuai
    throw Exception('Invalid date format');
  }

  static TimeOfDay stringToTime(String value) {
    List<String> timeComponents = value.split(':');
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1]);

    return TimeOfDay(hour: hour, minute: minute);
  }

  static String strHMStoHM(String value) {
    List<String> times = value.split(':');
    return '${times[0]}:${times[1]}';
  }

  static bool isTimeBeforeEndTime(TimeOfDay myTime, TimeOfDay current) {
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
}
