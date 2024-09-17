import 'dart:async';
import 'dart:math';

import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/components/loading_screen.dart';
import 'package:axata_absensi/models/Shift/datashift_model.dart';
import 'package:axata_absensi/pages/home/controllers/home_controller.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/services/absensi_service.dart';
import 'package:axata_absensi/services/online/online_absensi_service.dart';
import 'package:axata_absensi/utils/datehelper.dart';
import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/locationhelper.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckInController extends GetxController {
  final homeController = Get.find<HomeController>();
  TextEditingController keteranganC = TextEditingController();
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
    Map<String, dynamic> data = await determinePosition();
    currentPosition = data['position'];
    update();
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

  Future<Map<String, dynamic>> determinePosition() async {
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
    Map<String, dynamic> positionDetermine = await determinePosition();

    if (!positionDetermine["error"]) {
      Position position = positionDetermine["position"];
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

  Future<void> goToCurrentPosition() async {
    final GoogleMapController controller = mapController;
    CameraPosition goOffice = CameraPosition(
      target: LatLng(
        currentPosition.latitude,
        currentPosition.longitude,
      ),
      zoom: 20,
    );
    await controller.animateCamera(CameraUpdate.newCameraPosition(goOffice));
  }

  Future<void> goFaceSmiling() async {
    if (await LocationHelper.isUsingMockLocation() &&
        PegawaiData.isNotNando()) {
      CustomToast.errorToast(
        "Opsi Pengembang Aktif",
        "Nonaktifkan opsi pengembang dan coba lagi",
      );
      return;
    }

    await getCurrentLocation();
    await getDistanceToOffice();
    await goToCurrentPosition();

    if (officeDistance.value == 'Didalam Area') {
      Get.toNamed(Routes.SMILEFACE);
    } else {
      CustomToast.errorToast("Error", "Anda masih berada diluar kantor");
      Get.toNamed(Routes.SMILEFACE);
    }
  }

  Future<void> simpanCheckIn({XFile? file}) async {
    try {
      DataShiftModel? data = homeController.selectedShift;
      String jadwalMasuk = DateHelper.strHMStoHM(data!.jamMasuk);
      String jadwalKeluar = DateHelper.strHMStoHM(data.jamKeluar);
      TimeOfDay jadwalIn = DateHelper.stringToTime(jadwalMasuk);
      bool popup = DateHelper.isTimeBeforeEndTime(jadwalIn, TimeOfDay.now());
      if (popup) {
        await Get.defaultDialog(
          title: "Kamu Terlambat",
          barrierDismissible: false,
          titlePadding: EdgeInsets.symmetric(vertical: 25.h),
          titleStyle: AxataTheme.twoBold,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.timesCircle,
                color: AxataTheme.red,
                size: 300.r,
              ),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 24.h),
                decoration: BoxDecoration(
                  color: AxataTheme.bgGrey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AxataTheme.black),
                ),
                child: TextFormField(
                  controller: keteranganC,
                  style: AxataTheme.threeSmall,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Tulis alasan terlambat disini',
                    hintStyle: AxataTheme.threeSmall.copyWith(
                      color: Colors.black45,
                    ),
                  ),
                ),
              ),
            ],
          ),
          onConfirm: () {
            simpanAbsenMasukAPI(
                data.id, '$jadwalMasuk-$jadwalKeluar', keteranganC.text, file);
          },
          textConfirm: "Oke",
          confirmTextColor: AxataTheme.white,
          // onCancel: () {
          //   simpanAbsenMasukAPI(data.id, '$jadwalMasuk-$jadwalKeluar');
          // },
          // textCancel: "Batal",
          onWillPop: () async {
            // simpanAbsenMasukAPI(data.id, '$jadwalMasuk-$jadwalKeluar');
            return true;
          },
        );
      } else {
        simpanAbsenMasukAPI(data.id, '$jadwalMasuk-$jadwalKeluar', '', file);
      }
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    }
  }

  Future<void> simpanAbsenMasukAPI(
    String id,
    String jadwal,
    String keterangan,
    XFile? file,
  ) async {
    try {
      LoadingScreen.show();
      await handleAbsenMasuk(id, jadwal, keterangan, file);
      if (file != null && GlobalData.globalKoneksi == Koneksi.axatapos) {
        await handleSimpanGambar(file);
      }
      CustomToast.successToast("Success", "Berhasil Absen Masuk");

      final HomeController homeC = Get.find();
      homeC.getInit();

      await Future.delayed(Duration.zero);
      LoadingScreen.hide();
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      LoadingScreen.hide();
      CustomToast.errorToast('Error', 'Ada error $e');
    }
  }

  handleSimpanGambar(XFile source) async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      AbsensiService serviceAbsensi = AbsensiService();
      await serviceAbsensi.simpanGambar(source);
    }
  }

  handleAbsenMasuk(
      String id, String jadwal, String keterangan, XFile? file) async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineAbsensiService serviceOnline = OnlineAbsensiService();
      await serviceOnline.simpanAbsenMasuk(
        keterangan: keterangan,
        idShift: id,
        jamKerja: jadwal,
        file: file,
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      await serviceAbsensi.simpanAbsenMasuk(
        keterangan: keterangan,
        idShift: id,
        jamKerja: jadwal,
      );
    }
  }
}
