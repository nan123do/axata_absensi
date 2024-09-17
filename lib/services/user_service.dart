import 'dart:convert';

import 'package:axata_absensi/models/Pegawai/datapegawai_model.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/handle_exception.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<List<DataPegawaiModel>> getDataPegawai({
    required String namaPegawai,
    String alamat = '',
    String kota = '',
    String nameSorting = '',
    String sort = 'Ascending',
  }) async {
    try {
      var url = Uri.http(GlobalData.globalWSApi + GlobalData.globalPort,
          "/api/product/get_pegawai_all", {
        'appId': GlobalData.idcloud,
        'CariNamaOrKode': namaPegawai,
        'Alamat': alamat,
        'Kota': kota,
        'StatusNonAktif': 'false',
        'NameSorting': nameSorting,
        'sort': sort,
      });
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['result'];
        List<DataPegawaiModel> result = [];

        for (var item in data) {
          result.add(DataPegawaiModel.fromJson(item));
        }
        return result;
      } else {
        throw Exception('Gagal menghubungi komputer servis!');
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }
}
