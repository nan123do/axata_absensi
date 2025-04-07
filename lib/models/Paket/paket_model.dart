class DataPaketModel {
  late String id;
  late String? keterangan;
  late String nama;
  late double harga;
  late int hari;
  late int jumlahPegawai;
  late bool statusAktif;
  late DateTime createdAt;
  late DateTime updatedAt;

  DataPaketModel({
    required this.id,
    this.keterangan,
    required this.nama,
    required this.harga,
    required this.hari,
    required this.jumlahPegawai,
    required this.statusAktif,
    required this.createdAt,
    required this.updatedAt,
  });

  DataPaketModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    keterangan = json['keterangan'] ?? '';
    nama = json['nama'];
    harga = double.parse(json['harga']);
    hari = json['hari'];
    jumlahPegawai = json['jumlah_pegawai'];
    statusAktif = json['statusaktif'] == 1 ? true : false;
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = json['updated_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['updated_at']);
  }

  DataPaketModel.fromOnlineJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    keterangan = json['keterangan'];
    nama = json['nama'];
    harga = double.parse(json['harga']);
    hari = json['hari'];
    jumlahPegawai = json['jumlah_pegawai'];
    statusAktif = json['statusaktif'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = json['updated_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'keterangan': keterangan,
      'nama': nama,
      'harga': harga,
      'hari': hari,
      'jumlah_pegawai': jumlahPegawai,
      'statusaktif': statusAktif,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
