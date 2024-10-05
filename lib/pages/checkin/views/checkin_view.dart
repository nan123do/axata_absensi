import 'package:axata_absensi/components/small_loading.dart';
import 'package:axata_absensi/pages/checkin/controllers/checkin_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckInView extends GetView<CheckInController> {
  const CheckInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AxataTheme.white,
      body: Obx(
        () => controller.isLoading.value
            ? const SmallLoadingPage()
            : Column(
                children: [
                  Expanded(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          controller.currentPosition.latitude,
                          controller.currentPosition.longitude,
                        ),
                        zoom: 20.0,
                      ),
                      onMapCreated: (GoogleMapController mapC) {
                        controller.mapController = mapC;
                      },
                      markers: {
                        Marker(
                          markerId: const MarkerId('CurrentLocation'),
                          position: LatLng(
                            controller.currentPosition.latitude,
                            controller.currentPosition.longitude,
                          ),
                          infoWindow: const InfoWindow(
                            title: 'Lokasi Saat Ini',
                          ),
                        ),
                      },
                      polygons: {
                        controller.createRadiusPolygon(
                          LatLng(controller.office['latitude'],
                              controller.office['longitude']),
                          controller.office['radius'],
                        ),
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: AxataTheme.styleUnselectBoxFilter,
                    padding: EdgeInsets.symmetric(
                      horizontal: 60.w,
                      vertical: 40.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lokasi Absen Masuk',
                          style: AxataTheme.twoBold,
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => controller.refreshCurrentLocation(),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 36.w),
                                decoration: AxataTheme.styleGradientUD,
                                child: Obx(
                                  () => Text(
                                    controller.officeDistance.value,
                                    style: AxataTheme.sixSmall.copyWith(
                                      color: AxataTheme.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 40.w,
                            ),
                            Obx(() => controller.isLoadingDistance.value
                                ? SizedBox(
                                    width: 35.h,
                                    height: 35.h,
                                    child: const CircularProgressIndicator(),
                                  )
                                : Container()),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          'Lokasi kantor',
                          style: AxataTheme.fiveMiddle,
                        ),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.building,
                              size: 50.r,
                              color: AxataTheme.mainColor,
                            ),
                            SizedBox(width: 24.w),
                            Obx(
                              () => Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () => controller.goToOffice(),
                                      child: Text(
                                        controller.lokasi['nama']!,
                                        style: AxataTheme.oneBold.copyWith(
                                          color: AxataTheme.mainColor,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      controller.lokasi['alamat']!,
                                      style: AxataTheme.fourSmall,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => controller.goPilihLokasi(),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 20.h,
                                ),
                                decoration: AxataTheme.styleGradientUD,
                                child: Text(
                                  'Ubah Lokasi',
                                  style: AxataTheme.fourSmall.copyWith(
                                    color: AxataTheme.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Lokasi kamu saat ini',
                          style: AxataTheme.fiveMiddle,
                        ),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.building,
                              size: 50.r,
                              color: AxataTheme.mainColor,
                            ),
                            SizedBox(width: 24.w),
                            Obx(
                              () => Text(
                                controller.locationNow.value,
                                style: AxataTheme.fourSmall,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40.h),
                        Center(
                          child: GestureDetector(
                            onTap: () => controller.goFaceSmiling(),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 300.w,
                                vertical: 30.h,
                              ),
                              decoration: AxataTheme.styleGradientUD,
                              child: Text(
                                'Absen Masuk',
                                style: AxataTheme.fiveMiddle.copyWith(
                                  color: AxataTheme.white,
                                ),
                              ),
                            ),
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
