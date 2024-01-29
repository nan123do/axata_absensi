import 'dart:convert';

import 'package:axata_absensi/models/Absensi/dataabsen_model.dart';
import 'package:axata_absensi/models/Helper/pesan_model.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/handle_exception.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:http/http.dart' as http;

class AbsensiService {
  Future<List<DataAbsenModel>> getDataAbsensi({
    required String namaPegawai,
    required String dateFrom,
    required String dateTo,
    String nameSorting = '',
    String sort = 'Ascending',
  }) async {
    dateFrom = dateFrom.replaceAll('-', '/');
    dateTo = dateTo.replaceAll('-', '/');

    try {
      var url = Uri.http(GlobalData.globalWSApi + GlobalData.globalPort,
          "/api/product/get_absensi_all", {
        'appId': GlobalData.idcloud,
        'NamaPegawai': namaPegawai,
        'TglAwal': dateFrom,
        'TglAkhir': dateTo,
        'NameSorting': nameSorting,
        'sort': sort,
        'mode': 'mobile',
      });
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['result'];
        List<DataAbsenModel> barang = [];

        for (var item in data) {
          barang.add(DataAbsenModel.fromJson(item));
        }
        return barang;
      } else {
        throw Exception('Gagal menghubungi komputer servis!');
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<String> simpanAbsenMasuk({
    required String keterangan,
    required String idShift,
    required String jamKerja,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalWSApi + GlobalData.globalPort,
        "/api/product/simpan_absenmasuk",
      );

      var response = await http.post(
        url,
        body: {
          'appId': GlobalData.idcloud,
          'KodeCabang': 'PST',
          'KodePegawai': PegawaiData.kodepegawai,
          'Tarif_': GlobalData.gajiPermenit.toString(),
          'keterangan': keterangan,
          'JamKerja': jamKerja,
          'IdShift': idShift,
        },
      );

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
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<String> simpanAbsenKeluar({
    required String id,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalWSApi + GlobalData.globalPort,
        "/api/product/simpan_absenkeluar",
      );

      var response = await http.post(
        url,
        body: {
          'appId': GlobalData.idcloud,
          'ID': id,
          'KodePegawai': PegawaiData.kodepegawai,
          'Status': '0',
        },
      );

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
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<DateTime> cekAbsenMasuk() async {
    var url = Uri.http(GlobalData.globalWSApi + GlobalData.globalPort,
        "/api/product/cek_absen_masuk", {
      'appId': GlobalData.idcloud,
      'KodePegawai': PegawaiData.kodepegawai,
    });
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      PesanModel pesan = PesanModel.fromJson(data);
      if (pesan.status == "Berhasil") {
        return DateTime.parse(pesan.keterangan);
      } else {
        throw Exception(pesan.keterangan);
      }
    } else {
      var status = response.statusCode;
      throw Exception('status: $status, Gagal menghubungi server');
    }
  }

  Future<String> cekIDAbsensi() async {
    var url = Uri.http(GlobalData.globalWSApi + GlobalData.globalPort,
        "/api/product/cek_id_absensi", {
      'appId': GlobalData.idcloud,
      'KodePegawai': PegawaiData.kodepegawai,
    });
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      PesanModel pesan = PesanModel.fromJson(data);
      if (pesan.status == "Berhasil") {
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
