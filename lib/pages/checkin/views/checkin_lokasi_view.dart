import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/components/loading.dart';
import 'package:axata_absensi/pages/checkin/controllers/checkin_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CheckInLokasi extends StatelessWidget {
  const CheckInLokasi({
    super.key,
    required this.controller,
    required this.lokasi,
  });
  final CheckInController controller;
  final Map<String, String> lokasi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'Data Lokasi'),
      backgroundColor: AxataTheme.bgGrey,
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingPage()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 30.w,
                      vertical: 20.h,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.w,
                      vertical: 20.h,
                    ),
                    decoration: BoxDecoration(
                      color: AxataTheme.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      'Total : ${controller.listLokasi.length} Lokasi',
                      style: AxataTheme.oneSmall.copyWith(
                        color: AxataTheme.mainColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.listLokasi.length,
                      itemBuilder: (context, index) {
                        final data = controller.listLokasi[index];
                        return GestureDetector(
                          onTap: () => controller.handlePilihLokasi(data),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 60.w,
                              vertical: 10.h,
                            ),
                            margin: EdgeInsets.only(bottom: 12.h),
                            decoration:
                                AxataTheme.styleUnselectBoxFilter.copyWith(
                              color: data.id.toString() == lokasi['id']
                                  ? AxataTheme.mainColorS
                                  : AxataTheme.white,
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                data.nama,
                                style: AxataTheme.fiveMiddle,
                              ),
                              subtitle: Text(
                                data.alamat,
                                style: AxataTheme.threeSmall,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
