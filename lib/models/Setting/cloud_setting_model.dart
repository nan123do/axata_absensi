class CloudSetting {
  late int id;
  late String idCloud;
  late String settingKey;
  late String settingValue;
  late DateTime createdAt;
  late DateTime updatedAt;

  // Constructor
  CloudSetting({
    required this.id,
    required this.idCloud,
    required this.settingKey,
    required this.settingValue,
    required this.createdAt,
    required this.updatedAt,
  });

  // Constructor untuk menginisialisasi dari JSON
  CloudSetting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idCloud = json['idcloud'];
    settingKey = json['setting_key'];
    settingValue = json['setting_value'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
  }

  // Fungsi untuk mengonversi objek ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idcloud': idCloud,
      'setting_key': settingKey,
      'setting_value': settingValue,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
