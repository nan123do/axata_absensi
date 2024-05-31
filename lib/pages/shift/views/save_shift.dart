import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/components/small_loading.dart';
import 'package:axata_absensi/models/Shift/datashift_model.dart';
import 'package:axata_absensi/pages/shift/controllers/shift_controller.dart';
import 'package:axata_absensi/pages/shift/views/checkbox_shift.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SaveShiftView extends StatelessWidget {
  const SaveShiftView({
    super.key,
    required this.controller,
    required this.title,
    required this.type,
    required this.listShift,
  });
  final ShiftController controller;
  final String title;
  final String type;
  final List<DataShiftModel> listShift;

  @override
  Widget build(BuildContext context) {
    List<DataShiftModel> begin = listShift;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: title),
      backgroundColor: AxataTheme.bgGrey,
      body: Column(
        children: [
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nama Jam Kerja',
                  style: AxataTheme.sixSmall,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 24.h),
                  decoration: BoxDecoration(
                    color: AxataTheme.bgGrey,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AxataTheme.black),
                  ),
                  child: TextFormField(
                    controller: controller.namaC,
                    style: AxataTheme.threeSmall,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Nama shift kamu',
                      hintStyle: AxataTheme.threeSmall.copyWith(
                        color: Colors.black45,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama shift harus diisi';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? const SmallLoadingPage()
                  : ListView.builder(
                      itemCount: begin.length,
                      itemBuilder: (context, index) {
                        return CheckBoxShift(
                          listShift: begin,
                          controller: controller,
                          shift: begin[index],
                        );
                      },
                    ),
            ),
          ),
          SizedBox(height: 50.h),
          Row(
            children: [
              SizedBox(width: 60.w),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 30.h,
                    ),
                    alignment: Alignment.center,
                    decoration: AxataTheme.styleRedGradientUD,
                    child: Text(
                      'Batal',
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
                  onTap: () => controller.simpan(data: begin, type: type),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 30.h,
                    ),
                    alignment: Alignment.center,
                    decoration: AxataTheme.styleGradientUD,
                    child: Text(
                      'Simpan',
                      style: AxataTheme.fiveMiddle.copyWith(
                        color: AxataTheme.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 60.w),
            ],
          ),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}
