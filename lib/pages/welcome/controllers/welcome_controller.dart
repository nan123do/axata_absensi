import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/koneksi_helper.dart';
import 'package:axata_absensi/utils/maintenance_helper.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WelcomeController extends GetxController {
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getInit();
  }

  getInit() async {
    await MaintenanceHelper.getMaintenance();
    isLoading.value = false;
  }

  goLogin(Koneksi koneksi, String tipeLogin) {
    final box = GetStorage();
    if (koneksi == Koneksi.axatapos) {
      final box = GetStorage();
      final rawData = box.read('listidcloud') ?? [];
      final List<Map<String, dynamic>> convertedData =
          rawData.map<Map<String, dynamic>>((item) {
        return Map<String, dynamic>.from(item);
      }).toList();
      if (convertedData.isEmpty) {
        GlobalData.idcloud = '000000000';
        GlobalData.keterangan = 'default';
      } else {
        GlobalData.idcloud = convertedData[0]['idcloud'];
        GlobalData.keterangan = convertedData[0]['keterangan'];
      }

      GlobalData.globalKoneksi = koneksi;
      GlobalData.globalPort = KoneksiHelper.getPort('axatapos');
      PegawaiData.isSuperUser = false;
      box.write('idcloud', GlobalData.idcloud);
      box.write('keterangan', GlobalData.keterangan);
      box.write('koneksi', 'axatapos');

      KoneksiHelper.updateWs(
        koneksi,
        GlobalData.idcloud,
      );
    } else {
      GlobalData.idcloud = '167.71.194.195';
      GlobalData.keterangan = 'CLOUD SERVER';
      GlobalData.globalKoneksi = koneksi;
      GlobalData.globalPort = KoneksiHelper.getPort('online');
      GlobalData.tipeLogin = tipeLogin;
      box.write('idcloud', GlobalData.idcloud);
      box.write('keterangan', GlobalData.keterangan);
      box.write('koneksi', 'online');
      box.write('tipeLogin', tipeLogin);

      KoneksiHelper.updateWs(
        koneksi,
        GlobalData.idcloud,
      );
    }
    // simpan variabel pertama kali masuk
    box.write('welcome', true);

    Get.offAllNamed(Routes.LOGIN);
  }
}
