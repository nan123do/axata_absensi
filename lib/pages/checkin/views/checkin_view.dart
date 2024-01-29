import 'package:axata_absensi/components/small_loading.dart';
import 'package:axata_absensi/pages/checkin/controllers/checkin_controller.dart';
import 'package:axata_absensi/utils/global_data.dart';
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
                          LatLng(
                            GlobalData.office['latitude'],
                            GlobalData.office['longitude'],
                          ),
                          double.parse(GlobalData.office['radius'].toString()),
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
                          'Lokasi Check-In',
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () => controller.goToOffice(),
                                    child: Text(
                                      GlobalData.namatoko,
                                      style: AxataTheme.oneBold.copyWith(
                                        color: AxataTheme.mainColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    GlobalData.alamattoko,
                                    style: AxataTheme.fourSmall,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            )
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
                            Text(
                              '${controller.currentPosition.longitude.toString()}, ${controller.currentPosition.latitude.toString()}',
                              style: AxataTheme.fourSmall,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                        SizedBox(height: 40.h),
                        GestureDetector(
                          onTap: () => controller.goFaceSmiling(),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 360.w,
                              vertical: 30.h,
                            ),
                            decoration: AxataTheme.styleGradientUD,
                            child: Text(
                              'Check-In',
                              style: AxataTheme.fiveMiddle.copyWith(
                                color: AxataTheme.white,
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
