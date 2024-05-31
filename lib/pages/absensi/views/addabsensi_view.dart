import 'package:axata_absensi/components/cari_pegawai.dart';
import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/pages/absensi/controllers/absensi_controller.dart';
import 'package:axata_absensi/pages/absensi/views/container_input.dart';
import 'package:axata_absensi/utils/datehelper.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddAbsensiView extends GetView<AbsensiController> {
  const AddAbsensiView({
    super.key,
    required this.type,
    this.id,
  });
  final String type;
  final String? id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
          title: type == 'tambah' ? 'Tambah Absensi' : 'Ubah Absensi'),
      backgroundColor: AxataTheme.bgGrey,
      body: Column(
        children: [
          SizedBox(height: 36.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(60.r),
            margin: EdgeInsets.symmetric(horizontal: 60.w),
            decoration: AxataTheme.styleUnselectBoxFilter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContainerInputAbsensi(
                  onTap: () => Get.to(
                    () => SelectPegawaiPage(
                      list: controller.listPegawaiAll,
                      controller: controller,
                    ),
                  ),
                  title: 'Nama Pegawai',
                  child: Obx(
                    () => Text(
                      controller.pegawai.value,
                      style: AxataTheme.threeSmall,
                    ),
                  ),
                ),
                Obx(
                  () => Row(
                    children: [
                      Checkbox(
                        value: controller.statusCheckOut.value,
                        onChanged: (bool? value) {
                          controller.statusCheckOut.value = value ?? false;
                        },
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(
                        'Pegawai sudah absen keluar',
                        style: AxataTheme.oneSmall,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                ContainerInputAbsensi(
                  title: 'Masuk',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Obx(
                        () => GestureDetector(
                          onTap: () => controller.handleDatePick(context, true),
                          child: Text(
                            DateFormat('dd MMMM yyyy', 'id_ID')
                                .format(controller.dateMasuk.value),
                            style: AxataTheme.threeSmall,
                          ),
                        ),
                      ),
                      SizedBox(width: 72.w),
                      Obx(
                        () => GestureDetector(
                          onTap: () => controller.handleTimePick(context, true),
                          child: Text(
                            DateHelper.timetoHM(controller.timeIn.value),
                            style: AxataTheme.threeSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.pilihShift(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.w,
                      vertical: 24.h,
                    ),
                    decoration: AxataTheme.styleGradientUD,
                    alignment: Alignment.center,
                    child: Obx(
                      () => Text(
                        controller.selectedShift.value == null
                            ? 'Pilih shift kamu hari ini'
                            : controller.selectedShift.value!.nama,
                        style: AxataTheme.oneBold.copyWith(
                          color: AxataTheme.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Obx(
                  () => controller.statusCheckOut.isFalse
                      ? ContainerInputAbsensi(
                          bgColor: Colors.grey,
                          title: 'Keluar',
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              '-',
                              style: AxataTheme.threeSmall,
                            ),
                          ),
                        )
                      : ContainerInputAbsensi(
                          title: 'Keluar',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Obx(
                                () => GestureDetector(
                                  onTap: () =>
                                      controller.handleDatePick(context, false),
                                  child: Text(
                                    DateFormat('dd MMMM yyyy', 'id_ID')
                                        .format(controller.dateKeluar.value),
                                    style: AxataTheme.threeSmall,
                                  ),
                                ),
                              ),
                              SizedBox(width: 72.w),
                              Obx(
                                () => GestureDetector(
                                  onTap: () =>
                                      controller.handleTimePick(context, false),
                                  child: Text(
                                    DateHelper.timetoHM(
                                        controller.timeOut.value),
                                    style: AxataTheme.threeSmall,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                ContainerInputAbsensi(
                  title: 'Tarif',
                  child: TextFormField(
                    controller: controller.tarifC,
                    keyboardType: TextInputType.number,
                    style: AxataTheme.threeSmall,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Masukkan Tarif',
                      hintStyle: AxataTheme.threeSmall.copyWith(
                        color: Colors.black45,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tarif harus diisi';
                      }
                      return null;
                    },
                  ),
                ),
                ContainerInputAbsensi(
                  title: 'keterangan',
                  child: TextFormField(
                    controller: controller.keteranganC,
                    style: AxataTheme.threeSmall,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Masukkan keterangan',
                      hintStyle: AxataTheme.threeSmall.copyWith(
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => type == 'tambah'
                ? controller.handleTambah()
                : controller.handleUbah(id!),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 30.h,
              ),
              margin: EdgeInsets.symmetric(horizontal: 60.w),
              alignment: Alignment.center,
              decoration: AxataTheme.styleGradientUD,
              child: Text(
                'Simpan',
                style: AxataTheme.fiveMiddle.copyWith(
                  color: AxataTheme.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}
