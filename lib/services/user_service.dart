import 'dart:convert';

import 'package:axata_absensi/models/Helper/pesan_model.dart';
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

  Future<String> ubahStatusNonaktifPegawai({
    required String kodePegawai,
    required bool status,
  }) async {
    var url = Uri.http(GlobalData.globalWSApi + GlobalData.globalPort,
        "/api/product/simpan_ubahnonaktif_pegawai", {
      'appId': GlobalData.idcloud,
      'kode': kodePegawai,
      'status': status ? '1' : '0',
    });
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      PesanModel pesan = PesanModel.fromJson(data);
      if (pesan.status == "success") {
        return pesan.keterangan;
      } else {
        throw Exception(pesan.keterangan);
      }
    } else {
      var status = response.statusCode;
      throw Exception('status: $status, Gagal menghubungi server');
    }
  }
}
