import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SmallLoadingPage extends StatelessWidget {
  const SmallLoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          orientation == Orientation.portrait
              ? Image.asset(
                  'assets/logo/axata_full.png',
                  height: 100,
                  width: 200,
                )
              : Container(),
          const CircularProgressIndicator(),
          SizedBox(
            height: 40.h,
          ),
          Text(
            'Sedang memuat data... ',
            style: TextStyle(color: AxataTheme.mainColor, fontSize: 40.sp),
          )
        ],
      ),
    );
  }
}
