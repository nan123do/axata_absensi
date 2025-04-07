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
import 'package:axata_absensi/pages/lokasi/bindings/lokasi_binding.dart';
import 'package:axata_absensi/pages/lokasi/views/lokasi_view.dart';
import 'package:axata_absensi/pages/lupapassword/bindings/lupapassword_binding.dart';
import 'package:axata_absensi/pages/lupapassword/views/lupapassword_view.dart';
import 'package:axata_absensi/pages/paket/bindings/paket_binding.dart';
import 'package:axata_absensi/pages/paket/views/paket_view.dart';
import 'package:axata_absensi/pages/pegawai/bindings/pegawai_binding.dart';
import 'package:axata_absensi/pages/pegawai/views/pegawai_view.dart';
import 'package:axata_absensi/pages/profile/bindings/profile_binding.dart';
import 'package:axata_absensi/pages/profile/views/profile_view.dart';
import 'package:axata_absensi/pages/register/bindings/register_binding.dart';
import 'package:axata_absensi/pages/register/views/register_view.dart';
import 'package:axata_absensi/pages/registrasi/bindings/registrasi_binding.dart';
import 'package:axata_absensi/pages/registrasi/views/registrasi_view.dart';
import 'package:axata_absensi/pages/setting/bindings/setting_binding.dart';
import 'package:axata_absensi/pages/setting/views/setting_view.dart';
import 'package:axata_absensi/pages/shift/bindings/shift_binding.dart';
import 'package:axata_absensi/pages/shift/views/shift_view.dart';
import 'package:axata_absensi/pages/smileface/bindings/smileface_binding.dart';
import 'package:axata_absensi/pages/smileface/views/smileface_view.dart';
import 'package:axata_absensi/pages/splash/bindings/splash_binding.dart';
import 'package:axata_absensi/pages/splash/views/splash_view.dart';
import 'package:axata_absensi/pages/tenant/bindings/tenant_binding.dart';
import 'package:axata_absensi/pages/tenant/views/tenant_view.dart';
import 'package:axata_absensi/pages/test/bindings/test_binding.dart';
import 'package:axata_absensi/pages/test/views/test_view.dart';
import 'package:axata_absensi/pages/welcome/bindings/welcome_binding.dart';
import 'package:axata_absensi/pages/welcome/views/welcome_view.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

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
      name: _Paths.WELCOME,
      page: () => WelcomeView(),
      binding: WelcomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.TEST,
      page: () => ShowCaseWidget(
        onStart: (index, key) {},
        onComplete: (index, key) {},
        blurValue: 1,
        autoPlayDelay: const Duration(seconds: 3),
        builder: (context) => TestView(),
      ),
      binding: TestBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => ShowCaseWidget(builder: (context) => LoginView()),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: _Paths.LUPAPASSWORD,
      page: () => LupaPasswordView(),
      binding: LupaPasswordBinding(),
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
      name: _Paths.LOKASI,
      page: () => LokasiView(),
      binding: LokasiBinding(),
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
    GetPage(
      name: _Paths.TENANT,
      page: () => TenantView(),
      binding: TenantBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: _Paths.PAKET,
      page: () => PaketView(),
      binding: PaketBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: _Paths.REGISTRASI,
      page: () => RegistrasiView(),
      binding: RegistrasiBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
