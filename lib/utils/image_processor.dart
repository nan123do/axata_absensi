import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as imglib;

class ImageProcessor {
  // Menggabungkan semua byte planes dari CameraImage menjadi Uint8List
  Uint8List concatenatePlanes(List<Plane> planes) {
    WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  // Konversi YUV ke RGB menggunakan library image
  Uint8List convertYUV420toImage(CameraImage cameraImage) {
    final int width = cameraImage.width;
    final int height = cameraImage.height;
    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final imglib.Image img = imglib.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex = uvRowStride * (y ~/ 2) + uvPixelStride * (x ~/ 2);
        final int index = y * width + x;

        final int yValue = cameraImage.planes[0].bytes[index];
        final int uValue = cameraImage.planes[1].bytes[uvIndex];
        final int vValue = cameraImage.planes[2].bytes[uvIndex];

        final int r =
            (yValue + (1.370705 * (vValue - 128))).clamp(0, 255).toInt();
        final int g =
            (yValue - (0.337633 * (uValue - 128)) - (0.698001 * (vValue - 128)))
                .clamp(0, 255)
                .toInt();
        final int b =
            (yValue + (1.732446 * (uValue - 128))).clamp(0, 255).toInt();

        img.setPixelRgba(x, y, r, g, b, 255);
      }
    }

    return Uint8List.fromList(imglib.encodeJpg(img));
  }

  // Menyimpan byte data ke file dalam sistem file lokal
  Future<File> saveBytesToFile(Uint8List bytes, String filename) async {
    String dir = (await getTemporaryDirectory()).path;
    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  // Membuat XFile dari byte data
  Future<XFile> createXFileFromBytes(Uint8List bytes, String filename) async {
    File file = await saveBytesToFile(bytes, filename);
    XFile xFile = XFile(file.path);
    return xFile;
  }

  // Fungsi utilitas untuk mengambil CameraImage, mengonversinya menjadi format gambar, menyimpannya sebagai file, dan mengubahnya menjadi XFile
  Future<XFile> saveImageFromCamera(CameraImage image, String filename) async {
    Uint8List imageBytes = convertYUV420toImage(image);
    // Decode Uint8List menjadi gambar menggunakan package image
    imglib.Image? decodedImage = imglib.decodeImage(imageBytes);

    // Lakukan rotasi gambar 90 derajat ke kanan
    if (decodedImage != null) {
      imglib.Image rotatedImage = imglib.copyRotate(decodedImage, angle: 90);

      // Encode ulang gambar yang sudah dirotasi ke dalam format byte
      Uint8List rotatedImageBytes =
          Uint8List.fromList(imglib.encodeJpg(rotatedImage));

      // Simpan gambar yang telah dirotasi ke dalam file
      File file = await saveBytesToFile(rotatedImageBytes, filename);

      // Kembalikan file yang disimpan sebagai XFile
      XFile xFile = XFile(file.path);
      return xFile;
    } else {
      throw Exception('Gagal memproses gambar');
    }
  }
}
