import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/components/loading.dart';
import 'package:axata_absensi/pages/lokasi/controllers/lokasi_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LokasiView extends GetView<LokasiController> {
  const LokasiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Data Lokasi'),
      backgroundColor: AxataTheme.bgGrey,
      floatingActionButton: FloatingActionButton(
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
      ),
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
                          onLongPress: () {
                            controller.goDialog(data);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 60.w,
                              vertical: 10.h,
                            ),
                            margin: EdgeInsets.only(bottom: 12.h),
                            decoration: AxataTheme.styleUnselectBoxFilter,
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
