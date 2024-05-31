import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/pages/pegawai/controllers/pegawai_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UbahPasswordPegawai extends StatelessWidget {
  const UbahPasswordPegawai({
    super.key,
    required this.controller,
  });
  final PegawaiController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'Ubah Password'),
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
                SizedBox(height: 72.h),
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      if (controller.isLoading.isFalse) {
                        controller.handleUbahPassword();
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
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
