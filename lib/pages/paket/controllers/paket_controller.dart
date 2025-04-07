import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/components/loading_screen.dart';
import 'package:axata_absensi/models/Paket/paket_model.dart';
import 'package:axata_absensi/pages/paket/views/save_paket.dart';
import 'package:axata_absensi/services/online/online_paket_service.dart';
import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/maintenance_helper.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PaketController extends GetxController {
  TextEditingController namaC = TextEditingController();
  TextEditingController hariC = TextEditingController();
  TextEditingController hargaC = TextEditingController();
  TextEditingController maxEmpC = TextEditingController();
  List<DataPaketModel> listPaket = [];

  RxString id = ''.obs;
  RxBool statusAktif = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getInit();
  }

  getInit() async {
    isLoading.value = true;
    try {
      await MaintenanceHelper.getMaintenance();
      await handleDataPaket();
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  handleDataPaket() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlinePaketService serviceOnline = OnlinePaketService();
      listPaket = await serviceOnline.getDataPaket();
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }

  void goDialog(DataPaketModel data) {
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
            onTap: () {
              Get.back();
              goSetStatusAktifPaket(data);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                data.statusAktif ? 'Nonaktifkan' : 'Aktifkan',
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
    namaC.text = '';
    hariC.text = '';
    hargaC.text = '';
    maxEmpC.text = '';

    Get.to(
      () => SavePaket(
        controller: this,
        isAdd: true,
      ),
      transition: Transition.rightToLeftWithFade,
    );
  }

  goUbahPage(DataPaketModel data) {
    id.value = data.id;
    statusAktif.value = data.statusAktif;
    namaC.text = data.nama;
    hariC.text = data.hari.toString();
    hargaC.text = data.harga.round().toString();
    maxEmpC.text = data.jumlahPegawai.toString();

    Get.to(
      () => SavePaket(
        controller: this,
        isAdd: false,
      ),
      transition: Transition.rightToLeftWithFade,
    );
  }

  goSetStatusAktifPaket(DataPaketModel data) async {
    try {
      LoadingScreen.show();
      await handleSetStatusAktifPaket(data);
      LoadingScreen.hide();
      CustomToast.successToast('Success', 'Berhasil Mengubah Paket');
      getInit();
    } catch (e) {
      LoadingScreen.hide();
      CustomToast.errorToast('Error', '$e');
    }
  }

  goHapusPage(DataPaketModel data) async {
    try {
      id.value = data.id;
      await handleHapusPaket();
      Get.back();
      CustomToast.successToast('Success', 'Berhasil Menghapus Paket');
      getInit();
    } catch (e) {
      CustomToast.errorToast('Error', '$e');
    }
  }

  handleSimpan(bool isAdd) async {
    if (namaC.text == '') {
      CustomToast.errorToast("Error", 'Nama paket harus Diisi.');
      return;
    }

    if (hariC.text == '') {
      CustomToast.errorToast("Error", 'Jumlah hari harus Diisi.');
      return;
    }

    if (hariC.text == '0') {
      CustomToast.errorToast("Error", 'Jumlah hari tidak boleh 0.');
      return;
    }

    if (hargaC.text == '') {
      CustomToast.errorToast("Error", 'Harga paket harus Diisi.');
      return;
    }

    if (hargaC.text == '0') {
      CustomToast.errorToast("Error", 'Harga paket tidak boleh 0.');
      return;
    }

    if (maxEmpC.text == '') {
      CustomToast.errorToast("Error", 'Max pegawai harus Diisi.');
      return;
    }

    if (maxEmpC.text == '0') {
      CustomToast.errorToast("Error", 'Max pegawai tidak boleh 0.');
      return;
    }

    try {
      LoadingScreen.show();
      if (isAdd) {
        await handleTambahPaket();
        LoadingScreen.hide();
        Get.back();
        CustomToast.successToast('Success', 'Berhasil Menambah Paket');
      } else {
        await handleUbahPaket();
        LoadingScreen.hide();
        Get.back();
        CustomToast.successToast('Success', 'Berhasil Mengubah Paket');
      }

      getInit();
    } catch (e) {
      LoadingScreen.hide();
      CustomToast.errorToast('Error', '$e');
    }
  }

  deleteRpComma(String text) {
    return text.replaceAll("Rp ", "").replaceAll(",", "");
  }

  handleTambahPaket() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlinePaketService serviceOnline = OnlinePaketService();

      await serviceOnline.tambahPaket(
        nama: namaC.text,
        harga: deleteRpComma(hargaC.text),
        hari: deleteRpComma(hariC.text),
        maxPegawai: deleteRpComma(maxEmpC.text),
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }

  handleUbahPaket() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlinePaketService serviceOnline = OnlinePaketService();

      await serviceOnline.ubahPaket(
        id: id.value,
        nama: namaC.text,
        harga: deleteRpComma(hargaC.text),
        hari: deleteRpComma(hariC.text),
        maxPegawai: deleteRpComma(maxEmpC.text),
        statusAktif: statusAktif.value,
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }

  handleSetStatusAktifPaket(DataPaketModel data) async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlinePaketService serviceOnline = OnlinePaketService();

      await serviceOnline.setStatusAktifPaket(
        id: data.id.toString(),
        statusAktif: !data.statusAktif,
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }

  handleHapusPaket() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlinePaketService serviceOnline = OnlinePaketService();
      await serviceOnline.hapusPaket(
        id: id.value,
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }
}
