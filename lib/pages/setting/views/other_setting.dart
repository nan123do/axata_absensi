import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/components/small_loading.dart';
import 'package:axata_absensi/pages/setting/controllers/setting_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OtherSettingView extends StatelessWidget {
  const OtherSettingView({
    super.key,
    required this.controller,
  });
  final SettingController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'Setting Lainnya'),
      backgroundColor: AxataTheme.bgGrey,
      body: Obx(
        () => controller.isLoading.value
            ? const SmallLoadingPage()
            : Column(
                children: [
                  SizedBox(height: 30.h),
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 60.w, vertical: 30.h),
                    decoration: AxataTheme.styleUnselectBoxFilter,
                    child: Row(
                      children: [
                        const Text(
                          'Aktifkan Lokasi Validasi Absen Keluar',
                        ),
                        const Spacer(),
                        Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            value: controller.checkoutInStore.value,
                            onChanged: (hasil) {
                              controller
                                  .ubahAktifkanLokasiValidasiAbsenKeluar(hasil);
                            },
                            activeColor: AxataTheme.mainColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
