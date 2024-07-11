import 'package:axata_absensi/pages/home/controllers/home_controller.dart';
import 'package:axata_absensi/pages/home/views/admin_view.dart';
import 'package:axata_absensi/pages/home/views/pegawai_view.dart';
import 'package:axata_absensi/pages/home/views/superuser_view.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    if (PegawaiData.isSuperUser) {
      return SuperUserPage(controller: controller);
    } else if (PegawaiData.isAdmin) {
      return AdminHomePage(controller: controller);
    } else {
      return PegawaiHomepage(controller: controller);
    }
  }
}
