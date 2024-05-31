import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/components/datepickv3.dart';
import 'package:axata_absensi/components/small_loading.dart';
import 'package:axata_absensi/models/Absensi/dataabsen_model.dart';
import 'package:axata_absensi/pages/absensi/controllers/absensi_controller.dart';
import 'package:axata_absensi/pages/absensi/views/container_total.dart';
import 'package:axata_absensi/pages/absensi/views/datepick_pegawai.dart';
import 'package:axata_absensi/components/filter_helper.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AbsensiView extends GetView<AbsensiController> {
  const AbsensiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'Data Absensi'),
      backgroundColor: AxataTheme.bgGrey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 60.w),
            child: Row(
              children: [
                PegawaiData.isAdmin
                    ? DatePickV3(
                        selectedDate: controller.selectedDate.value,
                        dateFrom: controller.dateFrom,
                        dateTo: controller.dateTo,
                        onDateChanged: controller.onDateChanged,
                      )
                    : Obx(
                        () => DatePickPegawai(
                          selectedDate: controller.selectedDate.value,
                          dateFrom: controller.dateFrom,
                          dateTo: controller.dateTo,
                          onDateChanged: controller.onDateChanged,
                        ),
                      ),
                SizedBox(width: 12.w),
                PegawaiData.isAdmin
                    ? GestureDetector(
                        onTap: () => controller.openModalFilterJenis(context),
                        child: Container(
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
                      )
                    : Container(),
              ],
            ),
          ),
          SizedBox(height: PegawaiData.isAdmin ? 24.h : 0),
          PegawaiData.isAdmin
              ? Obx(
                  () => controller.firstData.value
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 60.w),
                          child: FilterCustomHelper.filterTextContainer([
                            controller.selectedPegawai.value,
                            controller.selectedLaporan.value,
                          ]),
                        ),
                )
              : Container(),
          SizedBox(height: 24.h),
          Obx(
            () => Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.w),
              child: Row(
                children: [
                  ContainerTotalAbsensi(
                    title: 'Total Absen',
                    nilai:
                        AxataTheme.currency.format(controller.totalAbsen.value),
                    color: AxataTheme.green,
                  ),
                  SizedBox(width: 12.w),
                  ContainerTotalAbsensi(
                    title: 'Tepat Waktu',
                    nilai: controller.tepatWaktu.value,
                    color: AxataTheme.mainColor,
                  ),
                  SizedBox(width: 12.w),
                  ContainerTotalAbsensi(
                    title: 'Telat',
                    nilai: controller.telat.value,
                    color: AxataTheme.red,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? const SmallLoadingPage()
                  : controller.listAbsen.isEmpty
                      ? Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(24.r),
                            ),
                            color: AxataTheme.white,
                          ),
                          child: Center(
                            child: Text(
                              'Data Kosong!',
                              style: AxataTheme.oneBold,
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: controller.scrollC,
                          itemCount: controller.listAbsen.length +
                              (controller.isLoadingNextPage.isTrue ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= controller.listAbsen.length) {
                              if (controller.isLoadingNextPage.isTrue) {
                                return Container(
                                  alignment: Alignment.center,
                                  color: AxataTheme.white,
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: const CircularProgressIndicator(),
                                );
                              }

                              return Container();
                            }

                            DataAbsenModel data = controller.listAbsen[index];

                            String getJadwalAbsen(
                              String filter,
                            ) {
                              String hasil = '-';
                              if (data.jamKerja != '') {
                                List<String> jadwal = data.jamKerja.split('-');
                                if (filter == 'checkin') {
                                  hasil = jadwal[0];
                                } else {
                                  hasil = jadwal[1];
                                }
                              }
                              return hasil;
                            }

                            Color getColorCheckin() {
                              String jadwal = getJadwalAbsen('checkin');
                              return controller.isTimeBeforeJadwalCheckIn(
                                DateFormat('HH:mm').format(data.jamMasuk),
                                jadwal,
                              )
                                  ? AxataTheme.green
                                  : AxataTheme.red;
                            }

                            String getJamKeluar() {
                              if (data.jamMasuk == data.jamKeluar) {
                                return '-';
                              } else {
                                return DateFormat('HH:mm')
                                    .format(data.jamKeluar);
                              }
                            }

                            return GestureDetector(
                              onLongPress: () => PegawaiData.isAdmin
                                  ? controller.goDialogAbsensi(data)
                                  : {},
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 60.w,
                                  vertical: 12.h,
                                ),
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 12.h),
                                decoration: AxataTheme.styleUnselectBoxFilter,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller
                                                    .listAbsen[index].nama,
                                                style: AxataTheme.oneBold,
                                              ),
                                              Visibility(
                                                visible: controller
                                                        .listAbsen[index]
                                                        .namaShift !=
                                                    'default',
                                                child: Text(
                                                  controller.listAbsen[index]
                                                      .namaShift,
                                                  style: AxataTheme.fourSmall,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                DateFormat(
                                                        'dd MMMM yyyy', 'id_ID')
                                                    .format(controller
                                                        .listAbsen[index]
                                                        .jamMasuk),
                                                style: AxataTheme.fourSmall,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Masuk',
                                                    style: AxataTheme.fourSmall,
                                                  ),
                                                  SizedBox(width: 18.w),
                                                  Container(
                                                    width: 170.h,
                                                    alignment: Alignment.center,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 33.w),
                                                    decoration: AxataTheme
                                                        .styleUnselectBoxFilter,
                                                    child: FittedBox(
                                                      child: Text(
                                                        DateFormat('HH:mm')
                                                            .format(
                                                                data.jamMasuk),
                                                        style: AxataTheme
                                                            .oneSmall
                                                            .copyWith(
                                                          color:
                                                              getColorCheckin(),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              DateFormat(
                                                      'dd MMMM yyyy', 'id_ID')
                                                  .format(controller
                                                      .listAbsen[index]
                                                      .jamKeluar),
                                              style: AxataTheme.fourSmall,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Keluar',
                                                  style: AxataTheme.fourSmall,
                                                ),
                                                SizedBox(width: 18.w),
                                                Container(
                                                  width: 170.h,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 33.w),
                                                  decoration: AxataTheme
                                                      .styleUnselectBoxFilter,
                                                  child: FittedBox(
                                                    child: Text(
                                                      getJamKeluar(),
                                                      style: AxataTheme.oneSmall
                                                          .copyWith(
                                                        color: AxataTheme
                                                            .mainColor,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    controller.listAbsen[index].keterangan == ''
                                        ? Container()
                                        : Text(
                                            controller
                                                .listAbsen[index].keterangan,
                                            style: AxataTheme.fourSmall,
                                          ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ),
          SizedBox(height: 50.h)
        ],
      ),
      floatingActionButton: PegawaiData.isAdmin
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
    );
  }
}
