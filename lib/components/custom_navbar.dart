import 'package:axata_absensi/components/pageindex_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CustomNavBarView extends GetView<PageIndexController> {
  const CustomNavBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: controller.pageIndex.value,
      onTap: (index) {
        controller.changePage(index);
      },
      selectedItemColor: AxataTheme.mainColor,
      unselectedItemColor: AxataTheme.black,
      showUnselectedLabels: true,
      iconSize: 30,
      items: [
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.home,
            size: 60.r,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.user,
            size: 60.r,
          ),
          label: 'Profil',
        ),
      ],
    );
  }
}
