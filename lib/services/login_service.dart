import 'dart:convert';

import 'package:axata_absensi/utils/datehelper.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/handle_exception.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:http/http.dart' as http;

class LoginService {
  Future<bool> login() async {
    try {
      var url = Uri.http(GlobalData.globalWSApi + GlobalData.globalPort,
          "/api/product/login_absensi", {
        'appId': GlobalData.idcloud,
        'username': GlobalData.username,
        'password': GlobalData.password,
      });
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['result'];

        if (data.isEmpty) {
          throw Exception('User tidak ditemukan');
        } else {
          PegawaiData.nama = data[0]['nama'] ?? '';
          PegawaiData.kodepegawai = data[0]['kodepegawai'] ?? '';
          PegawaiData.idjenisuser = data[0]['idjenisuser'] ?? '';
          PegawaiData.aksesdashboard = data[0]['aksesdashboard'] ?? false;
          PegawaiData.statusaktif = data[0]['statusaktif'] ?? false;
          PegawaiData.tgllahir = data[0]['tgllahir'] == ''
              ? DateTime.now()
              : DateHelper.convertStringToDateTime(data[0]['tgllahir']);
          PegawaiData.alamat = data[0]['alamat'] ?? '';
          PegawaiData.telp = data[0]['telp'] ?? '';
          PegawaiData.norek = data[0]['norek'] ?? '';
          PegawaiData.namajabatan = data[0]['namajabatan'] ?? '';
          PegawaiData.menuakses = data[0]['menuakses'] ?? '';
          if (PegawaiData.menuakses.contains("MenuDataAbsensi") &&
              PegawaiData.kodepegawai == '') {
            PegawaiData.isAdmin = true;
          } else {
            PegawaiData.isAdmin = false;
          }
          GlobalData.namatoko = data[0]['namatoko'] ?? GlobalData.namatoko;
          GlobalData.alamattoko =
              data[0]['alamattoko'] ?? GlobalData.alamattoko;
          return true;
        }
      } else {
        throw 'Gagal menghubungi server';
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
