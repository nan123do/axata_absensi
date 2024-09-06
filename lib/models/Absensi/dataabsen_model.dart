class PaginatedAbsensi {
  List<DataAbsenModel> results;
  int count;
  int telat;
  String? next;
  String? previous;

  PaginatedAbsensi({
    required this.results,
    required this.count,
    required this.telat,
    this.next,
    this.previous,
  });

  factory PaginatedAbsensi.fromOnlineJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<DataAbsenModel> resultsList =
        list.map((item) => DataAbsenModel.fromOnlineJson(item)).toList();
    return PaginatedAbsensi(
      results: resultsList,
      telat: json['telat'],
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
    );
  }
}

class DataAbsenModel {
  late String id;
  late String nama;
  late DateTime jamMasuk;
  late DateTime jamKeluar;
  late double jmlMenit;
  late double tarif;
  late double gajiAbsen;
  late String keterangan;
  late String kodePegawai;
  late String status;
  late String idShift;
  late String namaShift;
  late String jamKerja;
  late String foto;

  DataAbsenModel({
    required this.id,
    required this.nama,
    required this.jamMasuk,
    required this.jamKeluar,
    required this.jmlMenit,
    required this.tarif,
    required this.gajiAbsen,
    required this.keterangan,
    required this.kodePegawai,
    required this.status,
    required this.idShift,
    required this.namaShift,
    required this.jamKerja,
    required this.foto,
  });

  DataAbsenModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    nama = json['namaPegawai'];
    jamMasuk = DateTime.parse(json['jamMasuk'].toString());
    jamKeluar = DateTime.parse(json['jamKeluar'].toString());
    jmlMenit = json['jmlMenit'] ?? 0;
    tarif = json['tarif'] ?? 0;
    gajiAbsen = json['gajiAbsen'] ?? 0;
    keterangan = json['keterangan'];
    kodePegawai = json['kodePegawai'];
    status = json['status'];
    idShift = json['idShift'];
    namaShift = json['namaShift'] ?? '';
    jamKerja = json['jamKerja'];
    foto = json['foto'] ?? '638609715229378432.jpg';
  }

  DataAbsenModel.fromOnlineJson(Map<String, dynamic> json) {
    Map<String, dynamic> user = json['user'];
    Map<String, dynamic> shift = json['shift'];

    id = json['id'].toString();
    nama = user['first_name'];
    jamMasuk = DateTime.parse(json['jam_masuk'].toString()).add(
      const Duration(hours: 7),
    );
    jamKeluar = DateTime.parse(json['jam_keluar'].toString()).add(
      const Duration(hours: 7),
    );
    jmlMenit = jamKeluar.difference(jamMasuk).inMinutes.toDouble();
    tarif = json['tarif'] == null ? 0 : double.parse(json['tarif']);
    gajiAbsen = json['tarif'] == null ? 0 : tarif * jmlMenit;
    keterangan = json['keterangan'];
    kodePegawai = user['username'];
    status = json['status'].toString();
    idShift = shift['id'].toString();
    namaShift = shift['nama'] ?? '';
    jamKerja = json['jam_kerja'];
    foto = json['foto'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'jamMasuk': jamMasuk,
      'jamKeluar': jamKeluar,
      'jmlMenit': jmlMenit,
      'tarif': tarif,
      'gajiAbsen': gajiAbsen,
      'keterangan': keterangan,
      'kodePegawai': kodePegawai,
      'status': status,
      'idShift': idShift,
      'namaShift': namaShift,
      'jamKerja': jamKerja,
      'foto': foto,
    };
  }
}
