import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CustomAlertDialog {
  static showDialogAlert({
    required String title,
    required String type,
    required String message,
    required void Function() onConfirm,
    required void Function() onCancel,
  }) {
    FaIcon typeIcon() {
      switch (type) {
        case 'info':
          return FaIcon(
            FontAwesomeIcons.infoCircle,
            color: AxataTheme.yellow,
            size: 300.r,
          );
        case 'success':
          return FaIcon(
            FontAwesomeIcons.checkCircle,
            color: AxataTheme.red,
            size: 200.r,
          );
        case 'error':
          return FaIcon(
            FontAwesomeIcons.timesCircle,
            color: AxataTheme.red,
            size: 300.r,
          );
        default:
          return FaIcon(
            FontAwesomeIcons.infoCircle,
            color: AxataTheme.yellow,
            size: 300.r,
          );
      }
    }

    Get.defaultDialog(
      title: "",
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      radius: 8,
      titlePadding: EdgeInsets.zero,
      titleStyle: const TextStyle(fontSize: 0),
      content: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 32, top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AxataTheme.fiveMiddle,
                ),
                SizedBox(height: 72.h),
                typeIcon(),
                SizedBox(height: 72.h),
                Text(
                  message,
                  style: AxataTheme.fiveMiddle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: GestureDetector(
                    onTap: onCancel,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      decoration: AxataTheme.styleRedGradientUD,
                      alignment: Alignment.center,
                      child: Text(
                        "Tidak",
                        style: AxataTheme.fiveMiddle.copyWith(
                          color: AxataTheme.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 6,
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      decoration: AxataTheme.styleGradientUD,
                      alignment: Alignment.center,
                      child: Text(
                        "Iya",
                        style: AxataTheme.fiveMiddle.copyWith(
                          color: AxataTheme.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
