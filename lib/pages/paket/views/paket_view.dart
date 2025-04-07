import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/components/small_loading.dart';
import 'package:axata_absensi/pages/paket/controllers/paket_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class PaketView extends GetView<PaketController> {
  const PaketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'Paket Berlangganan'),
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
      backgroundColor: AxataTheme.bgGrey,
      body: Obx(
        () {
          // Membuat salinan list untuk diurutkan
          final sortedList = List.from(controller.listPaket)
            ..sort((a, b) {
              // Jika a.statusAktif == true dan b.statusAktif == false, maka a di atas
              if (a.statusAktif && !b.statusAktif) {
                return -1;
              } else if (!a.statusAktif && b.statusAktif) {
                return 1;
              } else {
                return 0;
              }
            });

          return controller.isLoading.value
              ? const SmallLoadingPage()
              : Container(
                  padding: EdgeInsets.symmetric(vertical: 36.h),
                  height: 1.sh,
                  color: AxataTheme.white,
                  child: ListView.builder(
                    itemCount: sortedList.length,
                    itemBuilder: (context, index) {
                      final data = sortedList[index];

                      // Jika paket tidak aktif, warnai container abu-abu
                      final boxDecoration = data.statusAktif
                          ? AxataTheme.styleUnselectBoxFilter
                          : AxataTheme.styleUnselectBoxFilter.copyWith(
                              color: Colors.grey[300],
                            );

                      return GestureDetector(
                        onLongPress: () => controller.goDialog(data),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 60.w,
                            vertical: 24.h,
                          ),
                          margin: EdgeInsets.only(bottom: 12.h),
                          decoration: boxDecoration,
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
                                    'Rp ${AxataTheme.currency.format(data.harga)}/${AxataTheme.currency.format(data.hari)} Hari',
                                    style: AxataTheme.threeSmall,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                'Max ${AxataTheme.currency.format(data.jumlahPegawai)} Pegawai',
                                style: AxataTheme.threeSmall,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
