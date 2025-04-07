import 'dart:convert';

import 'package:axata_absensi/models/Paket/paket_model.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/handle_exception.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:http/http.dart' as http;

class OnlinePaketService {
  Future<List<DataPaketModel>> getDataPaket() async {
    try {
      var url = Uri.http(
          GlobalData.globalAPI + GlobalData.globalPort, "/api/paket/", {
        // 'name': '',
      });
      var response = await http.get(
        url,
        headers: {
          'Authorization': PegawaiData.tokenAuth,
        },
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];
        List<DataPaketModel> result = [];

        for (var item in data) {
          result.add(DataPaketModel.fromOnlineJson(item));
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

  Future<String> tambahPaket({
    required String nama,
    required String harga,
    required String hari,
    required String maxPegawai,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/paket/",
      );

      var response = await http.post(
        url,
        body: {
          "nama": nama,
          "harga": harga,
          "hari": hari,
          "jumlah_pegawai": maxPegawai,
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

  Future<String> ubahPaket({
    required String id,
    required String nama,
    required String harga,
    required String hari,
    required String maxPegawai,
    required bool statusAktif,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/paket/",
      );

      var response = await http.put(
        url,
        body: {
          "id": id,
          "nama": nama,
          "harga": harga,
          "hari": hari,
          "jumlah_pegawai": maxPegawai,
          "statusaktif": statusAktif.toString(),
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

  Future<String> setStatusAktifPaket({
    required String id,
    required bool statusAktif,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/paket/",
      );

      var response = await http.patch(
        url,
        body: {
          "id": id,
          "statusaktif": statusAktif == true ? 'True' : 'False',
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

  Future<String> hapusPaket({
    required String id,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/paket/",
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
