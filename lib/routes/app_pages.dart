// ignore_for_file: prefer_const_constructors

import 'package:axata_absensi/pages/absensi/bindings/absensi_binding.dart';
import 'package:axata_absensi/pages/absensi/views/absensi_view.dart';
import 'package:axata_absensi/pages/checkin/bindings/checkin_binding.dart';
import 'package:axata_absensi/pages/checkin/views/checkin_view.dart';
import 'package:axata_absensi/pages/home/bindings/home_binding.dart';
import 'package:axata_absensi/pages/home/views/home_view.dart';
import 'package:axata_absensi/pages/idcloud/bindings/idcloud_binding.dart';
import 'package:axata_absensi/pages/idcloud/views/idcloud_view.dart';
import 'package:axata_absensi/pages/login/bindings/login_binding.dart';
import 'package:axata_absensi/pages/login/views/login_view.dart';
import 'package:axata_absensi/pages/pegawai/bindings/pegawai_binding.dart';
import 'package:axata_absensi/pages/pegawai/views/pegawai_view.dart';
import 'package:axata_absensi/pages/profile/bindings/profile_binding.dart';
import 'package:axata_absensi/pages/profile/views/profile_view.dart';
import 'package:axata_absensi/pages/setting/bindings/setting_binding.dart';
import 'package:axata_absensi/pages/setting/views/setting_view.dart';
import 'package:axata_absensi/pages/shift/bindings/shift_binding.dart';
import 'package:axata_absensi/pages/shift/views/shift_view.dart';
import 'package:axata_absensi/pages/smileface/bindings/smileface_binding.dart';
import 'package:axata_absensi/pages/smileface/views/smileface_view.dart';
import 'package:axata_absensi/pages/splash/bindings/splash_binding.dart';
import 'package:axata_absensi/pages/splash/views/splash_view.dart';
import 'package:axata_absensi/pages/test/bindings/test_binding.dart';
import 'package:axata_absensi/pages/test/views/test_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.TEST,
      page: () => TestView(),
      binding: TestBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: _Paths.IDCLOUD,
      page: () => IdCloudView(),
      binding: IdCloudBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.CHECKIN,
      page: () => CheckInView(),
      binding: CheckInBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: _Paths.SMILEFACE,
      page: () => SmileFaceView(),
      binding: SmileFaceBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: _Paths.SHIFT,
      page: () => ShiftView(),
      binding: ShiftBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: _Paths.ABSENSI,
      page: () => AbsensiView(),
      binding: AbsensiBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => SettingView(),
      binding: SettingBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: _Paths.PEGAWAI,
      page: () => PegawaiView(),
      binding: PegawaiBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
