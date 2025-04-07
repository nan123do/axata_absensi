import 'dart:convert';
import 'package:axata_absensi/models/Setting/cloud_setting_model.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/handle_exception.dart';
import 'package:http/http.dart' as http;

class CloudSettingService {
  Future<List<CloudSetting>> getDataCloudSetting({
    String? idcloud,
  }) async {
    try {
      var url = Uri.http(GlobalData.globalAPI, "/api/cloud_setting", {
        'idcloud': idcloud ?? GlobalData.idcloud,
      });
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];
        List<CloudSetting> result = [];

        for (var item in data) {
          result.add(CloudSetting.fromJson(item));
        }
        return result;
      } else {
        var status = response.statusCode;
        throw Exception('status: $status, Gagal menghubungi server');
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<void> updateCloudSetting({
    required String settingKey,
    required String settingValue,
  }) async {
    try {
      var url = Uri.http(GlobalData.globalAPI, "/api/cloud_setting/update");
      var response = await http.post(url, body: {
        'idcloud': GlobalData.idcloud,
        'setting_key': settingKey,
        'setting_value': settingValue,
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
