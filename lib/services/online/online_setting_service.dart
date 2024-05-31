import 'dart:convert';

import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/handle_exception.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:http/http.dart' as http;

class OnlineSettingService {
  Future<void> getDataPegawai() async {
    try {
      var url = Uri.http(
          GlobalData.globalAPI + GlobalData.globalPort, "/api/tenant/", {
        'nama': '',
      });
      var response = await http.get(
        url,
        headers: {
          'Authorization': PegawaiData.tokenAuth,
        },
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];
        // ignore: avoid_print
        print(data);
      } else {
        throw jsonDecode(response.body)['data']['message'];
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }

  Future<String> postDataSetting({
    String latitude = "",
    String longitude = "",
    String radius = "",
    String smileDuration = "",
    String smilePercent = "",
    String statusShift = "",
    String id = "",
    String nama = "",
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/tenant/",
      );

      var response = await http.put(
        url,
        body: {
          'id': GlobalData.idPenyewa,
          'nama': nama,
          'latitude': latitude,
          'longitude': longitude,
          'radius': radius,
          'smile_duration': smileDuration,
          'smile_percent': smilePercent,
          'status_shift': statusShift,
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
