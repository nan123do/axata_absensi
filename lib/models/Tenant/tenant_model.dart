class DataTenantModel {
  late String id;
  late String nama;
  late String alamat;

  DataTenantModel({
    required this.id,
    required this.nama,
    required this.alamat,
  });

  DataTenantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    nama = json['nama'];
    nama = json['nama'];
    alamat = json['alamat'];
  }

  DataTenantModel.fromOnlineJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    nama = json['nama'];
    nama = json['nama'];
    alamat = json['alamat'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'alamat': alamat,
    };
  }
}
