import 'package:axata_absensi/utils/datehelper.dart';

class DataPegawaiModel {
  late String kode;
  late String username;
  late String email;
  late String nama;
  late DateTime tglLahir;
  late DateTime tglMasuk;
  late double gajiPokok;
  late String jenisKelamin;
  late String alamat;
  late String telp;
  late String jabatan;
  late String keterangan;

  DataPegawaiModel({
    required this.kode,
    required this.username,
    required this.email,
    required this.nama,
    required this.tglLahir,
    required this.tglMasuk,
    required this.gajiPokok,
    required this.jenisKelamin,
    required this.alamat,
    required this.telp,
    required this.jabatan,
    required this.keterangan,
  });

  DataPegawaiModel.fromJson(Map<String, dynamic> json) {
    kode = json['kode'].toString();
    nama = json['nama'];
    tglLahir = DateTime.parse(json['tglLahir'].toString());
    gajiPokok = json['gajiPokok'] ?? 0;
    jenisKelamin = json['jenisKelamin'];
    alamat = json['alamat'];
    telp = json['telp'];
    jabatan = json['jabatan'];
    keterangan = json['keterangan'];
  }

  DataPegawaiModel.fromOnlineJson(Map<String, dynamic> json) {
    Map<String, dynamic> userprofile = json['userprofile'];

    kode = json['id'].toString();
    username = json['username'];
    email = json['email'];
    nama = json['first_name'];
    tglLahir = DateTime.parse(json['date_joined'].toString());
    tglMasuk =
        DateHelper.convertStringToDateTime(userprofile['tgl_masuk'].toString());
    gajiPokok = 0;
    jenisKelamin = '';
    alamat = userprofile['alamat'] ?? '';
    telp = userprofile['telp'] ?? '';
    jabatan = userprofile['jabatan'] ?? '';
    keterangan = '';
  }

  Map<String, dynamic> toJson() {
    return {
      'kode': kode,
      'username': username,
      'email': email,
      'nama': nama,
      'tglLahir': tglLahir,
      'tglMasuk': tglMasuk,
      'gajiPokok': gajiPokok,
      'jenisKelamin': jenisKelamin,
      'alamat': alamat,
      'telp': telp,
      'jabatan': jabatan,
      'keterangan': keterangan,
    };
  }
}
