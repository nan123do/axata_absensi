import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/pages/tenant/controllers/tenant_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      appBar: CustomAppBar(title: isAdd ? 'Tambah Penyewa' : 'Ubah Penyewa'),
      backgroundColor: AxataTheme.bgGrey,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 30.w,
          vertical: 10.h,
        ),
        color: AxataTheme.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informasi Data Diri',
                style: AxataTheme.fiveMiddle,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 30.w,
                  vertical: 10.h,
                ),
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
                    Visibility(
                      visible: isAdd,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          SizedBox(height: 12.h),
                          Text(
                            'No Telp Admin',
                            style: AxataTheme.sixSmall,
                          ),
                          SizedBox(height: 12.h),
                          AxataTheme.styleJarak12,
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30.w,
                              vertical: 24.h,
                            ),
                            decoration: AxataTheme.styleUnselectBoxFilter,
                            child: TextFormField(
                              controller: controller.telpC,
                              keyboardType: TextInputType.number,
                              style: AxataTheme.threeSmall,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Masukkan No Telp Admin',
                                hintStyle: AxataTheme.threeSmall.copyWith(
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
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
                          SizedBox(height: 72.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isAdd,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Keamanan Akun',
                      style: AxataTheme.fiveMiddle,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.w,
                        vertical: 10.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Username Admin',
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
                              controller: controller.usernameC,
                              keyboardType: TextInputType.text,
                              style: AxataTheme.threeSmall,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Username Admin',
                                hintStyle: AxataTheme.threeSmall.copyWith(
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                          ),
                          AxataTheme.styleJarak12,
                          Text(
                            'Password',
                            style: AxataTheme.sixSmall,
                          ),
                          SizedBox(height: 12.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30.w,
                              vertical: 24.h,
                            ),
                            decoration: AxataTheme.styleUnselectBoxFilter,
                            child: Row(
                              children: [
                                Obx(
                                  () => Expanded(
                                    child: TextFormField(
                                      controller: controller.passwordC,
                                      keyboardType: TextInputType.text,
                                      style: AxataTheme.threeSmall,
                                      obscureText:
                                          controller.isObsecurePassword.value,
                                      decoration: InputDecoration.collapsed(
                                        hintText: 'Masukkan Password',
                                        hintStyle:
                                            AxataTheme.threeSmall.copyWith(
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      controller.isObsecurePassword.value =
                                          !(controller
                                              .isObsecurePassword.value);
                                    },
                                    child: FaIcon(
                                      controller.isObsecurePassword.value
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: 50.r,
                                      color: AxataTheme.mainColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AxataTheme.styleJarak12,
                          Text(
                            'Konfirmasi Password',
                            style: AxataTheme.sixSmall,
                          ),
                          SizedBox(height: 12.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30.w,
                              vertical: 24.h,
                            ),
                            decoration: AxataTheme.styleUnselectBoxFilter,
                            child: Row(
                              children: [
                                Obx(
                                  () => Expanded(
                                    child: TextFormField(
                                      controller: controller.passwordKC,
                                      keyboardType: TextInputType.text,
                                      style: AxataTheme.threeSmall,
                                      obscureText:
                                          controller.isObsecurePasswordK.value,
                                      decoration: InputDecoration.collapsed(
                                        hintText:
                                            'Masukkan Konfirmasi Password',
                                        hintStyle:
                                            AxataTheme.threeSmall.copyWith(
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      controller.isObsecurePasswordK.value =
                                          !(controller
                                              .isObsecurePasswordK.value);
                                    },
                                    child: FaIcon(
                                      controller.isObsecurePasswordK.value
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: 50.r,
                                      color: AxataTheme.mainColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
              SizedBox(height: 72.h),
            ],
          ),
        ),
      ),
    );
  }
}
