import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/global_data.dart';

class KoneksiHelper {
  static getKoneksi(String strKoneksi) {
    switch (strKoneksi) {
      case 'online':
        return Koneksi.online;
      case 'remote':
        return Koneksi.axatapos;
      default:
        return Koneksi.axatapos;
    }
  }

  static getPort(String strKoneksi) {
    switch (strKoneksi) {
      case 'online':
        return ':8000';
      case 'remote':
        return ':7000';
      default:
        return ':7000';
    }
  }

  static getStrKoneksi(Koneksi koneksi) {
    switch (koneksi) {
      case Koneksi.online:
        return 'online';
      case Koneksi.axatapos:
        return 'remote';
      default:
        return 'axatapos';
    }
  }

  static updateWs(Koneksi koneksi, String idcloud) {
    switch (koneksi) {
      case Koneksi.online:
        GlobalData.globalAPI = GlobalData.isTestMode
            ? GlobalData.globalLocalAPI
            : '167.71.194.195';
        GlobalData.globalWSApi = GlobalData.isTestMode
            ? GlobalData.globalLocalAPI
            : '167.71.194.195';
      case Koneksi.axatapos:
        GlobalData.globalAPI = '157.245.206.185';
        GlobalData.globalWSApi = '157.245.206.185';
      default:
        GlobalData.globalAPI = '157.245.206.185';
        GlobalData.globalWSApi = '157.245.206.185';
    }
  }
}
