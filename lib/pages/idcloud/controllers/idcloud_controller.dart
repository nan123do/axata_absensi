import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class IdCloudController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController idcloudC = TextEditingController();
  TextEditingController keteranganC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getInit();
  }

  getInit() {
    idcloudC.text = GlobalData.idcloud;
    keteranganC.text = GlobalData.keterangan;
    isLoading.value = false;
  }

  void handleSimpan() {
    isLoading.value = true;
    if (idcloudC.text.isNotEmpty && keteranganC.text.isNotEmpty) {
      GlobalData.idcloud = idcloudC.text;
      GlobalData.keterangan = keteranganC.text;

      final box = GetStorage();
      box.write('idcloud', idcloudC.text);
      box.write('keterangan', keteranganC.text);

      Get.offAllNamed(Routes.LOGIN);
    } else {
      CustomToast.errorToast("Error", "Id Cloud dan Nama Toko harus diisi");
    }
    isLoading.value = false;
  }
}
