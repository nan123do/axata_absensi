import 'dart:typed_data';

import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/pages/absensi/controllers/absensi_controller.dart';
import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailAbsensiView extends GetView<AbsensiController> {
  const DetailAbsensiView({
    super.key,
    this.foto,
    required this.tanggal,
    required this.color,
    this.url,
  });
  final Uint8List? foto;
  final DateTime tanggal;
  final Color color;
  final String? url;

  @override
  Widget build(BuildContext context) {
    BoxDecoration handleImage() {
      if (foto == null && url == null) {
        return BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        );
      } else {
        return BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: GlobalData.globalKoneksi == Koneksi.online
                ? NetworkImage(
                    'http://${GlobalData.globalAPI}${GlobalData.globalPort}${url!}')
                : MemoryImage(foto!) as ImageProvider<Object>,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        );
      }
    }

    handleChild() {
      if (foto == null && (url == '' || url == null)) {
        return Text(
          'Foto tidak ditemukan atau sudah dihapus',
          style: AxataTheme.twoBold.copyWith(color: Colors.black54),
          textAlign: TextAlign.center,
        );
      } else {
        return Container();
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'Detail Absensi'),
      backgroundColor: AxataTheme.bgGrey,
      body: Column(
        children: [
          SizedBox(height: 36.h),
          Text(
            DateFormat('EEEE d MMMM yyyy', 'id_ID').format(tanggal),
            style: AxataTheme.twoBold,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Absen Masuk',
                style: AxataTheme.twoBold,
              ),
              SizedBox(width: 20.w),
              Container(
                width: 170.h,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 33.w, vertical: 10.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.r),
                  ),
                  border: Border.all(color: const Color(0x3F000000)),
                ),
                child: FittedBox(
                  child: Text(
                    DateFormat('HH:mm').format(tanggal),
                    style: AxataTheme.twoBold.copyWith(
                      color: color,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 36.h),
          Container(
            width: double.infinity,
            height: 0.65.sh,
            padding: EdgeInsets.all(60.r),
            margin: EdgeInsets.symmetric(horizontal: 60.w),
            alignment: Alignment.center,
            decoration: handleImage(),
            child: handleChild(),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 30.h,
              ),
              margin: EdgeInsets.symmetric(horizontal: 60.w),
              alignment: Alignment.center,
              decoration: AxataTheme.styleGradientUD,
              child: Text(
                'Kembali',
                style: AxataTheme.fiveMiddle.copyWith(
                  color: AxataTheme.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}
