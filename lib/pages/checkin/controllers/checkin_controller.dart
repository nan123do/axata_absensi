import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckInController extends GetxController {
  RxBool isLoading = false.obs;
  RxString officeDistance = "-".obs;
  late GoogleMapController mapController;
  late Position currentPosition;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getInit();
  }

  getInit() async {
    try {
      await getCurrentLocation();
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCurrentLocation() async {
    Map<String, dynamic> data = await _determinePosition();
    currentPosition = data['position'];
  }

  Future<Map<String, dynamic>> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.rawSnackbar(
        title: 'GPS is off',
        message: 'you need to turn on gps',
        duration: const Duration(seconds: 3),
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {
          "message":
              "Tidak dapat mengakses karena anda menolak permintaan lokasi",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message":
            "Location permissions are permanently denied, we cannot request permissions.",
        "error": true,
      };
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    return {
      "position": position,
      "message": "Berhasil mendapatkan posisi device",
      "error": false,
    };
  }

  Future<String> getDistanceToOffice() async {
    String result = '-';
    Map<String, dynamic> determinePosition = await _determinePosition();

    if (!determinePosition["error"]) {
      Position position = determinePosition["position"];
      double distance = Geolocator.distanceBetween(
        GlobalData.office['latitude'],
        GlobalData.office['longitude'],
        position.latitude,
        position.longitude,
      );

      if (distance <= GlobalData.office['radius']) {
        result = "inarea_office".tr;
      } else {
        result = "inarea_office".tr;
      }
    } else {
      result = "-";
    }
    officeDistance.value = result;
    return result;
  }
}
