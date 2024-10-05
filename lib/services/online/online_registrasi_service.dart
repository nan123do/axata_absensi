import 'dart:convert';

import 'package:axata_absensi/models/Registrasi/registrasi_model.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/handle_exception.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class OnlineRegistrasiService {
  Future<List<DataRegistrasiModel>> getDataRegistrasi({
    status = '',
    idTenant = '',
  }) async {
    try {
      var url = Uri.http(
          GlobalData.globalAPI + GlobalData.globalPort, "/api/registrasi/", {
        'status': status,
        'id_tenant': idTenant,
      });
      var response = await http.get(
        url,
        headers: {
          'Authorization': PegawaiData.tokenAuth,
        },
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];
        List<DataRegistrasiModel> result = [];

        for (var item in data) {
          result.add(DataRegistrasiModel.fromOnlineJson(item));
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

  Future<String> simpanRegistrasi({
    required String idpaket,
    required String idtenant,
    required String jumlahPegawai,
    required String totalHarga,
    required XFile? file,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/registrasi/",
      );

      var request = http.MultipartRequest('POST', url);
      // Menambahkan field dalam body
      request.fields['idpaket'] = idpaket;
      request.fields['idtenant'] = idtenant;
      request.fields['jumlah_pegawai'] = jumlahPegawai;
      request.fields['total_harga '] = totalHarga;

      // Menambahkan file jika ada
      if (file != null) {
        // Konversi XFile ke File
        var stream = http.ByteStream(Stream.castFrom(file.openRead()));
        var length = await file.length();
        var multipartFile = http.MultipartFile(
          'bukti',
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

  Future<String> konfirmasiRegistrasi({
    required String idRegistrasi,
    required String status,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/registrasi/konfirmasi/",
      );

      var response = await http.post(
        url,
        body: {
          'id_registrasi': idRegistrasi,
          'status': status,
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
}
