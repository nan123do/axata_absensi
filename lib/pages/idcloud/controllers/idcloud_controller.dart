import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/components/filter_singlemap.dart';
import 'package:axata_absensi/pages/absensi/views/container_input.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/koneksi_helper.dart';
import 'package:axata_absensi/utils/maintenance_helper.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class IdCloudController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController idcloudC = TextEditingController();
  TextEditingController keteranganC = TextEditingController();
  RxList<Map<String, dynamic>> listIdCloud = RxList<Map<String, dynamic>>([]);

  // Filter
  RxString selectedLaporan = 'Semua'.obs;
  List<String> listLaporan = ['Semua', 'Online', 'Remote'];
  RxString selectedRadio = 'online'.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getInit();
  }

  getInit() async {
    try {
      await MaintenanceHelper.getMaintenance();
      final box = GetStorage();
      final rawData = box.read('listidcloud') ?? [];
      final List<Map<String, dynamic>> convertedData =
          rawData.map<Map<String, dynamic>>((item) {
        return Map<String, dynamic>.from(item);
      }).toList();
      // Menyimpan data yang sudah dikonversi
      listIdCloud.value = convertedData;
    } catch (e) {
      CustomToast.errorToast('Error', '$e');
    }
    isLoading.value = false;
  }

  void handlePilih(int index) {
    isLoading.value = true;
    GlobalData.idcloud = listIdCloud[index]['idcloud'];
    GlobalData.keterangan = listIdCloud[index]['keterangan'];
    GlobalData.globalKoneksi =
        KoneksiHelper.getKoneksi(listIdCloud[index]['koneksi']);
    GlobalData.globalPort =
        KoneksiHelper.getPort(listIdCloud[index]['koneksi']);

    final box = GetStorage();
    box.write('idcloud', listIdCloud[index]['idcloud']);
    box.write('keterangan', listIdCloud[index]['keterangan']);
    box.write('koneksi', listIdCloud[index]['koneksi']);

    KoneksiHelper.updateWs(
      KoneksiHelper.getKoneksi(listIdCloud[index]['koneksi']),
      listIdCloud[index]['idcloud'],
    );

    Get.offAllNamed(Routes.LOGIN);
    isLoading.value = false;
  }

  bool isValidIPAddress(String ipAddress) {
    final ipv4Regex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');

    // Periksa apakah string cocok dengan pola IPv4
    if (!ipv4Regex.hasMatch(ipAddress)) {
      return false;
    }

    // Periksa setiap segmen untuk memastikan bahwa tiap nilai tidak lebih dari 255
    var segments = ipAddress.split('.');
    for (var segment in segments) {
      if (int.parse(segment) > 255) {
        return false;
      }
    }

    return true;
  }

  handleSimpan(int? index) {
    isLoading.value = true;
    if (idcloudC.text.isNotEmpty && keteranganC.text.isNotEmpty) {
      if (idcloudC.text.length != 9 && selectedRadio.value == 'remote') {
        CustomToast.errorToast("Error", "Id Cloud harus berjumlah 9");
        isLoading.value = false;
        return;
      }

      if (isValidIPAddress(idcloudC.text) == false &&
          selectedRadio.value == 'online') {
        CustomToast.errorToast("Error", "Format IP Address tidak valid");
        isLoading.value = false;
        return;
      }

      Map<String, dynamic> result = {
        "idcloud": idcloudC.text,
        "keterangan": keteranganC.text,
        "koneksi": selectedRadio.value,
      };
      List<Map<String, dynamic>> allcloud = List.from(listIdCloud);

      if (index == null) {
        allcloud.add(result);
      } else {
        allcloud[index] = result;
      }

      final box = GetStorage();
      box.write('listidcloud', allcloud);

      listIdCloud.value = allcloud;
      Get.back();
    } else {
      CustomToast.errorToast("Error", "Id Cloud dan Nama Toko harus diisi");
    }
    isLoading.value = false;
  }

  handleHapus(int index) {
    if (listIdCloud.length <= 1) {
      CustomToast.errorToast("Error", "Id cloud harus berjumlah minimal 1");
    } else {
      listIdCloud.removeAt(index);
      List<Map<String, dynamic>> allcloud = List.from(listIdCloud);
      final box = GetStorage();
      box.write('listidcloud', allcloud);
      CustomToast.successToast('Success', 'Berhasil menghapus data');
    }
  }

  showForm(BuildContext context, int? index) {
    if (index != null) {
      idcloudC.text = listIdCloud[index]['idcloud'];
      keteranganC.text = listIdCloud[index]['keterangan'];
      selectedRadio.value = listIdCloud[index]['koneksi'];
    } else {
      idcloudC.text = '';
      keteranganC.text = '';
      selectedRadio.value = 'remote';
    }

    String getTitle() {
      switch (selectedRadio.value) {
        case 'online':
          return 'Ip Address';
        case 'remote':
          return 'Id Cloud';
        default:
          return 'Id Cloud';
      }
    }

    showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: 0.28.sh,
                padding: EdgeInsets.symmetric(
                  horizontal: 60.w,
                  vertical: 40.h,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    ContainerInputAbsensi(
                      title: 'Nama Koneksi',
                      child: TextFormField(
                        controller: keteranganC,
                        style: AxataTheme.threeSmall,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Masukkan nama koneksi',
                          hintStyle: AxataTheme.threeSmall.copyWith(
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => ContainerInputAbsensi(
                        title: getTitle(),
                        child: TextFormField(
                          controller: idcloudC,
                          keyboardType: TextInputType.number,
                          style: AxataTheme.threeSmall,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Masukkan ${getTitle()}',
                            hintStyle: AxataTheme.threeSmall.copyWith(
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        handleSimpan(index);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 20.h,
                        ),
                        alignment: Alignment.center,
                        decoration: AxataTheme.styleGradientUD,
                        child: Text(
                          'Simpan',
                          style: AxataTheme.oneBold.copyWith(
                            color: AxataTheme.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          );
        });
  }

  handleFilter() {
    isLoading.value = true;
    try {
      final box = GetStorage();
      final rawData = box.read('listidcloud') ?? [];
      final List<Map<String, dynamic>> convertedData =
          rawData.map<Map<String, dynamic>>((item) {
        return Map<String, dynamic>.from(item);
      }).toList();
      // Menyimpan data yang sudah dikonversi
      if (selectedLaporan.toLowerCase() == 'semua') {
        listIdCloud.value = convertedData;
      } else {
        listIdCloud.value = convertedData
            .where((e) => e['koneksi'] == selectedLaporan.toLowerCase())
            .toList();
      }
    } catch (e) {
      CustomToast.errorToast('Error', '$e');
    }
    isLoading.value = false;
  }

  void openModalFilterJenis(BuildContext context) {
    // ignore: unused_local_variable
    String laporan = selectedLaporan.value;
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 0.18.sh,
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
                    FilterSingleMapPage(
                      title: 'Jenis Koneksi',
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
                  Get.back();
                  selectedLaporan.value = laporan;
                  handleFilter();
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
}
