import 'dart:convert';

import 'package:axata_absensi/models/Absensi/dataabsen_model.dart';
import 'package:axata_absensi/models/Helper/pesan_model.dart';
import 'package:axata_absensi/models/Pegawai/datapegawai_model.dart';
import 'package:axata_absensi/utils/datehelper.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/handle_exception.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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
        List<DataAbsenModel> result = [];

        for (var item in data) {
          result.add(DataAbsenModel.fromJson(item));
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

  Future<String> simpanAbsenMasuk({
    required String keterangan,
    required String idShift,
    required String jamKerja,
    String tarif = '',
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
          'Tarif_': tarif != '' ? tarif : GlobalData.gajiPermenit.toString(),
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
      throw errorMessage;
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
      throw errorMessage;
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
        return DateHelper.convertStringToDateTime(pesan.keterangan);
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

  Future<String> simpanAbsensi({
    required String keterangan,
    required String idShift,
    required String jamKerja,
    required String masuk,
    required String keluar,
    String tarif = '',
    String kodePegawai = '',
  }) async {
    masuk = masuk.replaceAll('-', '/');
    keluar = keluar.replaceAll('-', '/');
    try {
      var url = Uri.http(
        GlobalData.globalWSApi + GlobalData.globalPort,
        "/api/product/simpan_absen",
      );

      var response = await http.post(
        url,
        body: {
          'appId': GlobalData.idcloud,
          'KodeCabang': 'PST',
          'JamMasuk': masuk,
          'JamKeluar': keluar,
          'KodePegawai':
              kodePegawai != '' ? kodePegawai : PegawaiData.kodepegawai,
          'Tarif_': tarif != '' ? tarif : GlobalData.gajiPermenit.toString(),
          'keterangan': keterangan,
          'status': '0',
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
      throw errorMessage;
    }
  }

  Future<String> ubahAbsensi({
    required String id,
    required String keterangan,
    required String idShift,
    required String jamKerja,
    required String masuk,
    required String keluar,
    String tarif = '',
    String kodePegawai = '',
  }) async {
    masuk = masuk.replaceAll('-', '/');
    keluar = keluar.replaceAll('-', '/');
    try {
      var url = Uri.http(
        GlobalData.globalWSApi + GlobalData.globalPort,
        "/api/product/ubah_absen",
      );

      var response = await http.post(
        url,
        body: {
          'appId': GlobalData.idcloud,
          'Id': id,
          'KodeCabang': 'PST',
          'JamMasuk': masuk,
          'JamKeluar': keluar,
          'KodePegawai':
              kodePegawai != '' ? kodePegawai : PegawaiData.kodepegawai,
          'Tarif_': tarif != '' ? tarif : GlobalData.gajiPermenit.toString(),
          'keterangan': keterangan,
          'status': '0',
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
      throw errorMessage;
    }
  }

  Future<String> hapusAbsensi({
    required String id,
    required String foto,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalWSApi + GlobalData.globalPort,
        "/api/product/hapus_absen",
      );

      var response = await http.post(
        url,
        body: {
          'appId': GlobalData.idcloud,
          'id': id,
          'foto': foto,
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
      throw errorMessage;
    }
  }

  Future<void> simpanGambar(XFile image) async {
    try {
      var uri = Uri.http(
        GlobalData.globalWSApi + GlobalData.globalPort,
        "/api/product/simpan_gambar",
        {'appId': GlobalData.idcloud},
      );

      var request = http.MultipartRequest('POST', uri)
        ..fields['kodepegawai'] = PegawaiData.kodepegawai
        ..files.add(
          await http.MultipartFile.fromPath(
            'imageFile',
            image.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );

      var response = await request.send();

      if (response.statusCode == 200) {
        // ignore: avoid_print
        print("Gambar berhasil disimpan.");
      } else {
        // ignore: avoid_print
        print(
            "Gagal menyimpan gambar dengan status code: ${response.statusCode}");
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }
}
