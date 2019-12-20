
import 'package:dio/dio.dart';
import 'package:webo/http/token_interceptor.dart';

//Dio factory
abstract class DioWithToken extends Dio {

  factory DioWithToken() => getInstance();

  static DioWithToken _dio;

  static DioWithToken getInstance() {
    if (_dio == null) {
      _dio = DioWithToken();
      _dio.interceptors.add(LogInterceptor());
      _dio.interceptors.add(TokenInterceptor());
    }
    return _dio;
  }

}