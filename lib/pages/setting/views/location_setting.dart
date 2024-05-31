import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/components/small_loading.dart';
import 'package:axata_absensi/pages/setting/controllers/setting_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationSettingView extends StatelessWidget {
  const LocationSettingView({
    super.key,
    required this.controller,
  });
  final SettingController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'Ubah Lokasi'),
      backgroundColor: AxataTheme.bgGrey,
      body: Obx(
        () => controller.isLoading.value
            ? const SmallLoadingPage()
            : Column(
                children: [
                  Expanded(
                    child: Obx(
                      () => GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            controller.office['latitude'],
                            controller.office['longitude'],
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
                              controller.office['latitude'],
                              controller.office['longitude'],
                            ),
                            infoWindow: const InfoWindow(
                              title: 'Lokasi Saat Ini',
                            ),
                          ),
                        },
                        polygons: {
                          controller.createRadiusPolygon(
                            LatLng(
                              controller.office['latitude'],
                              controller.office['longitude'],
                            ),
                            double.parse(
                                controller.office['radius'].toString()),
                          ),
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    // height: 0.4.sh,
                    margin:
                        EdgeInsets.symmetric(horizontal: 60.w, vertical: 36.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 60.w, vertical: 60.h),
                    decoration: AxataTheme.styleUnselectBoxFilter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Latitude & Longitude',
                          style: AxataTheme.sixSmall,
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.w,
                            vertical: 24.h,
                          ),
                          decoration: AxataTheme.styleUnselectBoxFilter,
                          child: TextFormField(
                            controller: controller.latLongC,
                            keyboardType: TextInputType.text,
                            style: AxataTheme.threeSmall,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Masukkan Langitude,Longitude',
                              hintStyle: AxataTheme.threeSmall.copyWith(
                                color: Colors.black45,
                              ),
                            ),
                            onEditingComplete: () {
                              controller.updateMapLocation();
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Alamat : ${controller.ubahLocation.value == '' ? controller.location.value : controller.ubahLocation.value}',
                          style: AxataTheme.sixSmall,
                        ),
                        SizedBox(height: 48.h),
                        GestureDetector(
                          onTap: () => controller.handleThisLoc(),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 30.w,
                              vertical: 24.h,
                            ),
                            decoration: AxataTheme.styleUnselectBoxFilter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.mapPin,
                                  size: 50.r,
                                ),
                                SizedBox(width: 30.w),
                                Text(
                                  'Gunakan lokasi saya saat ini',
                                  style: AxataTheme.threeSmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 48.h),
                        Text(
                          'Radius Absen (Meter)',
                          style: AxataTheme.sixSmall,
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.w,
                            vertical: 24.h,
                          ),
                          decoration: AxataTheme.styleUnselectBoxFilter,
                          child: TextFormField(
                            controller: controller.radiusC,
                            keyboardType: TextInputType.number,
                            style: AxataTheme.threeSmall,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Masukkan Radius',
                              hintStyle: AxataTheme.threeSmall.copyWith(
                                color: Colors.black45,
                              ),
                            ),
                            onChanged: (value) =>
                                controller.updateRadius(value),
                          ),
                        ),
                        SizedBox(height: 72.h),
                        GestureDetector(
                          onTap: () => controller.handleSimpan(),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 30.h,
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 60.w),
                            alignment: Alignment.center,
                            decoration: AxataTheme.styleGradientUD,
                            child: Text(
                              'Simpan',
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
