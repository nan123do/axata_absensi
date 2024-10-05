class Tenant {
  late int id;
  late String nama;
  late String alamat;
  late int smileDuration;
  late int smilePercent;
  late int gajiPermenit;
  late String statusShift;
  late DateTime createdAt;
  late DateTime updatedAt;

  Tenant({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.smileDuration,
    required this.smilePercent,
    required this.gajiPermenit,
    required this.statusShift,
    required this.createdAt,
    required this.updatedAt,
  });

  Tenant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    alamat = json['alamat'];
    smileDuration = json['smile_duration'];
    smilePercent = json['smile_percent'];
    gajiPermenit = json['gaji_permenit'];
    statusShift = json['status_shift'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'smile_duration': smileDuration,
      'smile_percent': smilePercent,
      'gaji_permenit': gajiPermenit,
      'status_shift': statusShift,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Paket {
  late int id;
  late String? keterangan;
  late String nama;
  late double harga;
  late int hari;
  late int jumlahPegawai;
  late bool statusAktif;
  late DateTime createdAt;
  late DateTime updatedAt;

  Paket({
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

  Paket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    keterangan = json['keterangan'];
    nama = json['nama'];
    harga = double.parse(json['harga']);
    hari = json['hari'];
    jumlahPegawai = json['jumlah_pegawai'];
    statusAktif = json['statusaktif'];
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
      'statusaktif': statusAktif,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class DataRegistrasiModel {
  late int id;
  late Tenant tenant;
  late Paket paket;
  late int idPaket;
  late int idTenant;
  late int jumlahPegawai;
  late double totalHarga;
  late String? bukti;
  late String status;
  late String? keterangan;
  late DateTime createdAt;
  late DateTime updatedAt;

  DataRegistrasiModel({
    required this.id,
    required this.tenant,
    required this.paket,
    required this.idPaket,
    required this.idTenant,
    required this.jumlahPegawai,
    required this.totalHarga,
    this.bukti,
    required this.status,
    this.keterangan,
    required this.createdAt,
    required this.updatedAt,
  });

  DataRegistrasiModel.fromOnlineJson(Map<String, dynamic> json) {
    id = json['id'];
    tenant = Tenant.fromJson(json['tenant']);
    paket = Paket.fromJson(json['paket']);
    idPaket = json['id_paket'];
    idTenant = json['id_tenant'];
    jumlahPegawai = json['jumlah_pegawai'];
    totalHarga = double.parse(json['total_harga']);
    bukti = json['bukti'];
    status = json['status'];
    keterangan = json['keterangan'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenant': tenant.toJson(),
      'paket': paket.toJson(),
      'id_paket': idPaket,
      'id_tenant': idTenant,
      'jumlah_pegawai': jumlahPegawai,
      'total_harga': totalHarga,
      'bukti': bukti,
      'status': status,
      'keterangan': keterangan,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
