import 'package:axata_absensi/utils/datehelper.dart';

class DataCloudModel {
  late String idcloud;
  late String socketid;
  late String namatoko;
  late String alamattoko;
  late String statusaktivasi;
  late String jumlahdevice;
  late int maxPegawai;
  late String tglawal;
  late String tglakhir;
  late DateTime? expiredAt;

  DataCloudModel({
    required this.idcloud,
    required this.socketid,
    required this.namatoko,
    required this.alamattoko,
    required this.statusaktivasi,
    required this.jumlahdevice,
    required this.maxPegawai,
    required this.tglawal,
    required this.tglakhir,
    required this.expiredAt,
  });

  DataCloudModel.fromJson(Map<String, dynamic> json) {
    idcloud = json['idcloud'].toString();
    socketid = json['socketid'];
    namatoko = json['namatoko'];
    alamattoko = json['alamattoko'];
    statusaktivasi = json['statusaktivasi'].toString();
    jumlahdevice = json['jumlahdevice'].toString();
    jumlahdevice = json['jumlahdevice'].toString();
    maxPegawai = json['max_pegawai'] ?? 0;
    tglawal = json['tglawal'].toString();
    tglakhir = json['tglakhir'].toString();
    tglakhir = json['tglakhir'].toString();
    expiredAt = json['expired_at'] == null
        ? null
        : DateHelper.convertStringToDateTime(json['expired_at'].toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'idcloud': idcloud,
      'socketid': socketid,
      'namatoko': namatoko,
      'alamattoko': alamattoko,
      'statusaktivasi': statusaktivasi,
      'jumlahdevice': jumlahdevice,
      'max_pegawai': maxPegawai,
      'tglAwal': tglawal,
      'tglakhir': tglakhir,
      'expired_at': expiredAt,
    };
  }
}
