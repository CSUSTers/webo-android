
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webo/contants/http_code.dart';
import 'package:webo/contants/webo_url.dart';
import 'package:webo/http/dio_with_token.dart';

class TokenInterceptor extends InterceptorsWrapper {

  @override
  Future onRequest(RequestOptions options) async {
    //auto load token in request
    if(!options.headers.containsKey('Authorization')) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey('token')) {
        options.headers['Authorization'] = prefs.getString('token');
      }
    }
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) async {
    //TODO handle token expired
    if(response.statusCode == 200) {
      if (response.data['code'] == WebOHttpCode.TOKEN_EXPIRED) {
        var req = response.request;
        Dio dio = DioWithToken.getInstance();
        dio.lock();
        req.headers['Authorization'] = await _refreshToken();
        dio.unlock();
        response = await dio.request(req.path,
          data: req.data,
          queryParameters: req.queryParameters,
          options: req
        );
      }
    }
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    print(err.toString());
    return super.onError(err);
  }


  Future<String> _refreshToken() async {
    Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('refreshToken')) {
      dio.options.headers['Authorization'] = prefs.getString('refreshToken');
    }
    Response resp = await dio.post(WebOURL.refresh);
    if (resp.statusCode == 200) {
      if (resp.data['code'] == WebOHttpCode.SUCCESS) {
        dynamic data = resp.data['data'];
        await SharedPreferences.getInstance()
          ..setString("token", data['token'])
          ..setString("refreshToken", data['refreshToken']);
      }
    }
    return prefs.getString('refreshToken');
  }


}