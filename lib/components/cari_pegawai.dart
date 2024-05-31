import 'package:axata_absensi/models/Pegawai/datapegawai_model.dart';
import 'package:axata_absensi/pages/absensi/controllers/absensi_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SelectPegawaiPage extends StatelessWidget {
  const SelectPegawaiPage({
    super.key,
    required this.list,
    required this.controller,
  });
  final List<DataPegawaiModel> list;
  final AbsensiController controller;

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
              'Cari Pegawai',
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
                onTap: () => controller.afterSelectPegawai(list[index]),
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
