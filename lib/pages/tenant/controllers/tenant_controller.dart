import 'package:axata_absensi/components/custom_dialog.dart';
import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/components/loading_screen.dart';
import 'package:axata_absensi/models/Tenant/tenant_model.dart';
import 'package:axata_absensi/pages/tenant/views/save_tenant.dart';
import 'package:axata_absensi/services/online/online_tenant_service.dart';
import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/maintenance_helper.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TenantController extends GetxController {
  TextEditingController namaC = TextEditingController();
  TextEditingController alamatC = TextEditingController();
  TextEditingController usernameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController firstnameC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController passwordKC = TextEditingController();
  TextEditingController telpC = TextEditingController();

  RxBool isLoading = false.obs;
  List<DataTenantModel> listTenant = [];
  RxString id = ''.obs;

  RxBool isObsecurePassword = true.obs;
  RxBool isObsecurePasswordK = true.obs;

  @override
  void onInit() {
    super.onInit();
    getInit();
  }

  getInit() async {
    isLoading.value = true;
    try {
      await MaintenanceHelper.getMaintenance();
      await handleDataTenant();
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  handleDataTenant() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineTenantService serviceOnline = OnlineTenantService();
      listTenant = await serviceOnline.getDataTenant();
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }

  void goDialog(DataTenantModel data) {
    Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.symmetric(vertical: 25.h),
      titleStyle: const TextStyle(fontSize: 0),
      content: Column(
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
              goUbahPage(data);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'Ubah',
                style: AxataTheme.threeSmall,
              ),
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () async {
              await goHapusPage(data);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'Hapus',
                style: AxataTheme.threeSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  goAddPage() {
    usernameC.text = '';
    namaC.text = '';
    emailC.text = '';
    alamatC.text = '';
    firstnameC.text = '';

    Get.to(
      () => SaveTenant(
        controller: this,
        isAdd: true,
      ),
      transition: Transition.rightToLeftWithFade,
    );
  }

  goUbahPage(DataTenantModel data) {
    id.value = data.id;
    namaC.text = data.nama;
    alamatC.text = data.alamat;

    Get.to(
      () => SaveTenant(
        controller: this,
        isAdd: false,
      ),
      transition: Transition.rightToLeftWithFade,
    );
  }

  errorSaveMesssage(String title) {
    CustomToast.errorToast("Error", title);
    isLoading.value = false;
  }

  handleSimpan(bool isAdd) async {
    if (namaC.text == '') {
      errorSaveMesssage('Nama Perusahaan harus diisi.');
      return;
    }

    if (usernameC.text == '' && isAdd) {
      errorSaveMesssage('Username admin harus diisi.');
      return;
    }

    if (emailC.text == '' && isAdd) {
      errorSaveMesssage('Email admin harus diisi.');
      return;
    }

    final RegExp emailRegexp = RegExp(
      r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );

    if (!emailRegexp.hasMatch(emailC.text) && isAdd) {
      errorSaveMesssage('Format email tidak valid.');
      return;
    }

    if (firstnameC.text == '' && isAdd) {
      errorSaveMesssage('Nama admin harus diisi.');
      return;
    }

    if (telpC.text == '' && isAdd) {
      errorSaveMesssage('No Telpon harus diisi.');
      return;
    }

    if (passwordC.text == '' && isAdd) {
      errorSaveMesssage('Password harus diisi.');
      return;
    }

    if (passwordC.text != passwordKC.text && isAdd) {
      errorSaveMesssage('Password dan konfirmasi password harus sama');
      return;
    }

    try {
      LoadingScreen.show();
      if (isAdd) {
        await handleTambahPenyewa();
        LoadingScreen.hide();
        CustomAlertDialog.showCloseDialog(
          title: 'Aktivasi Email',
          message:
              'Email aktivasi berhasil dikirimkan di folder inbox/spam Anda.',
          onClose: () {
            Get.back();
            Get.back();
            CustomToast.successToast('Success', 'Berhasil Menambah Penyewa');
          },
        );
      } else {
        await handleUbahPenyewa();
        LoadingScreen.hide();
        Get.back();
        CustomToast.successToast('Success', 'Berhasil Mengubah Penyewa');
      }

      getInit();
    } catch (e) {
      LoadingScreen.hide();
      CustomToast.errorToast('Error', '$e');
    }
  }

  handleTambahPenyewa() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineTenantService serviceOnline = OnlineTenantService();
      await serviceOnline.tambahTenant(
        username: usernameC.text,
        nama: namaC.text,
        email: emailC.text,
        alamat: alamatC.text,
        firstname: firstnameC.text,
        password: passwordC.text,
        telp: telpC.text,
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }

  handleUbahPenyewa() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineTenantService serviceOnline = OnlineTenantService();
      await serviceOnline.ubahTenant(
        id: id.value,
        nama: namaC.text,
        alamat: alamatC.text,
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }

  goHapusPage(DataTenantModel data) async {
    try {
      id.value = data.id;
      await handleHapusTenant();
      Get.back();
      CustomToast.successToast('Success', 'Berhasil Menghapus Penyewa');
      getInit();
    } catch (e) {
      CustomToast.errorToast('Error', '$e');
    }
  }

  handleHapusTenant() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineTenantService serviceOnline = OnlineTenantService();
      await serviceOnline.hapusTenant(
        id: id.value,
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }
}
