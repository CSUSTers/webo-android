import 'package:dio/dio.dart';
import 'package:webo/http/token_interceptor.dart';

//Dio factory
abstract class DioWithToken {
  static final _dio = Dio()
    ..interceptors.add(LogInterceptor())
    ..interceptors.add(TokenInterceptor());

  static Dio getInstance() {
    return _dio;
  }

  static Dio get client {
    return _dio;
  }
}
