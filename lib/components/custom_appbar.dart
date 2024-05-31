import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.chevronRight,
            size: 50.r,
            color: AxataTheme.black,
          ),
          SizedBox(width: 30.w),
          Text(
            title.toUpperCase(),
            style: AxataTheme.twoBold,
          ),
        ],
      ),
      backgroundColor: AxataTheme.white,
    );
  }
}
