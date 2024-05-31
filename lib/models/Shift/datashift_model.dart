class DataShiftModel {
  late String id;
  late String idDetail;
  late String nama;
  late String hari;
  late String jamMasuk;
  late String jamKeluar;
  late bool statusAktif;

  DataShiftModel({
    required this.id,
    required this.idDetail,
    required this.nama,
    required this.hari,
    required this.jamMasuk,
    required this.jamKeluar,
    required this.statusAktif,
  });

  DataShiftModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    idDetail = json['id_detail'].toString();
    nama = json['nama'];
    hari = json['hari'];
    jamMasuk = json['jammasuk'];
    jamKeluar = json['jamkeluar'];
    statusAktif = json['statusaktif'] == "1" ? true : false;
  }

  DataShiftModel.fromOnlineJson(
    Map<String, dynamic> shift,
    Map<String, dynamic> detail,
  ) {
    id = shift['id'].toString();
    idDetail = detail['id'].toString();
    nama = shift['nama'];
    hari = detail['hari'];
    jamMasuk = detail['jam_masuk'];
    jamKeluar = detail['jam_keluar'];
    statusAktif = detail['status_aktif'] == 1 ? true : false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_detail': idDetail,
      'nama': nama,
      'hari': hari,
      'jammasuk': jamMasuk,
      'jamkeluar': jamKeluar,
      'statusaktif': statusAktif,
    };
  }
}
