import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/models/Setting/setting_model.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/services/setting_service.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/koneksi_helper.dart';
import 'package:axata_absensi/utils/maintenance_helper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:new_version_plus/new_version_plus.dart';

class SplashController extends GetxController {
  SettingService settingService = SettingService();

  RxBool isLoading = false.obs;
  String popUpUpdate = 'false';
  String mustUpdate = 'false';

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getInit();
  }

  getUpdateAndMaintenance() async {
    await MaintenanceHelper.getMaintenance();
    SettingModel getPopUpUpdate = await settingService.getSettingById('15');
    SettingModel getMustUpdate = await settingService.getSettingById('16');
    popUpUpdate = getPopUpUpdate.nilai;
    mustUpdate = getMustUpdate.nilai;
  }

  getInit() async {
    final box = GetStorage();
    try {
      await getUpdateAndMaintenance();
      GlobalData.idcloud = box.read('idcloud') ?? GlobalData.idcloud;
      GlobalData.keterangan = box.read('keterangan') ?? GlobalData.keterangan;
      GlobalData.username = box.read('username') ?? GlobalData.username;
      GlobalData.password = box.read('password') ?? GlobalData.password;
      GlobalData.isLogin = box.read('islogin') ?? GlobalData.isLogin;
      GlobalData.tipeLogin = box.read('tipeLogin') ?? GlobalData.tipeLogin;
      GlobalData.saveCredential =
          box.read('savecredential') ?? GlobalData.saveCredential;
      String strKoneksi = box.read('koneksi') ?? 'online';
      GlobalData.globalKoneksi = KoneksiHelper.getKoneksi(strKoneksi);
      GlobalData.globalPort = KoneksiHelper.getPort(strKoneksi);

      KoneksiHelper.updateWs(
        KoneksiHelper.getKoneksi(strKoneksi),
        box.read('idcloud') ?? GlobalData.idcloud,
      );
      // Automatic Update
      final newVersion = NewVersionPlus(androidId: 'com.axata.mobile');
      final status = await newVersion.getVersionStatus();

      if (status != null && popUpUpdate == "true" && status.canUpdate) {
        newVersion.showUpdateDialog(
          context: Get.context!,
          versionStatus: status,
          dialogTitle: "Update Tersedia",
          dialogText: "Terdapat versi baru aplikasi, silakan perbarui.",
          allowDismissal: mustUpdate == 'true' ? false : true,
          dismissButtonText: "Nanti",
          dismissAction: () {
            Get.offAllNamed(Routes.LOGIN);
          },
          updateButtonText: "Perbarui",
        );
      } else {
        bool welcomeScreen = box.read('welcome') ?? false;
        if (welcomeScreen == false) {
          await Future.delayed(const Duration(seconds: 2));
          isLoading.value = false;
          Get.offAllNamed(Routes.WELCOME);
        } else {
          await Future.delayed(const Duration(seconds: 2));
          isLoading.value = false;
          Get.offAllNamed(Routes.LOGIN);
        }
      }
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    }
  }
}
