import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/components/filter_singlemap.dart';
import 'package:axata_absensi/components/loading_screen.dart';
import 'package:axata_absensi/models/Registrasi/registrasi_model.dart';
import 'package:axata_absensi/pages/registrasi/views/registrasi_detail.dart';
import 'package:axata_absensi/services/online/online_registrasi_service.dart';
import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RegistrasiController extends GetxController {
  List<DataRegistrasiModel> listReg = [];
  List<DataRegistrasiModel> listRegAll = [];

  RxString selectedLaporan = 'Semua'.obs;
  List<String> listLaporan = ['Semua', 'Pending', 'Disetujui', 'Ditolak'];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getInit();
  }

  getInit() async {
    isLoading.value = true;
    try {
      await handleDataPegawai();
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  handleDataPegawai() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineRegistrasiService serviceOnline = OnlineRegistrasiService();
      listRegAll = await serviceOnline.getDataRegistrasi();
      listReg = listRegAll;
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }

  refreshData() {
    ['Semua', 'Pending', 'Disetujui', 'Ditolak'];

    switch (selectedLaporan.value) {
      case 'Pending':
        listReg = listRegAll.where((e) => e.status == '2').toList();
        break;
      case 'Disetujui':
        listReg = listRegAll.where((e) => e.status == '1').toList();
        break;
      case 'Ditolak':
        listReg = listRegAll.where((e) => e.status == '0').toList();
        break;
      default:
        listReg = listRegAll;
    }
  }

  void openModalFilterJenis(BuildContext context) {
    String laporan = selectedLaporan.value;
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 0.4.sh,
          padding: EdgeInsets.symmetric(
            horizontal: 60.w,
            vertical: 40.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(
                    left: 10.w,
                  ),
                  children: [
                    SizedBox(height: 12.h),
                    FilterSingleMapPage(
                      title: 'Absensi',
                      selected: selectedLaporan.value,
                      data: listLaporan,
                      onDataChanged: (String value) {
                        laporan = value;
                      },
                    ),
                  ],
                ),
              ),
              AxataTheme.styleJarak12,
              GestureDetector(
                onTap: () {
                  selectedLaporan.value = laporan;
                  Get.back();
                  refreshData();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 20.h,
                  ),
                  alignment: Alignment.center,
                  decoration: AxataTheme.styleGradient,
                  child: Text(
                    'Terapkan',
                    style: AxataTheme.oneBold.copyWith(
                      color: AxataTheme.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        );
      },
    );
  }

  goDetailRegistrasi(DataRegistrasiModel data) {
    Get.to(
      () => DetailRegistrasiView(
        controller: this,
        data: data,
      ),
    );
  }

  handleKonfirmasi(DataRegistrasiModel data, String status) async {
    try {
      LoadingScreen.show();
      await handleApiKonfirmasi(data, status);
      LoadingScreen.hide();
      Get.back();
      CustomToast.successToast(
        'Success',
        'Berhasil Mengirim Permintaan ke Admin',
      );
      getInit();
    } catch (e) {
      LoadingScreen.hide();
      CustomToast.errorToast('Error', '$e');
    }
  }

  handleApiKonfirmasi(DataRegistrasiModel data, String status) async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineRegistrasiService serviceOnline = OnlineRegistrasiService();
      await serviceOnline.konfirmasiRegistrasi(
        idRegistrasi: data.id.toString(),
        status: status,
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }
}
