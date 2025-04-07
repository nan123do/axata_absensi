import 'dart:convert';

import 'package:axata_absensi/components/custom_dialog.dart';
import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/components/loading_screen.dart';
import 'package:axata_absensi/utils/datehelper.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/handle_exception.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OnlineLoginService {
  Future<bool> login() async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/api/auth/login/",
      );

      var response = await http.post(
        url,
        body: {
          'username': GlobalData.username,
          'password': GlobalData.password,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body)['data'];

        if (data.isEmpty) {
          throw Exception('User tidak ditemukan');
        } else {
          Map<String, dynamic> user = data['user'];
          Map<String, dynamic> profile = {};
          Map<String, dynamic> tenant = {};

          if (data['user']['userprofile'] != null) {
            profile = data['user']['userprofile'];

            // Jika Pegawai Nonaktif Tidak Boleh Masuk
            if (profile['is_disabled'] == true) {
              throw Exception(
                'Akun tidak aktif, Silahkan hubungi admin perusahaan anda',
              );
            }

            PegawaiData.tgllahir = profile['tgl_masuk'] == ''
                ? DateTime.now()
                : DateTime.parse(profile['tgl_masuk']);
            PegawaiData.alamat = profile['alamat'] ?? '';
            PegawaiData.telp = profile['telp'] ?? '';
            PegawaiData.norek = '';
            PegawaiData.namajabatan = profile['jabatan'] ?? '';
            PegawaiData.menuakses = '';
            PegawaiData.isAdmin = profile['role'] == '1' ? true : false;

            if (data['user']['userprofile']['tenant'] != null) {
              tenant = data['user']['userprofile']['tenant'];
              // Setting Tenant
              GlobalData.namatoko = tenant['nama'] ?? GlobalData.namatoko;
              GlobalData.alamattoko = tenant['alamat'] ?? GlobalData.alamattoko;
              GlobalData.gajiPermenit =
                  tenant['gaji_permenit'].toDouble() ?? 20;
              GlobalData.smileDuration = tenant['smile_duration'];
              GlobalData.smilePercent = tenant['smile_percent'];
              GlobalData.statusShift =
                  tenant['status_shift'] == '1' ? true : false;
              GlobalData.idPenyewa = tenant['id'].toString();
              GlobalData.maxPegawai = tenant['max_pegawai'];
              GlobalData.expiredAt = tenant['expired_at'] != null
                  ? DateHelper.convertStringToDateTime(tenant['expired_at'])
                  : null;
            }
          }

          PegawaiData.tokenAuth = 'Token ${data['token']}';
          PegawaiData.nama = user['first_name'] ?? '';
          PegawaiData.kodepegawai = user['id'].toString();
          PegawaiData.idjenisuser = '';
          PegawaiData.aksesdashboard = false;
          PegawaiData.isSuperUser = user['is_superuser'] ?? false;
          PegawaiData.statusAktif = user['is_active'] ?? false;

          return true;
        }
      } else {
        if (jsonDecode(response.body)['meta']['message'] == 'inactive') {
          CustomAlertDialog.dialogTwoButton(
            title: "AKUN BELUM AKTIF",
            message:
                "Akun Anda belum aktif. Silakan cek di kotak masuk/spam email anda.",
            onContinue: () async {
              LoadingScreen.show();
              String email = jsonDecode(response.body)['data']['email'];

              bool hasil = await resendEmailActivation(
                email: email,
              );

              LoadingScreen.hide();
              if (hasil) {
                String blurredEmail = blurEmail(email);
                Get.back();
                CustomToast.successToast('Success',
                    'Berhasil mengirim ulang email verifikasi di $blurredEmail');
              }
            },
            onCancel: () {
              Get.back();
            },
          );
          return false;
        } else {
          throw jsonDecode(response.body)['data']['message'];
        }
      }
    } catch (e) {
      LoadingScreen.hide();
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }

  String blurEmail(String email) {
    // Pisahkan username dan domain
    final emailParts = email.split('@');
    final username = emailParts[0];
    final domain = emailParts[1];

    // Sisakan 1 huruf pertama dan 2 huruf terakhir dari username
    if (username.length <= 3) {
      return '${username[0]}***@$domain';
    }

    final firstLetter = username[0];
    final lastTwoLetters = username.substring(username.length - 2);
    final blurredEmail = '$firstLetter******$lastTwoLetters@$domain';

    return blurredEmail;
  }

  bool stringToBool(String value) {
    if (value.toString().toLowerCase() == 'false') {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> resendEmailActivation({required String email}) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/resend-token/",
      );

      var response = await http.post(
        url,
        body: {
          'email': email,
          'sendfrom': 'mobile',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw jsonDecode(response.body)['data']['message'];
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }

  Future<bool> resetPasswordEmail({required String email}) async {
    try {
      var url = Uri.http(
        GlobalData.globalAPI + GlobalData.globalPort,
        "/forgot-password/",
      );

      var response = await http.post(
        url,
        body: {
          'email': email,
          // 'sendfrom': 'mobile',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw jsonDecode(response.body)['meta']['message'];
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }
}
