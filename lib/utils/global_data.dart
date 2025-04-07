import 'package:axata_absensi/utils/enums.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class GlobalData {
  static bool isTestMode = false;
  static String idPenyewa = '';
  static int maxPegawai = 0;
  static DateTime? expiredAt;
  static String idcloud = '000000000';
  static String keterangan = 'Nama Toko';
  static String namatoko = 'Nama Toko';
  static String alamattoko = 'Alamat Toko';
  static String username = '';
  static String password = '';
  static String tipeLogin = 'karyawan';
  static bool isLogin = false;
  static bool statusShift = false;
  static bool saveCredential = false;
  static bool checkoutInStore = false;
  static Koneksi globalKoneksi = Koneksi.online; // online, axatapos, offline
  static String globalLocalAPI =
      '157.245.206.185'; // 192.168.100.121, 157.245.206.185
  static String globalAPI =
      '157.245.206.185'; // 103.175.219.123, 157.245.206.185
  static String globalWSApi =
      '157.245.206.185'; // 103.175.219.123, 157.245.206.185
  static String globalPort = ':7000'; // 5000, 7000, 8000
  static double gajiPermenit = 0;
  static int smileDuration = 3;
  static int smilePercent = 95;
  static Map<String, dynamic> office = {
    'latitude': -8.111449490474198,
    'longitude': 112.16559277278434,
    'radius': 10.0,
  };

  static Map<String, String> lokasi = {
    'id': '-',
    'nama': '-',
    'alamat': '-',
  };

  static bool isKoneksiOnline() {
    return GlobalData.globalKoneksi == Koneksi.online;
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat currencyFormatter = NumberFormat("#,##0", "en_US");
  final String currencySymbol;

  CurrencyInputFormatter({required this.currencySymbol});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty || newValue.text == currencySymbol) {
      // Jika teks kosong atau hanya berisi simbol mata uang, kembalikan Rp 0
      return newValue.copyWith(
        text: '${currencySymbol}0',
        selection: TextSelection.collapsed(offset: currencySymbol.length + 1),
      );
    }

    // Menghapus karakter selain angka
    final String cleanedText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Jika setelah dibersihkan, tidak ada angka, kembalikan Rp 0
    if (cleanedText.isEmpty) {
      return newValue.copyWith(
        text: '${currencySymbol}0',
        selection: TextSelection.collapsed(offset: currencySymbol.length + 1),
      );
    }

    // Memastikan teks yang diinput valid dan mengubahnya menjadi integer
    final int value = int.parse(cleanedText);
    final String formattedValue = currencyFormatter.format(value);

    // Mengatur posisi kursor
    final int newCursorPosition = currencySymbol.length + formattedValue.length;

    return TextEditingValue(
      text: currencySymbol + formattedValue,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}
