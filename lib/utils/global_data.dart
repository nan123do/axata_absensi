import 'package:axata_absensi/utils/enums.dart';

class GlobalData {
  static String idPenyewa = '';
  static String idcloud = '000000000';
  static String keterangan = 'Nama Toko';
  static String namatoko = 'Nama Toko';
  static String alamattoko = 'Alamat Toko';
  static String username = '';
  static String password = '';
  static bool isLogin = false;
  static bool statusShift = false;
  static bool saveCredential = false;
  static Koneksi globalKoneksi = Koneksi.online; // online, axatapos, offline
  static String globalAPI =
      '157.245.206.185'; //103.175.219.123, 157.245.206.185, 192.168.100.121
  static String globalWSApi =
      '157.245.206.185'; // 192.168.100.121 , 103.175.219.123, 157.245.206.185
  static String globalPort = ':7000'; // 5000, 7000, 8000
  static double gajiPermenit = 0;
  static int smileDuration = 3;
  static int smilePercent = 95;
  static Map<String, dynamic> office = {
    'latitude': -8.111449490474198,
    'longitude': 112.16559277278434,
    'radius': 100,
  };
}
