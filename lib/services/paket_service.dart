import 'dart:convert';
import 'package:axata_absensi/models/Paket/paket_model.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/handle_exception.dart';
import 'package:http/http.dart' as http;

class PaketService {
  Future<List<DataPaketModel>> getDataPaket({
    String? limit,
    String? nama,
  }) async {
    try {
      var url = Uri.http(GlobalData.globalAPI, "/api/aapaket", {
        'limit': limit ?? '',
        'nama': nama ?? '',
      });
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];
        List<DataPaketModel> result = [];

        for (var item in data) {
          result.add(DataPaketModel.fromJson(item));
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
}
