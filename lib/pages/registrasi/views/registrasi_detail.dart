import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/components/small_loading.dart';
import 'package:axata_absensi/models/Registrasi/registrasi_model.dart';
import 'package:axata_absensi/pages/registrasi/controllers/registrasi_controller.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailRegistrasiView extends StatelessWidget {
  const DetailRegistrasiView({
    super.key,
    required this.controller,
    required this.data,
  });
  final RegistrasiController controller;
  final DataRegistrasiModel data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'Detail Registrasi'),
      backgroundColor: AxataTheme.bgGrey,
      body: Obx(
        () => controller.isLoading.value
            ? const SmallLoadingPage()
            : Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 0.85.sh,
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 60.w, vertical: 60.h),
                    decoration: AxataTheme.styleUnselectBoxFilter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.tenant.nama,
                          style: AxataTheme.threeSmall,
                        ),
                        Text(
                          '${data.paket.nama} - ${AxataTheme.currency.format(data.paket.hari)} Hari',
                          style: AxataTheme.fiveMiddle,
                        ),
                        Text(
                          AxataTheme.currency.format(data.paket.harga),
                          style: AxataTheme.threeSmall,
                        ),
                        Text(
                          DateFormat('dd MMMM yyyy', 'id_ID').format(
                            data.createdAt,
                          ),
                          style: AxataTheme.threeSmall,
                        ),
                        SizedBox(height: 60.h),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(60.r),
                            margin: EdgeInsets.symmetric(horizontal: 60.w),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                image: NetworkImage(
                                    'http://${GlobalData.globalAPI}${GlobalData.globalPort}${data.bukti!}'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // child: handleChild(),
                          ),
                        ),
                        SizedBox(height: 72.h),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    controller.handleKonfirmasi(data, '0'),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 30.h,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: AxataTheme.styleRedGradientUD,
                                  child: Text(
                                    'Tolak',
                                    style: AxataTheme.fiveMiddle.copyWith(
                                      color: AxataTheme.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 60.w),
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    controller.handleKonfirmasi(data, '1'),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 30.h,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: AxataTheme.styleGradientUD,
                                  child: Text(
                                    'Setujui',
                                    style: AxataTheme.fiveMiddle.copyWith(
                                      color: AxataTheme.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
