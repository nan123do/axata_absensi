import 'package:axata_absensi/components/small_loading.dart';
import 'package:axata_absensi/pages/profile/views/profile_view.dart';
import 'package:axata_absensi/pages/setting/controllers/setting_controller.dart';
import 'package:axata_absensi/pages/setting/views/location_setting.dart';
import 'package:axata_absensi/pages/setting/views/smile_setting.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AxataTheme.bgGrey,
      body: Obx(
        () => controller.isLoading.value
            ? const SmallLoadingPage()
            : Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/image/bg_profile.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 200.h,
                    left: 70.w,
                    child: Text(
                      'Setting',
                      style:
                          AxataTheme.twoBold.copyWith(color: AxataTheme.white),
                    ),
                  ),
                  Positioned(
                    top: 0.2.sh,
                    child: SizedBox(
                      width: 0.9.sw,
                      child: Column(
                        children: [
                          Text(
                            'ADMIN',
                            style: AxataTheme.twoBold.copyWith(
                              color: AxataTheme.white,
                            ),
                          ),
                          SizedBox(height: 50.h),
                          ListMenu(
                            title: 'Nama Usaha atau Toko',
                            subtitle: GlobalData.namatoko,
                            icon: FontAwesomeIcons.building,
                            color: AxataTheme.mainColor,
                          ),
                          Obx(
                            () => ListMenu(
                              title: 'Lokasi',
                              subtitle: controller.location.value,
                              icon: FontAwesomeIcons.mapPin,
                              color: AxataTheme.mainColor,
                              ontap: () {
                                controller.getInit(type: 'location');
                                Get.to(
                                  () => LocationSettingView(
                                    controller: controller,
                                  ),
                                );
                              },
                            ),
                          ),
                          ListMenu(
                            title: 'Senyum',
                            subtitle: 'Setting Senyum',
                            icon: FontAwesomeIcons.smile,
                            color: AxataTheme.mainColor,
                            ontap: () {
                              controller.getInit();
                              Get.to(
                                () => SmileSettingView(
                                  controller: controller,
                                ),
                              );
                            },
                          ),
                          ListMenu(
                            title: '-',
                            subtitle: 'Syarat Ketentuan',
                            icon: FontAwesomeIcons.fileAlt,
                            color: AxataTheme.mainColor,
                            ontap: () {},
                          ),
                          ListMenu(
                            title: '-',
                            subtitle: 'Kebijakan Privasi',
                            icon: FontAwesomeIcons.shieldAlt,
                            color: AxataTheme.mainColor,
                            ontap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
