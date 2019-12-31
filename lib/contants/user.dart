import 'dart:io';

import 'package:webo/contants/http_code.dart';
import 'package:webo/contants/values.dart';
import 'package:webo/contants/webo_url.dart';
import 'package:webo/http/dio_with_token.dart';

class User {
  final int id;
  final String username;
  final String nickname;
  final String avatar;
  final String email;
  final String bio;

  User({this.id,
      this.username: Strings.notLoginUser,
      this.nickname: Strings.notLoginUser,
      this.avatar: Strings.defaultAvatarPath,
      this.email: Strings.notLoginEmail,
      this.bio: ''});

  static Future<User> fromHttp(int id) async {
    final http = DioWithToken.client;
    final resp = await http.get(WebOURL.user, queryParameters: {
      'id': id
    });

    if (resp.statusCode != 200 ||
        resp.data['code'] != WebOHttpCode.SUCCESS) {
      throw HttpException('网络请求错误');
    }

    final data = resp.data['data']['personal'];
    return User(
      id: id,
      username: data['username'],
      nickname: data['nickname'],
      email: data['email'],
      bio: data['bio']
    );
  }
}
