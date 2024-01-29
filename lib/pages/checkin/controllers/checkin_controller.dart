import 'dart:async';
import 'dart:math';

import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/models/Shift/datashift_model.dart';
import 'package:axata_absensi/pages/home/controllers/home_controller.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/services/absensi_service.dart';
import 'package:axata_absensi/utils/datehelper.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckInController extends GetxController {
  final homeController = Get.find<HomeController>();
  RxBool isLoading = false.obs;
  RxBool isLoadingDistance = false.obs;
  RxString officeDistance = "-".obs;
  late GoogleMapController mapController;
  late Position currentPosition;
  Timer? timer;
  AbsensiService serviceAbsensi = AbsensiService();

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getInit();

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getDistanceToOffice();
    });
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

  Future<void> refreshCurrentLocation() async {
    isLoadingDistance.value = true;
    try {
      await getDistanceToOffice();
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoadingDistance.value = false;
    }
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
        result = "Didalam Area";
      } else {
        result = "Diluar Area";
      }
    } else {
      result = "-";
    }
    officeDistance.value = result;
    return result;
  }

  // Membuat poligon yang merepresentasikan radius dari titik awal
  Polygon createRadiusPolygon(LatLng center, double radiusInMeters) {
    List<LatLng> points = [];
    int sides = 360;

    double earthRadius = 6371000.0; // Radius Bumi dalam meter

    double lat1 = center.latitude * pi / 180.0;
    double lng1 = center.longitude * pi / 180.0;

    for (int i = 0; i < sides; i++) {
      double angle = 2 * pi * i / sides;
      double dist = radiusInMeters / earthRadius;
      double bearing = angle;

      double lat2 =
          asin(sin(lat1) * cos(dist) + cos(lat1) * sin(dist) * cos(bearing));
      double lng2 = lng1 +
          atan2(sin(bearing) * sin(dist) * cos(lat1),
              cos(dist) - sin(lat1) * sin(lat2));

      lat2 = lat2 * 180.0 / pi;
      lng2 = lng2 * 180.0 / pi;

      points.add(LatLng(lat2, lng2));
    }

    return Polygon(
      polygonId: const PolygonId('radius_polygon'),
      points: points,
      strokeWidth: 2,
      strokeColor: AxataTheme.mainColor,
      fillColor: AxataTheme.mainColor.withOpacity(0.5),
    );
  }

  Future<void> goToOffice() async {
    final GoogleMapController controller = mapController;
    CameraPosition goOffice = CameraPosition(
      target: LatLng(
        GlobalData.office['latitude'],
        GlobalData.office['longitude'],
      ),
      zoom: 20,
    );
    await controller.animateCamera(CameraUpdate.newCameraPosition(goOffice));
  }

  Future<void> goFaceSmiling() async {
    if (officeDistance.value == 'Didalam Area') {
      Get.toNamed(Routes.SMILEFACE);
    } else {
      CustomToast.errorToast("Error", "Anda masih berada diluar kantor");
    }
  }

  Future<void> simpanCheckIn() async {
    try {
      DataShiftModel? data = homeController.selectedShift;
      String jadwalMasuk = DateHelper.strHMStoHM(data!.jamMasuk);
      String jadwalKeluar = DateHelper.strHMStoHM(data.jamKeluar);
      await serviceAbsensi.simpanAbsenMasuk(
        keterangan: 'Absen masuk ${PegawaiData.nama}',
        idShift: data.id,
        jamKerja: '$jadwalMasuk-$jadwalKeluar',
      );
      CustomToast.successToast("Success", "Berhasil Absen Masuk");
      await Future.delayed(Duration.zero);
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    }
  }
}
