// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

import 'package:axata_absensi/components/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class TestController extends GetxController {
  RxString latitude = ''.obs;
  RxString longitude = ''.obs;
  RxBool isMockLocation = true.obs;

  RxBool isLoading = false.obs;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    getInit();
  }

  getInit() async {
    try {
      await requestLocationPermission();
    } catch (e) {
      CustomToast.errorToast('Error', '$e');
    }
  }

  refreshMock(BuildContext context) async {
    isMockLocation.value = await FlutterJailbreakDetection.developerMode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fake Location Detected'),
          content: Text(
              'The user is${isMockLocation.value ? 'YES' : ' NOT'} using a fake location.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  requestLocationPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    print('permissions: $permission');
  }
}
