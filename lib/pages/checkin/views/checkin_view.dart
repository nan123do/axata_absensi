import 'package:axata_absensi/components/small_loading.dart';
import 'package:axata_absensi/pages/checkin/controllers/checkin_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckInView extends GetView<CheckInController> {
  const CheckInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AxataTheme.mainColor,
      body: Obx(
        () => controller.isLoading.value
            ? const SmallLoadingPage()
            : Column(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        controller.currentPosition.latitude,
                        controller.currentPosition.longitude,
                      ),
                      zoom: 14.0,
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
                  ),
                  Obx(
                    () => Text(
                      'Jarak ke kantor: ${Get.find<CheckInController>().officeDistance.value}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await Get.find<CheckInController>().getDistanceToOffice();
                    },
                    child: const Text('Periksa Jarak ke Kantor'),
                  ),
                ],
              ),
      ),
    );
  }
}
