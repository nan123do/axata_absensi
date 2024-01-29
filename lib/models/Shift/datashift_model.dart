class DataShiftModel {
  late String id;
  late String nama;
  late String hari;
  late String jamMasuk;
  late String jamKeluar;

  DataShiftModel({
    required this.id,
    required this.nama,
    required this.hari,
    required this.jamMasuk,
    required this.jamKeluar,
  });

  DataShiftModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    nama = json['nama'];
    hari = json['hari'];
    jamMasuk = json['jammasuk'];
    jamKeluar = json['jamkeluar'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'hari': hari,
      'jamMasuk': jamMasuk,
      'jamKeluar': jamKeluar,
    };
  }
}
