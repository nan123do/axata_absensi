import 'dart:convert';

import 'package:axata_absensi/models/Pegawai/datapegawai_model.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/handle_exception.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:http/http.dart' as http;

class OnlineUserService {
  Future<List<DataPegawaiModel>> getDataPegawai() async {
    try {
      var url = Uri.http(
          GlobalData.globalAPI + GlobalData.globalPort, "/api/auth/users/", {
        'role': '2',
        'id_tenant': GlobalData.idPenyewa,
      });
      var response = await http.get(
        url,
        headers: {
          'Authorization': PegawaiData.tokenAuth,
        },
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];
        List<DataPegawaiModel> result = [];

        for (var item in data) {
          result.add(DataPegawaiModel.fromOnlineJson(item));
        }
        return result;
      } else {
        throw jsonDecode(response.body)['data']['message'];
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }

  Future<String> tambahPegawai({
    required String username,
    required String nama,
    required String email,
    required String password,
    required String alamat,
    required String telp,
    required String tglMasuk,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/auth/register/",
      );

      var response = await http.post(
        url,
        body: json.encode({
          "username": username,
          "email": email,
          "password": password,
          "password2": password,
          "first_name": nama,
          "userprofile": {
            "tgl_masuk": tglMasuk,
            "role": "2",
            "jabatan": "Pegawai",
            "alamat": alamat,
            "telp": telp,
            "id_tenant": GlobalData.idPenyewa
          }
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': PegawaiData.tokenAuth,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['meta']['status'] == "success") {
          return data['meta']['message'];
        } else {
          throw Exception(data['data']['message']);
        }
      } else {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['meta']['message'] == "invalid") {
          throw Exception(data['data']['message']);
        } else {
          throw Exception(data['meta']['message']);
        }
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }

  Future<String> ubahPegawai({
    required String id,
    required String username,
    required String nama,
    required String email,
    required String alamat,
    required String telp,
    required String tglMasuk,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/auth/users/",
      );

      var response = await http.put(
        url,
        body: json.encode({
          "id": id,
          "username": username,
          "email": email,
          "first_name": nama,
          "userprofile": {
            "tgl_masuk": tglMasuk,
            "role": "2",
            "jabatan": "Pegawai",
            "alamat": alamat,
            "telp": telp,
            "id_tenant": GlobalData.idPenyewa
          }
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': PegawaiData.tokenAuth,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['meta']['status'] == "success") {
          return data['meta']['message'];
        } else {
          throw Exception(data['data']['message']);
        }
      } else {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['meta']['message'] == "invalid") {
          throw Exception(data['data']['message']);
        } else {
          throw Exception(data['meta']['message']);
        }
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }

  Future<String> hapusPegawai({
    required String id,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/auth/users/",
      );

      var response = await http.delete(
        url,
        body: {
          "id": id,
        },
        headers: {
          'Authorization': PegawaiData.tokenAuth,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['meta']['status'] == "success") {
          return data['meta']['message'];
        } else {
          throw Exception(data['data']['message']);
        }
      } else {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['meta']['message'] == "invalid") {
          throw Exception(data['data']['message']);
        } else {
          throw Exception(data['meta']['message']);
        }
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }

  Future<String> ubahPassword({
    required String id,
    required String oldpassword,
    required String newpassword,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/auth/password/",
      );

      var response = await http.post(
        url,
        body: {
          "id_user": id,
          "old_password": oldpassword,
          "new_password": newpassword,
        },
        headers: {
          'Authorization': PegawaiData.tokenAuth,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['meta']['status'] == "success") {
          return data['meta']['message'];
        } else {
          throw Exception(data['data']['message']);
        }
      } else {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['meta']['message'] == "invalid") {
          throw Exception(data['data']['message']);
        } else {
          throw Exception(data['meta']['message']);
        }
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }
}
