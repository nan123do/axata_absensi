import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/pages/paket/controllers/paket_controller.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SavePaket extends StatelessWidget {
  const SavePaket({
    super.key,
    required this.controller,
    required this.isAdd,
  });
  final PaketController controller;
  final bool isAdd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: isAdd ? 'Tambah Paket' : 'Ubah Paket'),
      backgroundColor: AxataTheme.bgGrey,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 60.w,
          vertical: 20.h,
        ),
        color: AxataTheme.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nama Paket',
                style: AxataTheme.sixSmall,
              ),
              AxataTheme.styleJarak12,
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 30.w,
                  vertical: 24.h,
                ),
                decoration: AxataTheme.styleUnselectBoxFilter,
                child: TextFormField(
                  controller: controller.namaC,
                  keyboardType: TextInputType.text,
                  style: AxataTheme.threeSmall,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Masukkan Nama Paket',
                    hintStyle: AxataTheme.threeSmall.copyWith(
                      color: Colors.black45,
                    ),
                  ),
                ),
              ),
              AxataTheme.styleJarak12,
              Text(
                'Jumlah Hari',
                style: AxataTheme.sixSmall,
              ),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 30.w,
                  vertical: 24.h,
                ),
                decoration: AxataTheme.styleUnselectBoxFilter,
                child: TextFormField(
                  controller: controller.hariC,
                  keyboardType: TextInputType.number,
                  inputFormatters: [CurrencyInputFormatter(currencySymbol: '')],
                  textAlign: TextAlign.right,
                  style: AxataTheme.threeSmall,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Masukkan Jumlah Hari',
                    hintStyle: AxataTheme.threeSmall.copyWith(
                      color: Colors.black45,
                    ),
                  ),
                ),
              ),
              AxataTheme.styleJarak12,
              Text(
                'Harga Paket',
                style: AxataTheme.sixSmall,
              ),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 30.w,
                  vertical: 24.h,
                ),
                decoration: AxataTheme.styleUnselectBoxFilter,
                child: TextFormField(
                  controller: controller.hargaC,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    CurrencyInputFormatter(currencySymbol: 'Rp ')
                  ],
                  textAlign: TextAlign.right,
                  style: AxataTheme.threeSmall,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Masukkan Harga Paket',
                    hintStyle: AxataTheme.threeSmall.copyWith(
                      color: Colors.black45,
                    ),
                  ),
                ),
              ),
              AxataTheme.styleJarak12,
              Text(
                'Max Pegawai',
                style: AxataTheme.sixSmall,
              ),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 30.w,
                  vertical: 24.h,
                ),
                decoration: AxataTheme.styleUnselectBoxFilter,
                child: TextFormField(
                  controller: controller.maxEmpC,
                  keyboardType: TextInputType.number,
                  inputFormatters: [CurrencyInputFormatter(currencySymbol: '')],
                  textAlign: TextAlign.right,
                  style: AxataTheme.threeSmall,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Masukkan Max Pegawai',
                    hintStyle: AxataTheme.threeSmall.copyWith(
                      color: Colors.black45,
                    ),
                  ),
                ),
              ),
              AxataTheme.styleJarak12,
              SizedBox(height: 72.h),
              Obx(
                () => GestureDetector(
                  onTap: () {
                    if (controller.isLoading.isFalse) {
                      controller.handleSimpan(isAdd);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 30.h,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 60.w),
                    alignment: Alignment.center,
                    decoration: AxataTheme.styleGradientUD,
                    child: Text(
                      controller.isLoading.isFalse ? 'Simpan' : 'Loading..',
                      style: AxataTheme.fiveMiddle.copyWith(
                        color: AxataTheme.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 72.h),
            ],
          ),
        ),
      ),
    );
  }
}
