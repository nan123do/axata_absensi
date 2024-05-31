import 'package:axata_absensi/models/Shift/datashift_model.dart';
import 'package:axata_absensi/utils/datehelper.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SelectShiftPage extends StatelessWidget {
  const SelectShiftPage({
    super.key,
    required this.list,
  });
  final List<DataShiftModel> list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AxataTheme.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.chevronRight,
              color: AxataTheme.black,
              size: 50.r,
            ),
            SizedBox(width: 30.w),
            Text(
              'Cari Shift',
              style: AxataTheme.twoBold,
            ),
          ],
        ),
      ),
      backgroundColor: AxataTheme.bgGrey,
      body: Column(
        children: [
          SizedBox(height: 50.h),
          ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Get.back(result: list[index]),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 2,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  margin: EdgeInsets.symmetric(
                    vertical: 12.h,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 60.w,
                    vertical: 30.h,
                  ),
                  child: ListTile(
                    title: Text(
                      list[index].nama,
                      style: AxataTheme.oneBold,
                    ),
                    trailing: Text(
                      '${DateHelper.strHMStoHM(list[index].jamMasuk)} - ${DateHelper.strHMStoHM(list[index].jamKeluar)}',
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
