import 'dart:convert';

import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/handle_exception.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:http/http.dart' as http;

class OnlineLoginService {
  Future<bool> login() async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/auth/login/",
      );

      var response = await http.post(
        url,
        body: {
          'username': GlobalData.username,
          'password': GlobalData.password,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body)['data'];

        if (data.isEmpty) {
          throw Exception('User tidak ditemukan');
        } else {
          Map<String, dynamic> user = data['user'];
          Map<String, dynamic> profile = data['user']['userprofile'];
          Map<String, dynamic> tenant = data['user']['userprofile']['tenant'];

          PegawaiData.tokenAuth = 'Token ${data['token']}';
          PegawaiData.nama = user['first_name'] ?? '';
          PegawaiData.kodepegawai = user['id'].toString();
          PegawaiData.idjenisuser = '';
          PegawaiData.aksesdashboard = false;
          PegawaiData.statusaktif = user['is_active'] ?? false;
          PegawaiData.tgllahir = profile['tgl_masuk'] == ''
              ? DateTime.now()
              : DateTime.parse(profile['tgl_masuk']);
          PegawaiData.alamat = profile['alamat'] ?? '';
          PegawaiData.telp = profile['telp'] ?? '';
          PegawaiData.norek = '';
          PegawaiData.namajabatan = profile['namajabatan'] ?? '';
          PegawaiData.menuakses = '';
          PegawaiData.isAdmin = profile['role'] == '1' ? true : false;

          // Setting Tenant
          GlobalData.namatoko = tenant['nama'] ?? GlobalData.namatoko;
          GlobalData.alamattoko = tenant['alamat'] ?? GlobalData.alamattoko;
          GlobalData.gajiPermenit = tenant['gaji_permenit'].toDouble() ?? 20;
          GlobalData.office = {
            'latitude': double.parse(tenant['latitude']),
            'longitude': double.parse(tenant['longitude']),
            'radius': tenant['radius'],
          };
          GlobalData.smileDuration = tenant['smile_duration'];
          GlobalData.smilePercent = tenant['smile_percent'];
          GlobalData.statusShift = tenant['status_shift'] == '1' ? true : false;
          GlobalData.idPenyewa = tenant['id'].toString();
          return true;
        }
      } else {
        throw jsonDecode(response.body)['data']['message'];
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }

  bool stringToBool(String value) {
    if (value.toString().toLowerCase() == 'false') {
      return false;
    } else {
      return true;
    }
  }
}
