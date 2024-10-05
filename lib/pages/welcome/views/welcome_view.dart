import 'package:axata_absensi/pages/welcome/controllers/welcome_controller.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: AxataTheme.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/bg_login.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 120.h,
            child: Column(
              children: [
                Image.asset(
                  'assets/logo/absensi_white.png',
                  height: 170.h,
                ),
                SizedBox(height: 20.h),
                Text(
                  'Selamat datang di Axata Absensi!',
                  style: AxataTheme.twoBold.copyWith(color: AxataTheme.white),
                ),
                Text(
                  'Mulai perjalanan Anda menuju pengelolaan\nabsensi yang lebih mudah dan efisien',
                  style:
                      AxataTheme.threeSmall.copyWith(color: AxataTheme.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            top: 0.24.sh,
            child: Image.asset(
              'assets/image/vector_welcome.png',
              height: 0.35.sh,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 1.sw,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AxataTheme.white,
                borderRadius: BorderRadius.circular(80.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  WelcomeContainer(
                    onTap: () => controller.goLogin(Koneksi.online, 'karyawan'),
                    image: 'assets/image/welcome_karyawan.png',
                    title: 'Masuk sebagai karyawan',
                    subtitle:
                        'Cek kehadiran Anda, lihat riwayat absensi, dan tetap terhubung dengan perusahaan',
                  ),
                  WelcomeContainer(
                    onTap: () =>
                        controller.goLogin(Koneksi.online, 'perusahaan'),
                    image: 'assets/image/welcome_perusahaan.png',
                    title: 'Masuk sebagai perusahaan',
                    subtitle:
                        'Kelola absensi, pantau kehadiran, dan tingkatkan efisiensi tim Anda dengan mudah',
                  ),
                  WelcomeContainer(
                    onTap: () => controller.goLogin(Koneksi.axatapos, ''),
                    image: 'assets/image/welcome_axatapos.png',
                    title: 'Sambungkan dengan AxataPOS',
                    subtitle:
                        'Sinkronkan absensi dengan AxataPOS untuk kemudahan pengelolaan bisnis',
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum memiliki akun ? Daftar',
                        style: AxataTheme.oneSmall,
                      ),
                      SizedBox(width: 20.w),
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.REGISTER),
                        child: Text(
                          'di sini!',
                          style: AxataTheme.oneBold.copyWith(
                            color: AxataTheme.mainColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomeContainer extends StatelessWidget {
  const WelcomeContainer({
    super.key,
    required this.onTap,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final VoidCallback onTap;
  final String image;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 50.w, right: 50.w, bottom: 24.h),
        padding:
            EdgeInsets.symmetric(horizontal: (16 * 3).w, vertical: (13 * 3).h),
        decoration: AxataTheme.styleUnselectBoxFilter,
        child: Row(
          children: [
            Image.asset(
              image,
              width: 20,
              height: 20,
            ),
            SizedBox(width: 48.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AxataTheme.fiveMiddle,
                  ),
                  Text(
                    subtitle,
                    style: AxataTheme.oneSmall,
                    textAlign: TextAlign.justify,
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
