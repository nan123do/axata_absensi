class PegawaiData {
  static String nama = '';
  static String kodepegawai = ''; // sama dengan id kalau online
  static String idjenisuser = '';
  static bool aksesdashboard = false;
  static bool statusAktif = false;
  static bool isAdmin = false;
  static bool isSuperUser = false;
  static DateTime tgllahir = DateTime.now();
  static String alamat = '';
  static String telp = '';
  static String norek = '';
  static String namajabatan = '';
  static String menuakses = '';
  static String tokenAuth = '';

  static bool isNando() {
    return nama.toLowerCase().contains('nando');
  }

  static bool isNotNando() {
    return !(nama.toLowerCase().contains('nando'));
  }
}
