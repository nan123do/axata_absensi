import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/components/loading.dart';
import 'package:axata_absensi/pages/pegawai/controllers/pegawai_controller.dart';
import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class PegawaiView extends GetView<PegawaiController> {
  const PegawaiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'Data Pegawai'),
      backgroundColor: AxataTheme.bgGrey,
      floatingActionButton: GlobalData.globalKoneksi == Koneksi.online
          ? FloatingActionButton(
              onPressed: () => controller.goAddPage(),
              backgroundColor: AxataTheme.mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30.r),
                ),
              ),
              child: const FaIcon(
                FontAwesomeIcons.plus,
              ),
            )
          : Container(),
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
                      'Total : ${controller.listPegawai.length} Pegawai',
                      style: AxataTheme.oneSmall.copyWith(
                        color: AxataTheme.mainColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                        itemCount: controller.sortPegawai.length,
                        itemBuilder: (context, index) {
                          final data = controller.sortPegawai[index];

                          final boxDecoration = data.isDisabled == false
                              ? AxataTheme.styleUnselectBoxFilter
                              : AxataTheme.styleUnselectBoxFilter.copyWith(
                                  color: Colors.grey[300],
                                );

                          return GestureDetector(
                            onLongPress: () {
                              controller.goDialog(data);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 60.w,
                                vertical: 10.h,
                              ),
                              margin: EdgeInsets.only(bottom: 12.h),
                              decoration: boxDecoration,
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  data.nama,
                                  style: AxataTheme.fiveMiddle,
                                ),
                                subtitle: Text(
                                  data.telp,
                                  style: AxataTheme.threeSmall,
                                ),
                                trailing: Text(
                                  data.jabatan,
                                  style: AxataTheme.fiveMiddle,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
