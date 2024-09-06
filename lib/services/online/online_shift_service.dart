import 'dart:convert';

import 'package:axata_absensi/models/Shift/datashift_model.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/handle_exception.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:http/http.dart' as http;

class OnlineShiftService {
  Future<List<DataShiftModel>> getShift({
    required String hari,
    required String status,
  }) async {
    try {
      var url = Uri.http(
          GlobalData.globalAPI + GlobalData.globalPort, "/api/shift/", {
        'hari': hari,
        'status_aktif': status,
      });
      var response = await http.get(
        url,
        headers: {
          'Authorization': PegawaiData.tokenAuth,
        },
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];
        List<DataShiftModel> hasil = [];

        for (var shift in data) {
          for (var detailshift in shift['detail_shifts']) {
            hasil.add(DataShiftModel.fromOnlineJson(shift, detailshift));
          }
        }

        return hasil;
      } else {
        throw jsonDecode(response.body)['data']['message'];
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }

  Future<String> simpanTambahShift({
    required String nama,
    required List<DataShiftModel> data,
  }) async {
    String detailShift = "";
    for (var item in data) {
      String hari = item.hari.padRight(10);
      String jamMasuk = ('${item.jamMasuk}:00').padRight(10);
      String jamKeluar = ('${item.jamKeluar}:00').padRight(10);
      String statusAktif = item.statusAktif ? '1' : '0';

      detailShift += hari + jamMasuk + jamKeluar + statusAktif.padRight(10);
    }

    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/shift/",
      );

      var response = await http.post(
        url,
        body: {
          'nama': nama,
          'detailshift': detailShift,
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
        var status = response.statusCode;
        throw Exception('status: $status, Gagal menghubungi server');
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }

  Future<String> simpanUbahShift({
    required String id,
    required String nama,
    required List<DataShiftModel> data,
  }) async {
    String detailShift = "";
    for (var item in data) {
      String idDetail = item.idDetail.padRight(10);
      String hari = item.hari.padRight(10);
      String jamMasuk = item.jamMasuk.length > 5
          ? (item.jamMasuk).padRight(10)
          : ('${item.jamMasuk}:00').padRight(10);
      String jamKeluar = item.jamKeluar.length > 5
          ? (item.jamKeluar).padRight(10)
          : ('${item.jamKeluar}:00').padRight(10);
      String statusAktif = item.statusAktif ? '1' : '0';

      detailShift +=
          idDetail + hari + jamMasuk + jamKeluar + statusAktif.padRight(10);
    }

    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/shift/",
      );

      var response = await http.put(
        url,
        body: {
          'id': id,
          'nama': nama,
          'detailshift': detailShift,
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
        var status = response.statusCode;
        throw Exception('status: $status, Gagal menghubungi server');
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }

  Future<String> simpanStatusShift({
    required String id,
    required String status,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/shift/status/",
      );

      var response = await http.put(
        url,
        body: {
          'id': id,
          'statusaktif': status,
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
        var status = response.statusCode;
        throw Exception('status: $status, Gagal menghubungi server');
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }

  Future<String> simpanHapusShift({
    required String id,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/shift/",
      );

      var response = await http.delete(
        url,
        body: {
          'id': id,
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
        var status = response.statusCode;
        throw Exception('status: $status, Gagal menghubungi server');
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }
}
