class DataTenantModel {
  late String nama;
  late String alamat;

  DataTenantModel({
    required this.nama,
    required this.alamat,
  });

  DataTenantModel.fromJson(Map<String, dynamic> json) {
    nama = json['nama'];
    alamat = json['alamat'];
  }

  DataTenantModel.fromOnlineJson(Map<String, dynamic> json) {
    nama = json['nama'];
    alamat = json['alamat'];
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'alamat': alamat,
    };
  }
}
