class SettingModel {
  late String id;
  late String nama;
  late String nilai;
  late String keterangan;

  SettingModel({
    required this.id,
    required this.nama,
    required this.nilai,
    required this.keterangan,
  });

  SettingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    nama = json['nama'] ?? "";
    nilai = json['nilai'] ?? "";
    keterangan = json['keterangan'] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'nilai': nilai,
      'keterangan': keterangan,
    };
  }
}
