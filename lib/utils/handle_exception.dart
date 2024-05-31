import 'dart:io';

class ExceptionHandler {
  String getErrorMessage(dynamic exception) {
    if (exception is SocketException) {
      return exception.message;
    } else if (exception is HttpException) {
      return 'Terjadi masalah saat menghubungi server: $exception';
    }
    return '$exception';
  }
}
