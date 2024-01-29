// ignore_for_file: prefer_const_constructors

import 'package:axata_absensi/pages/checkin/bindings/checkin_binding.dart';
import 'package:axata_absensi/pages/checkin/views/checkin_view.dart';
import 'package:axata_absensi/pages/home/bindings/home_binding.dart';
import 'package:axata_absensi/pages/home/views/home_view.dart';
import 'package:axata_absensi/pages/idcloud/bindings/idcloud_binding.dart';
import 'package:axata_absensi/pages/idcloud/views/idcloud_view.dart';
import 'package:axata_absensi/pages/login/bindings/login_binding.dart';
import 'package:axata_absensi/pages/login/views/login_view.dart';
import 'package:axata_absensi/pages/profile/bindings/profile_binding.dart';
import 'package:axata_absensi/pages/profile/views/profile_view.dart';
import 'package:axata_absensi/pages/smileface/bindings/smileface_binding.dart';
import 'package:axata_absensi/pages/smileface/views/smileface_view.dart';
import 'package:axata_absensi/pages/splash/bindings/splash_binding.dart';
import 'package:axata_absensi/pages/splash/views/splash_view.dart';
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
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
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
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.CHECKIN,
      page: () => CheckInView(),
      binding: CheckInBinding(),
    ),
    GetPage(
      name: _Paths.SMILEFACE,
      page: () => SmileFaceView(),
      binding: SmileFaceBinding(),
    ),
  ];
}
