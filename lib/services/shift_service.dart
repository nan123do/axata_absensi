import 'dart:convert';

import 'package:axata_absensi/models/Helper/pesan_model.dart';
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
      throw errorMessage;
    }
  }

  Future<String> simpanTambahShift({
    required String nama,
    required List<DataShiftModel> data,
  }) async {
    String detailShift = "";
    for (var item in data) {
      String hari = item.hari.padRight(10);
      String jamMasuk = item.jamMasuk.padRight(10);
      String jamKeluar = item.jamKeluar.padRight(10);
      String statusAktif = item.statusAktif ? '1' : '0';

      detailShift += hari + jamMasuk + jamKeluar + statusAktif.padRight(10);
    }

    try {
      var url = Uri.http(
        GlobalData.globalWSApi + GlobalData.globalPort,
        "/api/product/simpan_shift",
      );

      var response = await http.post(
        url,
        body: {
          'appId': GlobalData.idcloud,
          'nama': nama,
          'detailshift': detailShift,
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

  Future<String> simpanUbahShift({
    required String id,
    required String nama,
    required List<DataShiftModel> data,
  }) async {
    String detailShift = "";
    for (var item in data) {
      String idDetail = item.idDetail.padRight(10);
      String hari = item.hari.padRight(10);
      String jamMasuk = item.jamMasuk.padRight(10);
      String jamKeluar = item.jamKeluar.padRight(10);
      String statusAktif = item.statusAktif ? '1' : '0';

      detailShift +=
          idDetail + hari + jamMasuk + jamKeluar + statusAktif.padRight(10);
    }

    try {
      var url = Uri.http(
        GlobalData.globalWSApi + GlobalData.globalPort,
        "/api/product/ubah_shift",
      );

      var response = await http.post(
        url,
        body: {
          'appId': GlobalData.idcloud,
          'id': id,
          'nama': nama,
          'detailshift': detailShift,
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

  Future<String> simpanHapusShift({
    required String id,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalWSApi + GlobalData.globalPort,
        "/api/product/hapus_shift",
      );

      var response = await http.post(
        url,
        body: {
          'appId': GlobalData.idcloud,
          'id': id,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        PesanModel pesan = PesanModel.fromJson(data);
        if (pesan.status == "success") {
          return pesan.keterangan;
        } else {
          if (pesan.keterangan
              .contains('Foreign key references are present for the record')) {
            throw 'Shift sudah pernah dipakai untuk transaksi';
          } else {
            throw Exception(pesan.keterangan);
          }
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

  Future<String> simpanStatusShift({
    required String id,
    required String status,
  }) async {
    try {
      var url = Uri.http(GlobalData.globalWSApi + GlobalData.globalPort,
          "/api/product/simpan_statusshift", {
        'appId': GlobalData.idcloud,
        'id': id,
        'StatusAktif': status,
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
        throw Exception('Gagal menghubungi server');
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }
}
