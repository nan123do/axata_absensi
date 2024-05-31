import 'dart:convert';

import 'package:axata_absensi/models/Helper/pesan_model.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/handle_exception.dart';
import 'package:http/http.dart' as http;

class HelperService {
  /*
    Kode Setting
    GajiPermenit = S03
  */
  Future<String> strSetting({
    required String kodeSetting,
  }) async {
    var url = Uri.http(GlobalData.globalWSApi + GlobalData.globalPort,
        "/api/product/get_str_setting", {
      'appId': GlobalData.idcloud,
      'KodeSetting': kodeSetting,
    });
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      PesanModel pesan = PesanModel.fromJson(data);
      if (pesan.status == "success") {
        return pesan.keterangan;
      } else {
        throw Exception(pesan.keterangan);
      }
    } else {
      var status = response.statusCode;
      throw Exception('status: $status, Gagal menghubungi server');
    }
  }

  Future<bool> boolSetting({
    required String kodeSetting,
  }) async {
    var url = Uri.http(GlobalData.globalWSApi + GlobalData.globalPort,
        "/api/product/get_bool_setting", {
      'appId': GlobalData.idcloud,
      'KodeSetting': kodeSetting,
    });
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      PesanModel pesan = PesanModel.fromJson(data);
      if (pesan.status == "success") {
        if (pesan.keterangan.toString().toLowerCase() == 'true') {
          return true;
        } else {
          return false;
        }
      } else {
        throw Exception(pesan.keterangan);
      }
    } else {
      var status = response.statusCode;
      throw Exception('status: $status, Gagal menghubungi server');
    }
  }

  Future<double> doubleSetting({
    required String kodeSetting,
  }) async {
    var url = Uri.http(GlobalData.globalWSApi + GlobalData.globalPort,
        "/api/product/get_decimal_setting", {
      'appId': GlobalData.idcloud,
      'KodeSetting': kodeSetting,
    });
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      PesanModel pesan = PesanModel.fromJson(data);
      if (pesan.status == "success") {
        return double.parse(pesan.keterangan);
      } else {
        throw Exception(pesan.keterangan);
      }
    } else {
      var status = response.statusCode;
      throw Exception('status: $status, Gagal menghubungi server');
    }
  }

  String getKodeSetting(String kode) {
    String xValue = "";

    switch (kode) {
      case "NamaPerusahaan":
        xValue = "P01";
        break;
      case "AlamatPerusahaan":
        xValue = "P02";
        break;
      case "TelpPerusahaan":
        xValue = "P03";
        break;
      case "Fax":
        xValue = "P04";
        break;
      case "WebSite":
        xValue = "P05";
        break;
      case "Email":
        xValue = "P06";
        break;
      case "LogoPerusahaan":
        xValue = "P07";
        break;
      case "JenisAplikasi":
        xValue = "P08";
        break;
      case "TAT":
        xValue = "P09";
        break;
      case "SerialNumber":
        xValue = "P10";
        break;
      case "NPWP":
        xValue = "P11";
        break;
      case "NoPKP":
        xValue = "P12";
        break;
      case "DefaultKodeGudang":
        xValue = "P13";
        break;
      case "VersiAplikasi":
        xValue = "P14";
        break;
      case "SettingCabang":
        xValue = "P15";
        break;
      case "TanggalAwalProgram":
        xValue = "T01";
        break;
      case "PeriodeAwal":
        xValue = "T02";
        break;
      case "PeriodeAkhir":
        xValue = "T03";
        break;
      case "IzinkanTransaksi":
        xValue = "S01";
        break;
      case "KasMinus":
        xValue = "S02";
        break;
      case "GajiPermenit":
        xValue = "S03";
        break;
      case "BarangTampilHargaPokok":
        xValue = "S04";
        break;
      case "BarangTampilModeBarang":
        xValue = "S05";
        break;
      case "BarangPeringatanStokMinimal":
        xValue = "S06";
        break;
      case "PenjualanFocusEnter":
        xValue = "S07";
        break;
      case "PenjualanOpsiDiskon":
        xValue = "S08";
        break;
      case "PenjualanJenisPelanggan":
        xValue = "S09";
        break;
      case "PenjualanJenisBayar":
        xValue = "S10";
        break;
      case "PenjualanBiayaKirim":
        xValue = "S11";
        break;
      case "PenjualanPesanSimpan":
        xValue = "S12";
        break;
      case "PenjualanPesanBarangYgSama":
        xValue = "S13";
        break;
      case "PenjualanPesanCetakNota":
        xValue = "S14";
        break;
      case "PenjualanPesanStokMinimal":
        xValue = "S15";
        break;
      case "PenjualanIzinkanMenambahBarangYgSama":
        xValue = "S16";
        break;
      case "PenjualanIzinkanHargaJualLebihKecilHargaBeli":
        xValue = "S17";
        break;
      case "PenjualanTampilGambarBarang":
        xValue = "S18";
        break;
      case "PenjualanDefaultJumlahJual":
        xValue = "S19";
        break;
      case "PenjualanDecimalPlace":
        xValue = "S20";
        break;
      case "PembelianOpsiDiskon":
        xValue = "S21";
        break;
      case "PembelianJenisBayar":
        xValue = "S22";
        break;
      case "PembelianIzinkanHargaBeliLebihBesarHargaJual":
        xValue = "S23";
        break;
      case "LainLainJenisPajak":
        xValue = "S24";
        break;
      case "LainLainHutangJatuhTempoHari":
        xValue = "S25";
        break;
      case "LainLainPiutangJatuhTempoHari":
        xValue = "S26";
        break;
      case "LainLainAktifPeringatanHutang":
        xValue = "S27";
        break;
      case "LainLainAktifPeringatanPiutang":
        xValue = "S28";
        break;
      case "LainLainDefaultPpn":
        xValue = "S29";
        break;
      case "PembelianTampilExpired":
        xValue = "S30";
        break;
      case "LainLainIzinkanInputSaldo":
        xValue = "S31";
        break;
      case "LainLainIzinkanKasMinus":
        xValue = "S32";
        break;
      case "PenjualanTampilkanPesanOrderPenjualanPelangganUmum":
        xValue = "S33";
        break;
      case "LainLainTampilkanSaldoAwalMaster":
        xValue = "S34";
        break;
      case "LainLainTanggalLebihBesar":
        xValue = "S35";
        break;
      case "PenjualanModePembayaran":
        xValue = "S36";
        break;
      case "PembelianModePembayaran":
        xValue = "S37";
        break;
      case "LainLainRekamMedisTglKembaliTempoHari":
        xValue = "S38";
        break;
      case "LainLainRekamMedisAktifPeringatanTglKembali":
        xValue = "S39";
        break;
      case "LainLainDefaultGudangTukarTambah":
        xValue = "S40";
        break;
      case "LainLainIzinKanTransaksiSaatTutupTransaksi":
        xValue = "S41";
        break;
      case "BarangTampilkanMultiSatuanPadaPencarian":
        xValue = "S42";
        break;
      case "PembelianTampilkanPesanHargaBeliBerubah":
        xValue = "S43";
        break;
      case "BarangPeringatanExpiredDate":
        xValue = "S44";
        break;
      case "BarangExpiredDateHari":
        xValue = "S45";
        break;
      case "PenjualanIzinkanJumlahNol":
        xValue = "S46";
        break;
      case "PenjualanIzinkanUmumBisaKredit":
        xValue = "S47";
        break;
      case "LainLainNotifikasiExpiredDateTerbaru":
        xValue = "S48";
        break;
      case "BarangTampilkanKeteranganMultiSatuan":
        xValue = "S49";
        break;
      case "PenjualanTampilkanPembayaranTunaiSDTotalBayar":
        xValue = "S50";
        break;
      case "PenjualanIzinkanMengubahJumlahHarga":
        xValue = "S51";
        break;
      case "BarangAktifkanKunciStok":
        xValue = "S52";
        break;
      case "PenjualanAktifkanDeposit":
        xValue = "S53";
        break;
      case "BarangTampilkanRakPadaPencarian":
        xValue = "S54";
        break;
      case "BarangTampilkanSupplierPadaPencarian":
        xValue = "S55";
        break;
      case "PembelianAktifkanDeposit":
        xValue = "S56";
        break;
      case "PembelianTampilanHargaBeli":
        xValue = "S57";
        break;
      case "PenjualanBatasiOrderPelanggan":
        xValue = "S58";
        break;
      case "PenjualanReturTotalNol":
        xValue = "S59";
        break;
      case "PembelianReturTotalNol":
        xValue = "S60";
        break;
      case "PenjualanTampilkanBarcodeDanNamaBarang":
        xValue = "S61";
        break;
      case "PenjualanGantiPotongan":
        xValue = "S62";
        break;
      case "BarangTampilkanSatuanTerbesarPadaPencarian":
        xValue = "S63";
        break;
      case "LainLainModeTutupTransaksi":
        xValue = "S64";
        break;
      case "LainLainGantiPajak":
        xValue = "S65";
        break;
      case "LainLainLogKeteranganHapus":
        xValue = "S66";
        break;
      case "PenjualanDefaultService":
        xValue = "S67";
        break;
      case "PenjualanIzinkanTanpaMeja":
        xValue = "S68";
        break;
      case "LainLainKunciMenuDenganPassword":
        xValue = "S69";
        break;
      case "BarangSatuanBeratBarang":
        xValue = "S70";
        break;
      case "BarangTampilkanBeratDiPenjualan":
        xValue = "S71";
        break;
      case "Header1":
        xValue = "D01";
        break;
      case "Header2":
        xValue = "D02";
        break;
      case "Header3":
        xValue = "D03";
        break;
      case "Footer1":
        xValue = "D04";
        break;
      case "Footer2":
        xValue = "D05";
        break;
      case "Footer3":
        xValue = "D06";
        break;
      case "Footer4":
        xValue = "D07";
        break;
      case "Footer5":
        xValue = "D08";
        break;
      case "Header4":
        xValue = "D09";
        break;
      case "Header5":
        xValue = "D10";
        break;
      case "TampilkanLogo":
        xValue = "D11";
        break;
      case "TampilkanUserPadaNota":
        xValue = "D12";
        break;
      case "TampilkanTanggalCetak":
        xValue = "D13";
        break;
      case "TampilkanAlamatPelanggan":
        xValue = "D14";
        break;
      case "TampilkanTeleponPelanggan":
        xValue = "D15";
        break;
      case "TampilkanKeteranganHemat":
        xValue = "D16";
        break;
      case "DefaultHeaderNamaPerusahaan":
        xValue = "D17";
        break;
      case "DefaultHeaderAlamatPerusahaan":
        xValue = "D18";
        break;
      case "DBVersi":
        xValue = "D19";
        break;
      case "AppVersi":
        xValue = "D20";
        break;
      case "TampilkanKeteranganNota":
        xValue = "D21";
        break;
      case "TampilkanSaldoHutangPiutangNota":
        xValue = "D22";
        break;
      case "TampilkanPersenDiskonPadaNota":
        xValue = "D23";
        break;
      case "TampilkanHargaPadaNotaOrderPenjualan":
        xValue = "D24";
        break;
      case "TampilkanSales":
        xValue = "D25";
        break;
      case "TampilkanPelanggan":
        xValue = "D26";
        break;
      case "TampilkanJenisBayar":
        xValue = "D27";
        break;
      case "PrintMode":
        xValue = "D28";
        break;
      case "TampilkanSopir":
        xValue = "D29";
        break;
      case "TampilkanBeratDiSuratJalanA4":
        xValue = "D30";
        break;
      case "GantiPenerimaDgCheckerNotaPenjualan21":
        xValue = "D31";
        break;
      case "TampilkanCheckerPadaSuratJalan":
        xValue = "D32";
        break;
      case "EmasHarga24K":
        xValue = "E01";
        break;
      case "EmasSelisih":
        xValue = "E02";
        break;
      case "RangeKadarAtas":
        xValue = "E03";
        break;
      case "RangeKadarBawah":
        xValue = "E04";
        break;
      case "SPSettingPoin":
        xValue = "Q01";
        break;
      case "SPHitungPoinBerdasarkan":
        xValue = "Q02";
        break;
      case "SPHitungSetiapKelipatanFaktur":
        xValue = "Q03";
        break;
      case "SPNilaiPoin":
        xValue = "Q04";
        break;
      case "SPBerlakuUntukSemuaItem":
        xValue = "Q05";
        break;
      case "SPBerlakuUntukSemuaJenisPelanggan":
        xValue = "Q06";
        break;
      case "SPPeriodePoinAwal":
        xValue = "Q07";
        break;
      case "SPPeriodePoinAkhir":
        xValue = "Q08";
        break;
      case "SPPeriodeTukarAwal":
        xValue = "Q09";
        break;
      case "SPPeriodeTukarAkhir":
        xValue = "Q10";
        break;
      case "IDCloud":
        xValue = "I01";
        break;
      case "StatusShift":
        xValue = "I02";
        break;
      default:
        xValue = "";
        break;
    }
    return xValue;
  }

  Future<String> updateSetting({
    required String kode,
    required String nilai,
  }) async {
    try {
      var url = Uri.http(
        GlobalData.globalWSApi + GlobalData.globalPort,
        "/api/product/update_setting",
      );

      var response = await http.post(
        url,
        body: {
          'appId': GlobalData.idcloud,
          'Kode': kode,
          'nilai': nilai,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        PesanModel pesan = PesanModel.fromJson(data);
        if (pesan.status == "success") {
          return pesan.keterangan;
        } else {
          throw Exception(pesan.keterangan);
        }
      } else {
        var status = response.statusCode;
        throw Exception('status: $status, Gagal menghubungi server');
      }
    } catch (e) {
      String errorMessage = ExceptionHandler().getErrorMessage(e);
      throw errorMessage;
    }
  }
}
