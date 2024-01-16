import 'package:axata_absensi/components/custom_navbar.dart';
import 'package:axata_absensi/components/small_loading.dart';
import 'package:axata_absensi/pages/home/controllers/home_controller.dart';
import 'package:axata_absensi/pages/home/views/check_container.dart';
import 'package:axata_absensi/pages/home/views/display_data.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomNavBarView(),
      backgroundColor: AxataTheme.bgGrey,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 300.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 60.w,
              ),
              decoration: AxataTheme.styleGradient,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo',
                    style: AxataTheme.oneBold.copyWith(
                      color: AxataTheme.white,
                    ),
                  ),
                  Text(
                    GlobalData.username,
                    style: AxataTheme.twoBold.copyWith(
                      color: AxataTheme.white,
                    ),
                  ),
                  Text(
                    GlobalData.namatoko,
                    style: AxataTheme.threeSmall.copyWith(
                      color: AxataTheme.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 33.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 50.w,
                vertical: 30.h,
              ),
              color: AxataTheme.white,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Hari Ini - ${controller.dateText}',
                    style: AxataTheme.fiveMiddle,
                  ),
                  SizedBox(height: 24.h),
                  CheckInOutContainer(
                    onTap: () => controller.checkIn(),
                    controller: controller,
                    isCheckIn: true,
                    timeCheck: controller.doneCheckIn,
                  ),
                  CheckInOutContainer(
                    onTap: () => controller.checkOut(),
                    controller: controller,
                    isCheckIn: false,
                    timeCheck: controller.doneCheckOut,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 50.w,
                vertical: 30.h,
              ),
              color: AxataTheme.white,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Riwayat',
                    style: AxataTheme.fiveMiddle,
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    height: 0.43.sh,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.w,
                      vertical: 36.h,
                    ),
                    decoration: AxataTheme.styleUnselectBoxFilter,
                    child: Obx(
                      () => controller.isLoading.value
                          ? const SmallLoadingPage()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: controller.listAbsen.isEmpty
                                      ? Center(
                                          child: Text(
                                            "Data Kosong..",
                                            style: AxataTheme.oneSmall,
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount:
                                              controller.listAbsen.length,
                                          itemBuilder: (context, index) {
                                            return DisplayDataCheckInOut(
                                              controller: controller,
                                              data: controller.listAbsen[index],
                                            );
                                          },
                                        ),
                                ),
                                SizedBox(height: 36.h),
                                Text(
                                  'Total masuk bulan ini : 2 hari',
                                  style: AxataTheme.threeSmall,
                                ),
                                Text(
                                  'Telat : 2 hari',
                                  style: AxataTheme.threeSmall,
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
