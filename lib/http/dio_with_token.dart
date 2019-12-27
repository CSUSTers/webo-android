
import 'package:dio/dio.dart';
import 'package:webo/http/token_interceptor.dart';

//Dio factory
abstract class DioWithToken {

  static Dio _dio;

  static Dio getInstance() {
    if (_dio == null) {
      _dio = Dio();
      _dio.interceptors.add(LogInterceptor());
      _dio.interceptors.add(TokenInterceptor());
    }
    return _dio;
  }

  static Dio get client {
    return getInstance();
  }
}