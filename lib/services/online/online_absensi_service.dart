import 'dart:convert';

import 'package:axata_absensi/models/Absensi/dataabsen_model.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/handle_exception.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class OnlineAbsensiService {
  Future<PaginatedAbsensi> getDataAbsensi({
    required String namaPegawai,
    required String dateFrom,
    required String dateTo,
    String nameSorting = '',
    String sort = 'Ascending',
    int page = 1,
  }) async {
    String namaFilter = namaPegawai.toLowerCase() == 'semua' ? '' : namaPegawai;

    try {
      var url = Uri.http(
          GlobalData.globalAPI + GlobalData.globalPort, "/api/absensi/", {
        'first_name': namaFilter,
        'tglAwal': dateFrom,
        'tglAkhir': dateTo,
        'page_size': '20',
        'page': page.toString(),
      });
      var response = await http.get(
        url,
        headers: {
          'Authorization': PegawaiData.tokenAuth,
          // Token port 8080
          // 'Authorization': 'Token b343a03f708af0b658e6f547a19efb4d8b4879da',
        },
      );

      if (response.statusCode == 200) {
        // List data = jsonDecode(response.body)['data']['results'];
        return PaginatedAbsensi.fromOnlineJson(
          jsonDecode(response.body)['data'],
        );
        // List<PaginatedAbsensi> result = [];

        // for (var item in data) {
        //   result.add(PaginatedAbsensi.fromOnlineJson(item));
        // }
        // return result;
      } else {
        throw jsonDecode(response.body)['data']['message'];
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
    String iduser = '',
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/absensi/admin/",
      );

      var response = await http.post(
        url,
        body: {
          'iduser': iduser,
          'tarif': tarif != '' ? tarif : GlobalData.gajiPermenit.toString(),
          'idshift': idShift,
          'jamkerja': jamKerja,
          'keterangan': keterangan,
          'jammasuk': masuk,
          'jamkeluar': keluar,
        },
        headers: {
          'Authorization': PegawaiData.tokenAuth,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body)['meta'];
        return data['message'];
      } else {
        throw jsonDecode(response.body)['data']['message'];
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
    String iduser = '',
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/absensi/admin/",
      );

      var response = await http.put(
        url,
        body: {
          'idabsensi': id,
          'iduser': iduser,
          'tarif': tarif != '' ? tarif : GlobalData.gajiPermenit.toString(),
          'idshift': idShift,
          'jamkerja': jamKerja,
          'keterangan': keterangan,
          'jammasuk': masuk,
          'jamkeluar': keluar,
        },
        headers: {
          'Authorization': PegawaiData.tokenAuth,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body)['meta'];
        return data['message'];
      } else {
        throw jsonDecode(response.body)['data']['message'];
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }

  Future<String> hapusAbsensi({
    required String id,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/absensi/admin/",
      );

      var response = await http.delete(
        url,
        body: {
          'id': id,
        },
        headers: {
          'Authorization': PegawaiData.tokenAuth,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['meta']['status'] == "success") {
          return data['meta']['message'];
        } else {
          throw Exception(data['data']['message']);
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
    var url = Uri.http(GlobalData.globalAPI + GlobalData.globalPort,
        "/api/absensi/cek_absen_masuk/", {
      'id_user': PegawaiData.kodepegawai,
    });
    var response = await http.get(
      url,
      headers: {
        'Authorization': PegawaiData.tokenAuth,
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['meta']['status'] == "success") {
        return DateTime.parse(data['data']);
      } else {
        throw Exception(data['data']['message']);
      }
    } else {
      var status = response.statusCode;
      throw Exception('status: $status, Gagal menghubungi server');
    }
  }

  Future<String> cekIDAbsensi() async {
    var url = Uri.http(GlobalData.globalAPI + GlobalData.globalPort,
        "/api/absensi/cek_id_absensi/", {
      'id_user': PegawaiData.kodepegawai,
    });
    var response = await http.get(
      url,
      headers: {
        'Authorization': PegawaiData.tokenAuth,
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['meta']['status'] == "success") {
        return data['data'];
      } else {
        throw Exception(data['data']['message']);
      }
    } else {
      var status = response.statusCode;
      throw Exception('status: $status, Gagal menghubungi server');
    }
  }

  Future<String> simpanAbsenMasuk({
    required String keterangan,
    required String idShift,
    required String jamKerja,
    required XFile? file,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/absensi/",
      );

      var request = http.MultipartRequest('POST', url);
      // Menambahkan field dalam body
      request.fields['iduser'] = PegawaiData.kodepegawai;
      request.fields['tarif'] = GlobalData.gajiPermenit.toString();
      request.fields['idshift'] = idShift;
      request.fields['jamkerja'] = jamKerja;
      request.fields['keterangan'] = keterangan;

      // Menambahkan file jika ada
      if (file != null) {
        // Konversi XFile ke File
        var stream = http.ByteStream(Stream.castFrom(file.openRead()));
        var length = await file.length();
        var multipartFile = http.MultipartFile(
          'foto',
          stream,
          length,
          filename: file.name,
        );
        request.files.add(multipartFile);
      }

      // Menambahkan header authorization
      request.headers['Authorization'] = PegawaiData.tokenAuth;

      // Kirim request
      var response = await request.send();

      // Tangkap response dan decode hasilnya
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(responseData.body)['meta'];
        return data['message'];
      } else {
        throw jsonDecode(responseData.body)['data']['message'];
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
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/absensi/",
      );

      var response = await http.put(
        url,
        body: {
          'idabsensi': id,
          'iduser': PegawaiData.kodepegawai,
        },
        headers: {
          'Authorization': PegawaiData.tokenAuth,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body)['meta'];
        return data['message'];
      } else {
        throw jsonDecode(response.body)['data']['message'];
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }
}
