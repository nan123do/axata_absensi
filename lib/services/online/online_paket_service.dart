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
}
