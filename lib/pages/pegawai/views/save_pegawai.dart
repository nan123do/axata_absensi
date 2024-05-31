import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/pages/pegawai/controllers/pegawai_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SavePegawai extends StatelessWidget {
  const SavePegawai({
    super.key,
    required this.controller,
    required this.isAdd,
  });
  final PegawaiController controller;
  final bool isAdd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: isAdd ? 'Tambah Pegawai' : 'Ubah Pegawai'),
      backgroundColor: AxataTheme.bgGrey,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 60.w,
              vertical: 20.h,
            ),
            color: AxataTheme.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Username',
                  style: AxataTheme.sixSmall,
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                    vertical: 24.h,
                  ),
                  decoration: AxataTheme.styleUnselectBoxFilter,
                  child: TextFormField(
                    controller: controller.usernameC,
                    keyboardType: TextInputType.text,
                    style: AxataTheme.threeSmall,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Masukkan Username',
                      hintStyle: AxataTheme.threeSmall.copyWith(
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Nama',
                  style: AxataTheme.sixSmall,
                ),
                AxataTheme.styleJarak12,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                    vertical: 24.h,
                  ),
                  decoration: AxataTheme.styleUnselectBoxFilter,
                  child: TextFormField(
                    controller: controller.namaC,
                    keyboardType: TextInputType.text,
                    style: AxataTheme.threeSmall,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Masukkan Nama',
                      hintStyle: AxataTheme.threeSmall.copyWith(
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
                AxataTheme.styleJarak12,
                Text(
                  'Email',
                  style: AxataTheme.sixSmall,
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                    vertical: 24.h,
                  ),
                  decoration: AxataTheme.styleUnselectBoxFilter,
                  child: TextFormField(
                    controller: controller.emailC,
                    keyboardType: TextInputType.emailAddress,
                    style: AxataTheme.threeSmall,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Masukkan Email',
                      hintStyle: AxataTheme.threeSmall.copyWith(
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
                AxataTheme.styleJarak12,
                Visibility(
                  visible: isAdd,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
                        style: AxataTheme.sixSmall,
                      ),
                      AxataTheme.styleJarak12,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.w,
                          vertical: 24.h,
                        ),
                        decoration: AxataTheme.styleUnselectBoxFilter,
                        child: TextFormField(
                          controller: controller.passwordC,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          style: AxataTheme.threeSmall,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Masukkan Password',
                            hintStyle: AxataTheme.threeSmall.copyWith(
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ),
                      AxataTheme.styleJarak12,
                      Text(
                        'Konfirmasi Password',
                        style: AxataTheme.sixSmall,
                      ),
                      AxataTheme.styleJarak12,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.w,
                          vertical: 24.h,
                        ),
                        decoration: AxataTheme.styleUnselectBoxFilter,
                        child: TextFormField(
                          controller: controller.passwordKC,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          style: AxataTheme.threeSmall,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Masukkan Konfirmasi Password',
                            hintStyle: AxataTheme.threeSmall.copyWith(
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ),
                      AxataTheme.styleJarak12,
                    ],
                  ),
                ),
                Text(
                  'Tanggal Masuk',
                  style: AxataTheme.sixSmall,
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 24.h),
                    width: double.infinity,
                    decoration: AxataTheme.styleUnselectBoxFilter,
                    child: Obx(
                      () => GestureDetector(
                        onTap: () => controller.handleDatePick(context),
                        child: Text(
                          DateFormat('dd MMMM yyyy', 'id_ID')
                              .format(controller.dateMasuk.value),
                          style: AxataTheme.threeSmall,
                        ),
                      ),
                    ),
                  ),
                ),
                AxataTheme.styleJarak12,
                Text(
                  'Alamat',
                  style: AxataTheme.sixSmall,
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                    vertical: 24.h,
                  ),
                  decoration: AxataTheme.styleUnselectBoxFilter,
                  child: TextFormField(
                    controller: controller.alamatC,
                    keyboardType: TextInputType.text,
                    style: AxataTheme.threeSmall,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Masukkan Alamat',
                      hintStyle: AxataTheme.threeSmall.copyWith(
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
                AxataTheme.styleJarak12,
                Text(
                  'Nomor Telepon',
                  style: AxataTheme.sixSmall,
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                    vertical: 24.h,
                  ),
                  decoration: AxataTheme.styleUnselectBoxFilter,
                  child: TextFormField(
                    controller: controller.noTelpC,
                    keyboardType: TextInputType.number,
                    style: AxataTheme.threeSmall,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Masukkan Nomor Telepon',
                      hintStyle: AxataTheme.threeSmall.copyWith(
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
                AxataTheme.styleJarak12,
                SizedBox(height: 72.h),
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      if (controller.isLoading.isFalse) {
                        controller.handleSimpan(isAdd);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 30.h,
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 60.w),
                      alignment: Alignment.center,
                      decoration: AxataTheme.styleGradientUD,
                      child: Text(
                        controller.isLoading.isFalse ? 'Simpan' : 'Loading..',
                        style: AxataTheme.fiveMiddle.copyWith(
                          color: AxataTheme.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
