import 'package:axata_absensi/components/custom_navbar.dart';
import 'package:axata_absensi/pages/profile/controllers/profile_controller.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomNavBarView(),
      backgroundColor: AxataTheme.bgGrey,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/bg_profile.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 200.h,
            left: 70.w,
            child: Text(
              'Profile',
              style: AxataTheme.twoBold.copyWith(color: AxataTheme.white),
            ),
          ),
          Positioned(
            top: 0.2.sh,
            child: SizedBox(
              width: 0.9.sw,
              child: Column(
                children: [
                  Text(
                    PegawaiData.nama == '' ? 'Bukan Pegawai' : PegawaiData.nama,
                    style: AxataTheme.twoBold.copyWith(color: AxataTheme.white),
                  ),
                  SizedBox(height: 50.h),
                  ListMenu(
                    title: 'Tanggal Lahir',
                    subtitle: DateFormat('dd MMMM yyyy', 'id_ID')
                        .format(PegawaiData.tgllahir),
                    icon: FontAwesomeIcons.birthdayCake,
                  ),
                  ListMenu(
                    title: 'Alamat',
                    subtitle: PegawaiData.alamat,
                    icon: FontAwesomeIcons.addressBook,
                  ),
                  ListMenu(
                    title: 'Telp',
                    subtitle: PegawaiData.telp,
                    icon: FontAwesomeIcons.phoneAlt,
                  ),
                  ListMenu(
                    title: 'Jabatan',
                    subtitle: PegawaiData.namajabatan,
                    icon: FontAwesomeIcons.star,
                  ),
                  ListMenu(
                    title: 'No Rek',
                    subtitle: PegawaiData.norek,
                    icon: FontAwesomeIcons.wallet,
                  ),
                  SizedBox(height: 51.h),
                  GestureDetector(
                    onTap: () => controller.logout(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AxataTheme.white,
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      child: ListTile(
                        visualDensity: const VisualDensity(horizontal: -4),
                        leading: FaIcon(
                          FontAwesomeIcons.signOutAlt,
                          size: 60.r,
                          color: AxataTheme.red,
                        ),
                        title: Text(
                          'Keluar',
                          style: AxataTheme.threeSmall
                              .copyWith(color: AxataTheme.red),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListMenu extends StatelessWidget {
  const ListMenu({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AxataTheme.white,
        borderRadius: BorderRadius.circular(40.r),
      ),
      child: ListTile(
        visualDensity: const VisualDensity(horizontal: -4),
        leading: FaIcon(
          icon,
          size: 60.r,
          color: AxataTheme.black,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AxataTheme.sixSmall,
            ),
            Text(
              subtitle == '' ? '-' : subtitle,
              style: AxataTheme.threeSmall,
            )
          ],
        ),
      ),
    );
  }
}
