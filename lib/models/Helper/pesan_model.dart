class PesanModel {
  late String status;
  late String keterangan;

  PesanModel({
    required this.status,
    required this.keterangan,
  });

  PesanModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    keterangan = json['keterangan'];
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'keterangan': keterangan,
    };
  }
}
