import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/pages/shift/controllers/shift_controller.dart';
import 'package:axata_absensi/pages/shift/views/with_shift.dart';
import 'package:axata_absensi/pages/shift/views/without_shift.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ShiftView extends GetView<ShiftController> {
  const ShiftView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'jam kerja'),
      backgroundColor: AxataTheme.bgGrey,
      body: Obx(
        () => controller.isActiveShift.value
            ? WithShiftView(controller: controller)
            : WithoutShiftView(controller: controller),
      ),
      floatingActionButton: Obx(
        () => controller.isActiveShift.value
            ? FloatingActionButton(
                onPressed: () => controller.goAddShift(),
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
      ),
    );
  }
}
