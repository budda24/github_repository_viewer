import 'package:dio/dio.dart';

extension DioErrorX on DioException {
  bool get isNoInternetConnection {
    return type == DioExceptionType.connectionError;
  }
}
