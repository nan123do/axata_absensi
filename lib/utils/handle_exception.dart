import 'dart:io';

class ExceptionHandler {
  String getErrorMessage(dynamic exception) {
    if (exception is SocketException) {
      return 'Socket error saat menghubungi server';
    } else if (exception is HttpException) {
      return 'Terjadi masalah saat menghubungi server: $exception';
    }
    return 'Terjadi kesalahan: $exception';
  }
}
