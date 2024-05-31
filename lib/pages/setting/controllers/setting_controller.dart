import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/pages/checkin/controllers/checkin_controller.dart';
import 'package:axata_absensi/services/online/online_setting_service.dart';
import 'package:axata_absensi/services/setting_service.dart';
import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SettingController extends GetxController {
  final checkInController = Get.put(CheckInController());
  TextEditingController radiusC = TextEditingController(text: '');
  TextEditingController latLongC = TextEditingController(text: '');
  TextEditingController smilePercentC = TextEditingController(text: '');
  TextEditingController smileDurationC = TextEditingController(text: '');
  RxBool isLoading = false.obs;
  RxBool isFirst = true.obs;
  RxString location = ''.obs;
  RxString ubahLocation = ''.obs;

  late Position currentPosition;
  late GoogleMapController mapController;
  RxMap<String, dynamic> office = <String, dynamic>{}.obs;
  SettingService serviceSetting = SettingService();

  @override
  void onInit() {
    super.onInit();
    getInit();
  }

  getInit({String type = ''}) async {
    isLoading.value = true;
    try {
      office.value = Map<String, dynamic>.from(GlobalData.office);
      if (type == 'location' || isFirst.value) {
        location.value = GlobalData.alamattoko;
        // await getLocation();
      }
      radiusC.text = office['radius'].round().toString();
      latLongC.text = '${office['latitude']},${office['longitude']}';
      smilePercentC.text = '${GlobalData.smilePercent}';
      smileDurationC.text = '${GlobalData.smileDuration}';
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
      isLoading.value = false;
    }
  }

  getLocation() async {
    Map<String, dynamic> data = await checkInController.determinePosition();
    currentPosition = data['position'];
    List<Placemark> placemarks = await placemarkFromCoordinates(
      office['latitude'],
      office['longitude'],
    );
    String address =
        "${placemarks.first.street}, ${placemarks.first.subLocality}, ${placemarks.first.locality}";
    location.value = address;
    ubahLocation.value = location.value.toString();
  }

  Polygon createRadiusPolygon(LatLng center, double radiusInMeters) {
    return checkInController.createRadiusPolygon(center, radiusInMeters);
  }

  updateRadius(String value) {
    if (value != '') {
      office['radius'] = double.parse(value);
    }
  }

  handleThisLoc() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    office['latitude'] = position.latitude;
    office['longitude'] = position.longitude;

    // Konversi posisi ke alamat
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    String address =
        "${placemarks.first.street}, ${placemarks.first.subLocality}, ${placemarks.first.locality}";
    ubahLocation.value = address;

    latLongC.text = '${position.latitude},${position.longitude}';

    // Perbarui map dan polygon
    mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      ),
    );

    // Update polygon
    updatePolygon();
  }

  Future<void> updateMapLocation() async {
    if (latLongC.text.isNotEmpty) {
      List<String> latLong = latLongC.text.split(',');
      if (latLong.length == 2) {
        double latitude = double.tryParse(latLong[0]) ?? office['latitude'];
        double longitude = double.tryParse(latLong[1]) ?? office['longitude'];
        office['latitude'] = latitude;
        office['longitude'] = longitude;

        // Konversi posisi ke alamat
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);
        String address =
            "${placemarks.first.street}, ${placemarks.first.subLocality}, ${placemarks.first.locality}";
        ubahLocation.value = address;

        // Opsi untuk langsung memperbarui tampilan map
        mapController.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(latitude, longitude),
          ),
        );

        // Update polygon
        updatePolygon();
      }
    }
  }

  void updatePolygon() {
    createRadiusPolygon(
      LatLng(office['latitude'], office['longitude']),
      double.parse(office['radius'].toString()),
    );
  }

  Future<void> handleSimpan() async {
    try {
      if (GlobalData.globalKoneksi == Koneksi.online) {
        OnlineSettingService serviceOnline = OnlineSettingService();
        await serviceOnline.postDataSetting(
          latitude: office['latitude'].toString(),
          longitude: office['longitude'].toString(),
          radius: office['radius'].toString(),
          smileDuration: smileDurationC.text,
          smilePercent: smilePercentC.text,
        );
      } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
        await serviceSetting.postDataSetting(
          latitude: office['latitude'].toString(),
          longitude: office['longitude'].toString(),
          radius: office['radius'].toString(),
          smileDuration: smileDurationC.text,
          smilePercent: smilePercentC.text,
        );
      }
      GlobalData.smileDuration = int.parse(smileDurationC.text);
      GlobalData.smilePercent = int.parse(smilePercentC.text);
      GlobalData.office = office;
      location = ubahLocation;
      Get.back();
      CustomToast.successToast("Success", "Setting Berhasil Diupdate");
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
