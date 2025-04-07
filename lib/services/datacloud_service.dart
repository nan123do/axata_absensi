import 'dart:convert';
import 'package:axata_absensi/models/DataCloud/datacloud_model.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/handle_exception.dart';
import 'package:http/http.dart' as http;

class DataCloudService {
  Future<DataCloudModel> getDataCloud({
    String limit = '1',
    String? idcloud,
  }) async {
    try {
      var url = Uri.http(GlobalData.globalAPI, "/api/datacloud", {
        'limit': limit,
        'idcloud': idcloud ?? GlobalData.idcloud,
      });
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = DataCloudModel.fromJson(jsonDecode(response.body)['data']);
        return data;
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
