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
  late String jamKerja;

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
    required this.jamKerja,
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
    jamKerja = json['jamKerja'];
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
      'jamKerja': jamKerja,
    };
  }
}
