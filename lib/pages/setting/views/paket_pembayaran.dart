import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/components/small_loading.dart';
import 'package:axata_absensi/pages/setting/controllers/setting_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PaketPembayaranView extends StatelessWidget {
  const PaketPembayaranView({
    super.key,
    required this.controller,
  });
  final SettingController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'Paket Berlangganan'),
      backgroundColor: AxataTheme.bgGrey,
      body: Obx(
        () => controller.isLoading.value
            ? const SmallLoadingPage()
            : Container(
                padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 36.w),
                height: 1.sh,
                color: AxataTheme.white,
                child: ListView.builder(
                  itemCount: controller.listPaket.length,
                  itemBuilder: (context, index) {
                    final data = controller.listPaket[index];
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 60.w,
                        vertical: 24.h,
                      ),
                      margin: EdgeInsets.only(bottom: 12.h),
                      decoration: AxataTheme.styleUnselectBoxFilter,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.nama,
                                style: AxataTheme.fiveMiddle,
                              ),
                              Text(
                                'Max ${AxataTheme.currency.format(data.jumlahPegawai)} Pegawai',
                                style: AxataTheme.threeSmall,
                              ),
                              Text(
                                'Rp ${AxataTheme.currency.format(data.harga)}/${AxataTheme.currency.format(data.hari)} Hari',
                                style: AxataTheme.threeSmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => controller.goPembayaranPage(data),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 45.w,
                                vertical: 12.h,
                              ),
                              decoration: AxataTheme.styleGradientUD,
                              child: Text(
                                'Pilih Paket',
                                style: AxataTheme.oneSmall.copyWith(
                                  color: AxataTheme.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}