import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/components/filter_helper.dart';
import 'package:axata_absensi/components/loading.dart';
import 'package:axata_absensi/pages/registrasi/controllers/registrasi_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RegistrasiView extends GetView<RegistrasiController> {
  const RegistrasiView({super.key});

  @override
  Widget build(BuildContext context) {
    Widget statusView(String status) {
      switch (status) {
        case '0':
          return Text(
            'Ditolak',
            style: AxataTheme.threeSmall.copyWith(color: AxataTheme.red),
          );
        case '1':
          return Text(
            'Disetujui',
            style: AxataTheme.threeSmall.copyWith(color: AxataTheme.mainColor),
          );
        case '2':
          return Text(
            'Pending',
            style: AxataTheme.threeSmall.copyWith(color: AxataTheme.yellow),
          );
        default:
          return Container();
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'Registrasi'),
      backgroundColor: AxataTheme.white,
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingPage()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => controller.openModalFilterJenis(context),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 40.w,
                            vertical: 20.h,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.w,
                            vertical: 20.h,
                          ),
                          decoration: AxataTheme.styleUnselectBoxFilter,
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.filter,
                                color: AxataTheme.mainColor,
                                size: 30.r,
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Text(
                                'Filter',
                                style: AxataTheme.oneSmall.copyWith(
                                  color: AxataTheme.mainColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: FilterCustomHelper.filterTextContainer([
                      controller.selectedLaporan.value,
                    ]),
                  ),
                  SizedBox(height: 50.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.listReg.length,
                      itemBuilder: (context, index) {
                        final data = controller.listReg[index];
                        return GestureDetector(
                          onTap: () => controller.goDetailRegistrasi(data),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 60.w,
                              vertical: 20.h,
                            ),
                            margin: EdgeInsets.only(bottom: 12.h),
                            decoration: AxataTheme.styleUnselectBoxFilter,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat('dd MMMM yyyy', 'id_ID')
                                          .format(
                                        data.createdAt,
                                      ),
                                      style: AxataTheme.threeSmall,
                                    ),
                                    Text(
                                      data.tenant.nama,
                                      style: AxataTheme.threeSmall,
                                    ),
                                    Text(
                                      '${data.paket.nama} - ${AxataTheme.currency.format(data.paket.hari)} Hari',
                                      style: AxataTheme.fiveMiddle,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      AxataTheme.currency
                                          .format(data.paket.harga),
                                      style: AxataTheme.threeSmall,
                                    ),
                                    statusView(data.status),
                                  ],
                                ),
                              ],
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
