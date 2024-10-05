class DataPaketModel {
  late int id;
  late String? keterangan;
  late String nama;
  late double harga;
  late int hari;
  late int jumlahPegawai;
  late DateTime createdAt;
  late DateTime updatedAt;

  DataPaketModel({
    required this.id,
    this.keterangan,
    required this.nama,
    required this.harga,
    required this.hari,
    required this.jumlahPegawai,
    required this.createdAt,
    required this.updatedAt,
  });

  DataPaketModel.fromOnlineJson(Map<String, dynamic> json) {
    id = json['id'];
    keterangan = json['keterangan'];
    nama = json['nama'];
    harga = double.parse(json['harga']);
    hari = json['hari'];
    jumlahPegawai = json['jumlah_pegawai'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'keterangan': keterangan,
      'nama': nama,
      'harga': harga,
      'hari': hari,
      'jumlah_pegawai': jumlahPegawai,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
