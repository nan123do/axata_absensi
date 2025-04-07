import 'package:axata_absensi/components/custom_navbar.dart';
import 'package:axata_absensi/components/small_loading.dart';
import 'package:axata_absensi/pages/home/controllers/home_controller.dart';
import 'package:axata_absensi/pages/home/views/check_container.dart';
import 'package:axata_absensi/pages/home/views/display_data.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PegawaiHomepage extends StatelessWidget {
  const PegawaiHomepage({
    super.key,
    required this.controller,
  });
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  Obx(
                    () => controller.statusShift.value == '1'
                        ? Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 200.w,
                              vertical: 24.h,
                            ),
                            decoration: AxataTheme.styleUnselectBoxFilter,
                            alignment: Alignment.center,
                            child: Obx(
                              () => controller.isEmptySelectedShift.value &&
                                      controller.selectedShift == null
                                  ? GestureDetector(
                                      onTap: () => controller.pilihShift(),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 30.w,
                                          vertical: 12.h,
                                        ),
                                        decoration: AxataTheme.styleGradientUD,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Pilih shift kamu hari ini',
                                          style: AxataTheme.oneBold.copyWith(
                                            color: AxataTheme.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : controller.doneCheckIn.value == ''
                                      ? GestureDetector(
                                          onTap: () => controller.pilihShift(),
                                          child: Text(
                                            controller.selectedShift!.nama,
                                            style: AxataTheme.oneBold,
                                          ),
                                        )
                                      : Text(
                                          controller.selectedShift!.nama,
                                          style: AxataTheme.oneBold,
                                        ),
                            ),
                          )
                        : Container(),
                  ),
                  Obx(
                    () => controller.statusShift.value == '1'
                        ? SizedBox(height: 24.h)
                        : Container(),
                  ),
                  CheckInOutContainer(
                    onTap: () => controller.checkIn(),
                    controller: controller,
                    isCheckIn: true,
                    timeCheck: controller.doneCheckIn,
                  ),
                  CheckInOutContainer(
                    onTap: () {
                      if (controller.checkoutInStore.value) {
                        Get.toNamed(Routes.CHECKIN, arguments: {
                          'type': 'out',
                        });
                      } else {
                        controller.checkOut();
                      }
                    },
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
                  Row(
                    children: [
                      Text(
                        'Riwayat',
                        style: AxataTheme.fiveMiddle,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.ABSENSI),
                        child: Text(
                          'Lihat Semua',
                          style: AxataTheme.oneSmall.copyWith(
                            color: AxataTheme.mainColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Obx(
                    () => Container(
                      height: controller.statusShift.value == '0'
                          ? 0.41.sh
                          : 0.36.sh,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.w,
                        vertical: 36.h,
                      ),
                      decoration: AxataTheme.styleUnselectBoxFilter,
                      child: controller.isLoading.value
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
                                  'Total masuk bulan ini : ${controller.hariMasuk} hari',
                                  style: AxataTheme.threeSmall,
                                ),
                                Obx(
                                  () => Text(
                                    'Telat : ${controller.telat.value} kali',
                                    style: AxataTheme.threeSmall,
                                  ),
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
