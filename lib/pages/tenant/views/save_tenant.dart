import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/pages/tenant/controllers/tenant_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SaveTenant extends StatelessWidget {
  const SaveTenant({
    super.key,
    required this.controller,
    required this.isAdd,
  });
  final TenantController controller;
  final bool isAdd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: isAdd ? 'Tambah Penyewa' : 'Ubah Penyewa'),
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
                  'Nama Perusahaan',
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
                      hintText: 'Masukkan Nama Perusahaan',
                      hintStyle: AxataTheme.threeSmall.copyWith(
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
                AxataTheme.styleJarak12,
                Text(
                  'Alamat Perusahaan',
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
                      hintText: 'Masukkan Alamat Perusahaan',
                      hintStyle: AxataTheme.threeSmall.copyWith(
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
                AxataTheme.styleJarak12,
                Text(
                  'Username Admin',
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
                      hintText: 'Masukkan Username Admin',
                      hintStyle: AxataTheme.threeSmall.copyWith(
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Email Admin',
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
                      hintText: 'Masukkan Email Admin',
                      hintStyle: AxataTheme.threeSmall.copyWith(
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
                AxataTheme.styleJarak12,
                Text(
                  'Nama Admin',
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
                    controller: controller.firstnameC,
                    keyboardType: TextInputType.text,
                    style: AxataTheme.threeSmall,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Masukkan Nama Admin',
                      hintStyle: AxataTheme.threeSmall.copyWith(
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
                Text(
                  '*password default "ADMIN"',
                  style: AxataTheme.sixSmall,
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
