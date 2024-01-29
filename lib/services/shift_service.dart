import 'dart:convert';

import 'package:axata_absensi/models/Shift/datashift_model.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/handle_exception.dart';
import 'package:http/http.dart' as http;

class ShiftService {
  Future<List<DataShiftModel>> getShift({
    required String hari,
    required String status,
  }) async {
    try {
      var url = Uri.http(GlobalData.globalWSApi + GlobalData.globalPort,
          "/api/product/get_shift", {
        'appId': GlobalData.idcloud,
        'hari': hari,
        'StatusAktif': status,
      });
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['result'];
        List<DataShiftModel> hasil = [];

        for (var item in data) {
          hasil.add(DataShiftModel.fromJson(item));
        }
        return hasil;
      } else {
        throw Exception('Gagal menghubungi server');
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }
}
