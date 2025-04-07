import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/components/small_loading.dart';
import 'package:axata_absensi/pages/setting/controllers/setting_controller.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RiwayatPembayaranView extends StatelessWidget {
  const RiwayatPembayaranView({
    super.key,
    required this.controller,
  });
  final SettingController controller;

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
      appBar: const CustomAppBar(title: 'Riwayat Pembayaran'),
      backgroundColor: AxataTheme.bgGrey,
      body: Obx(
        () => controller.isLoading.value
            ? const SmallLoadingPage()
            : Container(
                padding: EdgeInsets.symmetric(vertical: 36.h),
                height: 1.sh,
                color: AxataTheme.white,
                child: ListView.builder(
                  itemCount: controller.listRegistrasi.length,
                  itemBuilder: (context, index) {
                    final data = controller.listRegistrasi[index];
                    return Container(
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
                                DateFormat('dd MMMM yyyy', 'id_ID').format(
                                  data.createdAt,
                                ),
                                style: AxataTheme.threeSmall,
                              ),
                              GlobalData.isKoneksiOnline()
                                  ? Text(
                                      data.tenant.nama,
                                      style: AxataTheme.threeSmall,
                                    )
                                  : Text(
                                      GlobalData.namatoko,
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
                                AxataTheme.currency.format(data.paket.harga),
                                style: AxataTheme.threeSmall,
                              ),
                              statusView(data.status),
                            ],
                          ),
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
