import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/components/filter_singlemap.dart';
import 'package:axata_absensi/models/Shift/datashift_model.dart';
import 'package:axata_absensi/pages/shift/views/save_shift.dart';
import 'package:axata_absensi/services/helper_service.dart';
import 'package:axata_absensi/services/online/online_setting_service.dart';
import 'package:axata_absensi/services/online/online_shift_service.dart';
import 'package:axata_absensi/services/shift_service.dart';
import 'package:axata_absensi/utils/datehelper.dart';
import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/maintenance_helper.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ShiftController extends GetxController {
  TextEditingController namaC = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isActiveShift = false.obs;
  RxString selectedNonaktifLaporan = 'Tidak'.obs;
  List<String> listLaporan = ['Ya', 'Tidak'];

  ShiftService serviceShift = ShiftService();
  HelperService serviceHelper = HelperService();

  List<DataShiftModel> listShiftAll = [];
  List<DataShiftModel> listShift = [];
  List<DataShiftModel> tempShift = [];
  List<DataShiftModel> tempNonShift = [];
  List<Map> listNamaShift = [];

  @override
  void onInit() {
    super.onInit();
    getInit();
  }

  getInit() async {
    await MaintenanceHelper.getMaintenance();
    refreshData();
  }

  refreshData() async {
    // Kosongkan data
    listShiftAll = [];
    listShift = [];
    tempShift = [];
    tempNonShift =
        selectedNonaktifLaporan.value.contains('Ya') ? tempNonShift : [];
    listNamaShift = [];

    isLoading.value = true;
    try {
      // Get All Shift
      await handleDataShift();

      await handleStatusShift();

      // Make temp list
      if (selectedNonaktifLaporan.value.contains('Tidak')) {
        tempNonShift =
            listShiftAll.where((shift) => shift.nama == 'default').toList();
      }
      tempShift = List.from(listShiftAll);
      tempShift.removeWhere((item) => item.nama == 'default');
      handleNamaShift();

      if (isActiveShift.value) {
        listShift = tempShift;
      } else {
        listShift = tempNonShift;
      }
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  handleDataShift() async {
    String status = selectedNonaktifLaporan.value.contains('Ya') ? '0' : '1';
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineShiftService serviceOnline = OnlineShiftService();
      listShiftAll = await serviceOnline.getShift(
        hari: '',
        status: status,
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      listShiftAll = await serviceShift.getShift(
        hari: '',
        status: status,
      );
    }
  }

  handleStatusShift() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      isActiveShift.value = GlobalData.statusShift;
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      String statusShift = await serviceHelper.strSetting(kodeSetting: 'I02');
      isActiveShift.value = statusShift == '1' ? true : false;
    }
  }

  handleNamaShift() {
    Set<String> uniqueNames = {};

    for (var result in tempShift) {
      String nama = result.nama;
      String id = result.id;

      if (!uniqueNames.contains(nama)) {
        uniqueNames.add(nama);

        listNamaShift.add({
          'nama': nama,
          'id': id,
        });
      }
    }
  }

  void openModalFilterJenis(BuildContext context) {
    String laporan = selectedNonaktifLaporan.value;
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
                      title: 'Tampilkan Data Nonaktif',
                      selected: selectedNonaktifLaporan.value,
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
                  selectedNonaktifLaporan.value = laporan;
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

  void updateShiftStatusItem(DataShiftModel data, bool newStatus) {
    isLoading.value = true;
    data.statusAktif = newStatus;
    isLoading.value = false;
  }

  void changeTime(
    BuildContext context,
    DataShiftModel shift,
    bool isMasuk,
    List<DataShiftModel> list,
  ) {
    DateHelper.datePickerTime(
      context,
      DateHelper.stringToTime(isMasuk ? shift.jamMasuk : shift.jamKeluar),
      (v1, v2) {
        isLoading.value = true;
        if (shift.hari.toLowerCase() == 'senin') {
          for (DataShiftModel item in list) {
            if (isMasuk) {
              item.jamMasuk = v2;
            } else {
              item.jamKeluar = v2;
            }
          }
        } else {
          if (isMasuk) {
            shift.jamMasuk = v2;
          } else {
            shift.jamKeluar = v2;
          }
        }
        isLoading.value = false;
      },
    );
  }

  errorSaveMesssage(String title) {
    CustomToast.errorToast("Error", title);
    isLoading.value = false;
  }

  Future<void> simpan({
    required String type,
    List<DataShiftModel> data = const [],
    String id = '',
    String status = '',
  }) async {
    isLoading.value = true;
    try {
      OnlineShiftService serviceOnline = OnlineShiftService();
      if (type == 'tambah') {
        if (namaC.text == '') {
          errorSaveMesssage('Nama shift harus diisi.');
          return;
        }
        if (data.every((shift) => shift.statusAktif == false)) {
          errorSaveMesssage('Status aktif minimal 1.');
          return;
        }
        if (GlobalData.globalKoneksi == Koneksi.online) {
          await serviceOnline.simpanTambahShift(nama: namaC.text, data: data);
        } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
          await serviceShift.simpanTambahShift(nama: namaC.text, data: data);
        }
        Get.back();
        CustomToast.successToast("Success", "Berhasil menyimpan shift");
      } else if (type == 'hapus') {
        if (GlobalData.globalKoneksi == Koneksi.online) {
          await serviceOnline.simpanHapusShift(id: id);
        } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
          await serviceShift.simpanHapusShift(id: id);
        }
        Get.back();
        CustomToast.successToast("Success", "Berhasil menghapus shift");
      } else if (type == 'ubahstatus') {
        if (GlobalData.globalKoneksi == Koneksi.online) {
          await serviceOnline.simpanStatusShift(id: id, status: status);
        } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
          await serviceShift.simpanStatusShift(id: id, status: status);
        }
        Get.back();
        CustomToast.successToast("Success", "Berhasil mengubah status shift");
      } else {
        List<DataShiftModel> hasil = data;
        if (type == 'default') {
          namaC.text = 'default';
        }

        if (namaC.text == '') {
          errorSaveMesssage('Nama shift harus diisi.');
          return;
        }

        // Cek status
        if (hasil.every((shift) => shift.statusAktif == false)) {
          errorSaveMesssage('Status aktif minimal 1.');
          return;
        }

        if (GlobalData.globalKoneksi == Koneksi.online) {
          await serviceOnline.simpanUbahShift(
            id: hasil[0].id,
            nama: namaC.text,
            data: hasil,
          );
        } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
          await serviceShift.simpanUbahShift(
            id: hasil[0].id,
            nama: namaC.text,
            data: hasil,
          );
        }

        Get.back();
        CustomToast.successToast("Success", "Berhasil mengubah shift");
      }
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
      refreshData();
    }
  }

  Future<void> updateShiftStatus(bool newStatus) async {
    isLoading.value = true;

    try {
      if (GlobalData.globalKoneksi == Koneksi.online) {
        OnlineSettingService serviceOnline = OnlineSettingService();
        await serviceOnline.postDataSetting(
          statusShift: newStatus ? '1' : '0',
        );
        GlobalData.statusShift = newStatus;
      } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
        await serviceHelper.updateSetting(
          kode: 'StatusShift',
          nilai: newStatus ? '1' : '0',
        );
      }
      isActiveShift.value = newStatus;
      if (isActiveShift.value) {
        listShift = tempShift;
      } else {
        listShift = tempNonShift;
      }

      CustomToast.successToast("Success", "Status shift berhasil diubah");
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  void goDialogShift(String id, String nama) {
    Widget menu() {
      if (selectedNonaktifLaporan.value == 'Tidak') {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
                goUbahShift(id, nama);
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
              onTap: () => simpan(type: 'ubahstatus', id: id, status: '0'),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30.h),
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'Nonaktifkan',
                  style: AxataTheme.threeSmall,
                ),
              ),
            ),
            const Divider(),
            GestureDetector(
              onTap: () => simpan(type: 'hapus', id: id),
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
        );
      } else {
        return Column(
          children: [
            GestureDetector(
              onTap: () => simpan(type: 'ubahstatus', id: id, status: '1'),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30.h),
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'Aktifkan',
                  style: AxataTheme.threeSmall,
                ),
              ),
            ),
          ],
        );
      }
    }

    Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.symmetric(vertical: 25.h),
      titleStyle: const TextStyle(fontSize: 0),
      content: menu(),
    );
  }

  void goUbahShift(String id, String nama) {
    var list = listShiftAll.where((shift) => shift.id == id).toList();
    namaC.text = nama;
    Get.to(
      () => SaveShiftView(
        controller: this,
        title: 'ubah jam kerja',
        listShift: list,
        type: 'ubah',
      ),
    );
  }

  void goAddShift() {
    namaC.text = '';
    String maxId = '1';
    if (listShiftAll.isNotEmpty) {
      maxId = listShiftAll[listShiftAll.length - 1].id;
    }

    // Default shift
    List<DataShiftModel> list = [];
    List<String> days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    for (String item in days) {
      list.add(
        DataShiftModel(
          idDetail: '',
          id: maxId,
          nama: '',
          hari: item,
          jamMasuk: '08:00',
          jamKeluar: '16:00',
          statusAktif: false,
        ),
      );
    }
    Get.to(
      () => SaveShiftView(
        controller: this,
        title: 'tambah jam kerja',
        listShift: list,
        type: 'tambah',
      ),
    );
  }
}
