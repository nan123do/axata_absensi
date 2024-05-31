import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/koneksi_helper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getInit();
  }

  getInit() async {
    final box = GetStorage();
    try {
      GlobalData.idcloud = box.read('idcloud') ?? GlobalData.idcloud;
      GlobalData.keterangan = box.read('keterangan') ?? GlobalData.keterangan;
      GlobalData.username = box.read('username') ?? GlobalData.username;
      GlobalData.password = box.read('password') ?? GlobalData.password;
      GlobalData.isLogin = box.read('islogin') ?? GlobalData.isLogin;
      GlobalData.saveCredential =
          box.read('savecredential') ?? GlobalData.saveCredential;
      String strKoneksi = box.read('koneksi') ?? 'axatapos';
      GlobalData.globalKoneksi = KoneksiHelper.getKoneksi(strKoneksi);
      GlobalData.globalPort = KoneksiHelper.getPort(strKoneksi);

      KoneksiHelper.updateWs(
        KoneksiHelper.getKoneksi(strKoneksi),
        box.read('idcloud') ?? GlobalData.idcloud,
      );
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      await Future.delayed(const Duration(seconds: 2));
      isLoading.value = false;
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
