import 'dart:convert';

import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/handle_exception.dart';
import 'package:http/http.dart' as http;

class SettingService {
  Future<void> getDataSetting() async {
    try {
      var url = Uri.http(GlobalData.globalAPI, "/api/absensi", {
        'idcloud': GlobalData.idcloud,
      });
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data']['data'];
        if (data.isNotEmpty) {
          GlobalData.office = {
            'latitude': double.parse(data[0]['latitude']),
            'longitude': double.parse(data[0]['longitude']),
            'radius': data[0]['radius'],
          };
          GlobalData.smileDuration = data[0]['smile_duration'];
          GlobalData.smilePercent = data[0]['smile_percent'];
        }
      } else {
        var status = response.statusCode;
        throw Exception('status: $status, Gagal menghubungi server');
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<void> postDataSetting({
    required String latitude,
    required String longitude,
    required String radius,
    required String smileDuration,
    required String smilePercent,
  }) async {
    try {
      var url = Uri.http(GlobalData.globalAPI, "/api/absensi/update");
      var response = await http.post(url, body: {
        'idcloud': GlobalData.idcloud,
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
        'smile_duration': smileDuration,
        'smile_percent': smilePercent,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['meta'];
        return data['message'];
      } else if (response.statusCode == 500) {
        throw Exception(jsonDecode(response.body)['data']['message']);
      } else {
        var status = response.statusCode;
        throw Exception('status: $status, Gagal menghubungi server');
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }
}
