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
}
