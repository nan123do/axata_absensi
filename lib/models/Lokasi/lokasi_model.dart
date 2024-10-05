class DataLokasiModel {
  late String id;
  late String nama;
  late String alamat;
  late String latitude;
  late String longitude;
  late String radius;

  DataLokasiModel({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  DataLokasiModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    nama = json['nama'];
    alamat = json['alamat'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    radius = json['radius'];
  }

  DataLokasiModel.fromOnlineJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    nama = json['nama'];
    alamat = json['alamat'] ?? '';
    latitude = json['latitude'] ?? '';
    longitude = json['longitude'] ?? '';
    radius = json['radius'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
    };
  }
}
