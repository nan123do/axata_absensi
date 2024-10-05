import 'dart:convert';

import 'package:axata_absensi/models/lokasi/lokasi_model.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/handle_exception.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:http/http.dart' as http;

class OnlineLokasiService {
  Future<List<DataLokasiModel>> getDatalokasi() async {
    try {
      var url = Uri.http(
          GlobalData.globalAPI + GlobalData.globalPort, "/api/lokasi/", {
        'id': '',
        'nama': '',
        'alamat': '',
      });
      var response = await http.get(
        url,
        headers: {
          'Authorization': PegawaiData.tokenAuth,
        },
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];
        List<DataLokasiModel> result = [];

        for (var item in data) {
          result.add(DataLokasiModel.fromOnlineJson(item));
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

  Future<String> tambahLokasi({
    required String nama,
    required String alamat,
    required String longitude,
    required String latitude,
    required String radius,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/lokasi/",
      );

      var response = await http.post(
        url,
        body: {
          "nama": nama,
          "alamat": alamat,
          "longitude": longitude,
          "latitude": latitude,
          "radius": radius,
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
        throw data['meta']['message'];
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }

  Future<String> ubahLokasi({
    required String id,
    required String nama,
    required String alamat,
    required String longitude,
    required String latitude,
    required String radius,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/lokasi/",
      );

      var response = await http.put(
        url,
        body: {
          "id": id,
          "nama": nama,
          "alamat": alamat,
          "longitude": longitude,
          "latitude": latitude,
          "radius": radius,
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
        throw Exception(data['data']['message']);
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }

  Future<String> hapuslokasi({
    required String id,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/lokasi/",
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
        throw data['meta']['message'];
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }
}
