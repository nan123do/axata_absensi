import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterCustomHelper {
  static List<Map> listToMapChecked(List<String> list) {
    List<Map> result = list.map((item) {
      return {'name': item, 'checked': false};
    }).toList();
    return result;
  }

  static String selectedMultiFilter(dynamic list) {
    String result = '';
    result = list
        .where((item) => item['checked'] == true)
        .map((item) => item['name'])
        .join(',');
    if (result == '') {
      result = 'Semua';
    }
    return result;
  }

  static List<Map> removeSemuaFromMap(List<Map> list) {
    List<Map> result = list;
    result.removeWhere(
        (item) => item['name'].toString().toUpperCase() == 'SEMUA');
    return result;
  }

  static Widget filterTextContainer(List<String> filterList) {
    Container textContainer(String text) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 40.w,
          vertical: 20.h,
        ),
        decoration: AxataTheme.styleBoxFilter,
        child: Text(
          text,
          style: AxataTheme.oneSmall.copyWith(color: AxataTheme.mainColor),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var filter in filterList) ...[
            textContainer(filter),
            SizedBox(width: 30.w),
          ],
        ],
      ),
    );
  }
}
