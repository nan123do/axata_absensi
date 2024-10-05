import 'dart:io';

import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/models/Paket/paket_model.dart';
import 'package:axata_absensi/pages/setting/controllers/setting_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PembayaranView extends StatelessWidget {
  const PembayaranView({
    super.key,
    required this.controller,
    required this.paket,
  });
  final SettingController controller;
  final DataPaketModel paket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'Paket Berlangganan'),
      backgroundColor: AxataTheme.bgGrey,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 36.w),
        height: 1.sh,
        color: AxataTheme.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 60.w,
                vertical: 24.h,
              ),
              width: double.infinity,
              decoration: AxataTheme.styleUnselectBoxFilter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    paket.nama,
                    style: AxataTheme.fiveMiddle,
                  ),
                  Text(
                    'Max ${AxataTheme.currency.format(paket.jumlahPegawai)} Pegawai',
                    style: AxataTheme.threeSmall,
                  ),
                  Text(
                    'Rp ${AxataTheme.currency.format(paket.harga)}/${AxataTheme.currency.format(paket.hari)} Hari',
                    style: AxataTheme.threeSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 20.h),
              child: Text.rich(
                TextSpan(
                  text:
                      'Jadi total yang harus anda kirim/transfer sebesar Rp. ',
                  style: AxataTheme.oneSmall,
                  children: [
                    TextSpan(
                      text: AxataTheme.currency.format(paket.harga),
                      style: AxataTheme.oneSmall
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' Ke No Rekening dibawah ini',
                      style: AxataTheme.oneSmall,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 20.h),
              child: Text(
                'Nomor Rekening : 0901-0425-34\nNama Bank : BCA\nA/N : AGUNG SETYO BUDI',
                style: AxataTheme.fiveMiddle,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 20.h),
              child: Text(
                'Silahkan Unggah Bukti Transaksi dibawah ini, jika anda sudah mengirim/transfer :',
                style: AxataTheme.oneSmall,
              ),
            ),
            SizedBox(height: 40.h),
            Obx(
              () => Visibility(
                visible: controller.selectedImage != null &&
                    controller.isLoading.isFalse,
                child: controller.selectedImage != null
                    ? Center(
                        child: Container(
                          width: 0.6.sw,
                          height: 0.4.sh,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: AxataTheme.black, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(controller.selectedImage!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
            ),
            SizedBox(height: 40.h),
            Center(
              child: GestureDetector(
                onTap: () => controller.showImagePickerOptions(context),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 60.w, vertical: 30.h),
                  decoration: AxataTheme.styleGradientUD,
                  child: Text(
                    'Unggah Bukti',
                    style: AxataTheme.oneBold.copyWith(
                      color: AxataTheme.white,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => controller.handleKirimLangganan(paket),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 30.h,
                ),
                margin: EdgeInsets.symmetric(horizontal: 60.w),
                alignment: Alignment.center,
                decoration: AxataTheme.styleGradientUD,
                child: Text(
                  'Konfirmasi',
                  style: AxataTheme.fiveMiddle.copyWith(
                    color: AxataTheme.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
