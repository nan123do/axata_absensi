// ignore_for_file: avoid_print

import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

class LocationHelper {
  static const platform = MethodChannel('com.axata.absensi/location');
  static Future<bool> isUsingMockLocation() async {
    try {
      bool isMockLocation = await FlutterJailbreakDetection.developerMode;
      print("Is mock location active? $isMockLocation");
      return isMockLocation;
    } catch (e) {
      print("Failed to get mock location: $e");
      return false;
    }
  }
}
