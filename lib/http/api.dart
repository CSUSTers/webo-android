import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webo/contants/http_code.dart';
import 'package:webo/contants/user.dart';
import 'package:webo/contants/webo_url.dart';
import 'package:webo/http/dio_with_token.dart';

abstract class Api {

  static final _dio = DioWithToken.client;
  static const _followPageSize = 20;

  static const POST = "POST";
  static const GET = "GET";

  static Future<dynamic> call(String url, {dynamic data, String method = POST}) async {
    Response resp;
    if(method == POST) {
      resp = await _dio.post(url, data: data);
    } else {
      resp = await _dio.get(url, queryParameters: data);
    }
    if (resp.statusCode == 200) {
      if (resp.data['code'] == WebOHttpCode.SUCCESS) {
        var data = resp.data['data'];
        return data;
      } else if (resp.data['code'] == WebOHttpCode.SERVER_ERROR) {
        Fluttertoast.showToast(
            msg: "Error: " + resp.data['data']['exceptionMessage']);
      }
    }
    return null;
  }

  //呐呐，大五哥哥说这个不行呢~
  static Future<List<User>> getFollowingList(int id, int page) async {
    List<User> list = [];
    var data = await call(WebOURL.followings, data: {
      "id": id,
      "page": page,
      "size": _followPageSize
    }, method: "GET");
    for (var u in data) {
      list.add(User.fromMap(u));
    }
    return list;
  }


  static Future<List<User>> getFollowerList(int id, int page) async {
    List<User> list = [];
    var data = await call(WebOURL.followers, data: {
      "id": id,
      "page": page,
      "size": _followPageSize
    }, method: "GET");
    for (var u in data) {
      list.add(User.fromMap(u));
    }
    return list;
  }


  static Future<bool> follow(int id) async {
    var data = await call(WebOURL.follow, data: {
      "to": id
    });
    return data != null;
  }


}
