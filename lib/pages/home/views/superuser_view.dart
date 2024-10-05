import 'package:axata_absensi/components/custom_navbar.dart';
import 'package:axata_absensi/pages/home/controllers/home_controller.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SuperUserPage extends StatelessWidget {
  const SuperUserPage({
    super.key,
    required this.controller,
  });
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomNavBarView(),
      backgroundColor: AxataTheme.bgGrey,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/bg_profile.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 250.h,
            left: 70.w,
            child: SizedBox(
              width: 0.8.sw,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Super Admin",
                    style: AxataTheme.twoBold.copyWith(color: AxataTheme.white),
                  ),
                  Text(
                    "Axata Absensi",
                    style:
                        AxataTheme.fourSmall.copyWith(color: AxataTheme.white),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0.25.sh,
            child: SizedBox(
              width: 0.9.sw,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 39.h,
                      horizontal: 84.w,
                    ),
                    decoration: BoxDecoration(
                      color: AxataTheme.white,
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      children: [
                        ListMenuAdmin(
                          title: 'Penyewa',
                          icon: FontAwesomeIcons.building,
                          color: AxataTheme.mainColor,
                          onTap: () => Get.toNamed(Routes.TENANT),
                        ),
                        ListMenuAdmin(
                          title: 'Registrasi',
                          icon: FontAwesomeIcons.clipboardCheck,
                          color: AxataTheme.mainColor,
                          onTap: () => Get.toNamed(Routes.REGISTRASI),
                        ),
                        ListMenuAdmin(
                          title: '',
                          icon: FontAwesomeIcons.mapPin,
                          color: AxataTheme.mainColor,
                          onTap: () {},
                        ),
                        ListMenuAdmin(
                          title: '',
                          icon: FontAwesomeIcons.mapPin,
                          color: AxataTheme.mainColor,
                          onTap: () {},
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListMenuAdmin extends StatelessWidget {
  const ListMenuAdmin({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (title == '') {
      return SizedBox(width: 150.w);
    }
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          FaIcon(
            icon,
            color: color,
            size: 60.r,
          ),
          Text(
            title,
            style: AxataTheme.oneSmall,
          )
        ],
      ),
    );
  }
}
