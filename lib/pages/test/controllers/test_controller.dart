import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class TestController extends GetxController {
  final GlobalKey one = GlobalKey();
  final GlobalKey two = GlobalKey();
  final GlobalKey three = GlobalKey();
  final GlobalKey four = GlobalKey();
  final GlobalKey five = GlobalKey();

  final scrollController = ScrollController();

  TextEditingController usernameC = TextEditingController();
  TextEditingController passC = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isObsecure = true.obs;

  // GlobalKey untuk showcase
  GlobalKey usernameKey = GlobalKey();
  GlobalKey passwordKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getInit();
  }

  getInit() {
    isLoading.value = false;
  }

  void triggerShowCase(BuildContext context) {
    ShowCaseWidget.of(context).startShowCase([one, two]);
  }
}
