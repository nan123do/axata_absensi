import 'dart:async';

import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/pages/checkin/controllers/checkin_controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class SmileFaceController extends GetxController {
  final checkInController = Get.find<CheckInController>();
  RxBool isLoading = false.obs;
  RxBool isDetecting = false.obs;
  RxBool isSmiling = false.obs;
  RxBool isToastShowing = false.obs;
  RxString tingkatSenyum = '0%'.obs;
  CameraController? cameraController;
  final FaceDetector faceDetector =
      GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    minFaceSize: 0.3,
    performanceMode: FaceDetectorMode.accurate,
    enableClassification: true,
  ));

  List<CameraDescription> cameras = [];
  List<Face> faces = [];
  Size imageSize = Size.zero;
  Timer? smileTimer;
  RxString timerText = '0'.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getInit();
  }

  @override
  void dispose() {
    cameraController!.dispose();
    faceDetector.close();
    super.dispose();
  }

  getInit() async {
    try {
      cameras = await availableCameras();
      final frontFacingCamera = findFrontFacingCamera(cameras);
      // final firstCamera = cameras.first;
      // final camera = cameras[0];
      cameraController = CameraController(
        frontFacingCamera!,
        ResolutionPreset.max,
      );
      await cameraController!.initialize();
      cameraController!.startImageStream(_processCameraImage);
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  CameraDescription? findFrontFacingCamera(List<CameraDescription> cameras) {
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    return frontCamera;
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    // get image rotation
    final camera = findFrontFacingCamera(cameras);
    final sensorOrientation = camera!.sensorOrientation;
    InputImageRotation? rotation;
    var rotationCompensation =
        _orientations[cameraController!.value.deviceOrientation];
    if (rotationCompensation == null) return null;
    if (camera.lensDirection == CameraLensDirection.front) {
      // front-facing
      rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
    } else {
      // back-facing
      rotationCompensation =
          (sensorOrientation - rotationCompensation + 360) % 360;
    }
    rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    if (rotation == null) return null;

    // Konversi YUV_420_888 ke NV21 jika diperlukan
    final bytes = (image.format.group == ImageFormatGroup.nv21)
        ? image.planes.first.bytes
        : convertYUV420ToNV21(image);

    // get image format
    final format = (image.format.group == ImageFormatGroup.yuv420)
        ? InputImageFormat.nv21
        : InputImageFormatValue.fromRawValue(image.format.raw);

    if (format == null) return null;

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  Uint8List convertYUV420ToNV21(CameraImage image) {
    final yBuffer = image.planes[0].bytes;
    final uBuffer = image.planes[1].bytes;
    final vBuffer = image.planes[2].bytes;
    final ySize = yBuffer.length;
    final uvSize = uBuffer.length + vBuffer.length;

    final nv21 = Uint8List(ySize + uvSize);

    // Copy Y data
    nv21.setRange(0, ySize, yBuffer);

    // Interleave U and V data
    for (int i = 0; i < uvSize; i += 2) {
      nv21[ySize + i] = vBuffer[i ~/ 2];
      nv21[ySize + i + 1] = uBuffer[i ~/ 2];
    }

    return nv21;
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (isDetecting.value) return;
    isDetecting.value = true;
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      // final bytes = allBytes.done().buffer.asUint8List();

      // Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
      // final frontFacingCamera = findFrontFacingCamera(cameras);
      // Gunakan metode Anda sendiri untuk mendapatkan rotasi gambar
      // final InputImageRotation imageRotation = rotationIntToImageRotation(
      //   frontFacingCamera!.sensorOrientation,
      // );

      // const InputImageFormat inputImageFormat = InputImageFormat.nv21;

      // final planeData = image.planes.map(
      //   (Plane plane) {
      //     return InputImagePlaneMetadata(
      //       bytesPerRow: plane.bytesPerRow,
      //       height: plane.height,
      //       width: plane.width,
      //     );
      //   },
      // ).toList();

      final inputImageData = _inputImageFromCameraImage(image);
      if (inputImageData == null) {
        return;
      }

      // final inputImage =
      //     InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

      final faces = await faceDetector.processImage(inputImageData);

      this.faces = faces;
      imageSize = Size(image.width.toDouble(), image.height.toDouble());

      for (final face in faces) {
        final smilingProbability = face.smilingProbability;
        if (smilingProbability != null) {
          String persen = '${(smilingProbability * 100).toStringAsFixed(2)}%';
          tingkatSenyum.value = persen;
          if (smilingProbability > 0.98 && !isSmiling.value) {
            isSmiling.value = true;

            // Mulai atau perbarui timer saat tersenyum
            if (smileTimer == null || !smileTimer!.isActive) {
              int timerCount = 3;
              smileTimer =
                  Timer.periodic(const Duration(seconds: 1), (timer) async {
                timerCount--;
                timerText.value = '$timerCount';
                if (timerCount == 0) {
                  timer.cancel();
                  await checkIn();
                }
              });
            }
          } else if (smilingProbability <= 0.98 && isSmiling.value) {
            isSmiling.value = false;
            // Reset timer jika tidak tersenyum
            timerText.value = '0';
            smileTimer?.cancel();
          }
        }
      }
    } catch (e) {
      CustomToast.errorToast("Error", "Ada error : $e");
    } finally {
      isDetecting.value = false;
    }
  }

  InputImageRotation rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg; // Default case
    }
  }

  Future<void> checkIn() async {
    isLoading.value = false;
    try {
      // Matikan  detektor wajah di sini setelah berpindah halaman
      faceDetector.close();
      isSmiling.value = false;

      await checkInController.simpanCheckIn();

      // Matikan kamera wajah di sini setelah berpindah halaman
      if (cameraController != null && cameraController!.value.isInitialized) {
        await cameraController!.dispose();
      }
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
