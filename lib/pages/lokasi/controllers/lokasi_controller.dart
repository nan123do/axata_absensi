import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/components/loading_screen.dart';
import 'package:axata_absensi/models/lokasi/lokasi_model.dart';
import 'package:axata_absensi/pages/checkin/controllers/checkin_controller.dart';
import 'package:axata_absensi/pages/lokasi/views/save_lokasi.dart';
import 'package:axata_absensi/services/online/online_lokasi_service.dart';
import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/maintenance_helper.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LokasiController extends GetxController {
  final checkInController = Get.put(CheckInController());
  TextEditingController namaC = TextEditingController(text: '');
  TextEditingController radiusC = TextEditingController(text: '');
  TextEditingController latLongC = TextEditingController(text: '');

  RxBool isLoading = false.obs;

  List<DataLokasiModel> listLokasi = [];
  RxString location = ''.obs;

  late Position currentPosition;
  late GoogleMapController mapController;
  RxMap<String, dynamic> office = <String, dynamic>{}.obs;
  RxString id = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getInit();
  }

  getInit() async {
    isLoading.value = true;
    try {
      await MaintenanceHelper.getMaintenance();
      await handleDataLokasi();
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  handleDataLokasi() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineLokasiService serviceOnline = OnlineLokasiService();
      listLokasi = await serviceOnline.getDatalokasi();
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }

  void goDialog(DataLokasiModel data) {
    Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.symmetric(vertical: 25.h),
      titleStyle: const TextStyle(fontSize: 0),
      content: Column(
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
              goUbahPage(data);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'Ubah',
                style: AxataTheme.threeSmall,
              ),
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () async {
              await goHapusPage(data);
              // goUbahPasswordPage(data);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'Hapus',
                style: AxataTheme.threeSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  goAddPage() {
    isLoading.value = true;
    try {
      office.value = Map<String, dynamic>.from(GlobalData.office);
      location.value = 'Jl. Kenari No.37, Plosokerep, Kecamatan Sananwetan';
      namaC.text = '';
      radiusC.text = office['radius'].round().toString();
      latLongC.text = '${office['latitude']},${office['longitude']}';
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }

    Get.to(
      () => SaveLokasi(
        controller: this,
        isAdd: true,
      ),
      transition: Transition.rightToLeftWithFade,
    );
  }

  goUbahPage(DataLokasiModel data) {
    isLoading.value = true;
    try {
      office.value = {
        'latitude': double.parse(data.latitude),
        'longitude': double.parse(data.longitude),
        'radius': double.parse(data.radius),
      };

      id.value = data.id;
      location.value = data.alamat;
      namaC.text = data.nama;
      radiusC.text = office['radius'].round().toString();
      latLongC.text = '${office['latitude']},${office['longitude']}';
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }

    Get.to(
      () => SaveLokasi(
        controller: this,
        isAdd: false,
      ),
      transition: Transition.rightToLeftWithFade,
    );
  }

  goHapusPage(DataLokasiModel data) async {
    try {
      id.value = data.id;
      await handleHapusLokasi();
      Get.back();
      CustomToast.successToast('Success', 'Berhasil Menghapus Lokasi');
      getInit();
    } catch (e) {
      CustomToast.errorToast('Error', '$e');
    }
  }

  handleHapusLokasi() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineLokasiService serviceOnline = OnlineLokasiService();
      await serviceOnline.hapuslokasi(
        id: id.value,
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }

  Polygon createRadiusPolygon(LatLng center, double radiusInMeters) {
    return checkInController.createRadiusPolygon(center, radiusInMeters);
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
    location.value = address;

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
        location.value = address;

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

  updateRadius(String value) {
    if (value != '') {
      office['radius'] = double.parse(value);
    }
  }

  errorSaveMesssage(String title) {
    LoadingScreen.hide();
    CustomToast.errorToast("Error", title);
  }

  Future<void> handleSimpan(bool isAdd) async {
    LoadingScreen.show();
    if (namaC.text == '') {
      errorSaveMesssage('Username harus diisi.');
      return;
    }

    try {
      if (isAdd) {
        await handleTambahLokasi();
        LoadingScreen.hide();
        Get.back();
        CustomToast.successToast('Success', 'Berhasil Menambah Lokasi');
      } else {
        await handleUbahLokasi();
        LoadingScreen.hide();
        Get.back();
        CustomToast.successToast('Success', 'Berhasil Mengubah Lokasi');
      }

      await getInit();
    } catch (e) {
      LoadingScreen.hide();
      CustomToast.errorToast("Error", e.toString());
    } finally {}
  }

  handleTambahLokasi() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineLokasiService serviceOnline = OnlineLokasiService();
      await serviceOnline.tambahLokasi(
        nama: namaC.text,
        alamat: location.value,
        longitude: office['longitude'].toString(),
        latitude: office['latitude'].toString(),
        radius: office['radius'].toString(),
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }

  handleUbahLokasi() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineLokasiService serviceOnline = OnlineLokasiService();
      await serviceOnline.ubahLokasi(
        id: id.value,
        nama: namaC.text,
        alamat: location.value,
        longitude: office['longitude'].toString(),
        latitude: office['latitude'].toString(),
        radius: office['radius'].toString(),
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }
}
