import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/components/loading_screen.dart';
import 'package:axata_absensi/models/Paket/paket_model.dart';
import 'package:axata_absensi/models/Pegawai/datapegawai_model.dart';
import 'package:axata_absensi/models/Registrasi/registrasi_model.dart';
import 'package:axata_absensi/pages/checkin/controllers/checkin_controller.dart';
import 'package:axata_absensi/pages/setting/views/paket_pembayaran.dart';
import 'package:axata_absensi/pages/setting/views/pembayaran_view.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/services/online/online_paket_service.dart';
import 'package:axata_absensi/services/online/online_registrasi_service.dart';
import 'package:axata_absensi/services/online/online_setting_service.dart';
import 'package:axata_absensi/services/online/online_user_service.dart';
import 'package:axata_absensi/services/setting_service.dart';
import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class SettingController extends GetxController {
  final checkInController = Get.put(CheckInController());
  TextEditingController radiusC = TextEditingController(text: '');
  TextEditingController latLongC = TextEditingController(text: '');
  TextEditingController smilePercentC = TextEditingController(text: '');
  TextEditingController smileDurationC = TextEditingController(text: '');
  RxBool isLoading = false.obs;
  RxBool isFirst = true.obs;
  RxBool isPending = true.obs;
  RxString location = ''.obs;
  RxString ubahLocation = ''.obs;

  late Position currentPosition;
  late GoogleMapController mapController;
  RxMap<String, dynamic> office = <String, dynamic>{}.obs;
  SettingService serviceSetting = SettingService();

  List<DataPegawaiModel> listPegawai = [];
  List<DataPaketModel> listPaket = [];
  List<DataRegistrasiModel> listRegistrasi = [];
  XFile? selectedImage;

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

      // Get Count User & Data Registrasi
      await handleGetUser();
      await handleGetRegistrasi();
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  handleGetUser() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineUserService serviceOnline = OnlineUserService();
      listPegawai = await serviceOnline.getDataPegawai();
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }

  handleGetRegistrasi() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineRegistrasiService serviceOnline = OnlineRegistrasiService();
      listRegistrasi = await serviceOnline.getDataRegistrasi(
        idTenant: GlobalData.idPenyewa,
        status: '2',
      );

      // Cek Pending Atau Tidak
      if (listRegistrasi.isEmpty) {
        isPending.value = false;
      }
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
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

  handleDataPaket() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlinePaketService serviceOnline = OnlinePaketService();
      listPaket = await serviceOnline.getDataPaket();
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }

  goPaketLangganan() async {
    LoadingScreen.show();
    try {
      await handleDataPaket();
      LoadingScreen.hide();
    } catch (e) {
      LoadingScreen.hide();
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }

    Get.to(
      () => PaketPembayaranView(controller: this),
    );
  }

  goPembayaranPage(DataPaketModel data) async {
    Get.to(
      () => PembayaranView(
        controller: this,
        paket: data,
      ),
    );
  }

  // Fungsi untuk memilih gambar dari kamera atau galeri
  Future<void> pickImage(ImageSource source) async {
    isLoading(true);
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        selectedImage = image;
        update();
      }
    } catch (e) {
      CustomToast.errorToast('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Fungsi untuk menampilkan pilihan kamera atau galeri
  void showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Ambil dari Kamera'),
                onTap: () {
                  Get.back();
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Unggah dari Galeri'),
                onTap: () {
                  Get.back();
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> handleKirimLangganan(DataPaketModel data) async {
    try {
      LoadingScreen.show();
      await handleApiKirimLangganan(data);
      LoadingScreen.hide();
      CustomToast.successToast(
        'Success',
        'Berhasil Mengirim Permintaan ke Admin',
      );
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      LoadingScreen.hide();
      CustomToast.errorToast('Error', '$e');
    }
  }

  handleApiKirimLangganan(DataPaketModel data) async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineRegistrasiService serviceOnline = OnlineRegistrasiService();
      await serviceOnline.simpanRegistrasi(
        idpaket: data.id.toString(),
        idtenant: GlobalData.idPenyewa,
        jumlahPegawai: data.jumlahPegawai.toString(),
        totalHarga: data.harga.toString(),
        file: selectedImage,
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }
}
