
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:webo/contants/http_code.dart';
import 'package:webo/contants/user.dart';
import 'package:webo/contants/values.dart';
import 'package:webo/contants/webo_url.dart';
import 'package:webo/http/dio_with_token.dart';
import 'package:webo/rom/user_provider.dart';
import 'package:webo/util/prefs.dart';

class AccountEditView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    User user = ModalRoute.of(context).settings.arguments;
    _nicknameController.text = user.nickname;
    _emailController.text = user.email;
    _bioController.text = user.bio;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(Strings.personInfo),
        leading: const BackButton(),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save_alt),
            tooltip: Strings.save,
            onPressed: () => _update(context, user),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.text,
              maxLength: 16,
              controller: _nicknameController,
              decoration: const InputDecoration(
                  labelText: Strings.nickname, prefixIcon: Icon(Icons.lightbulb_outline)),
              validator: (value) {
                if (value.isEmpty) {
                  return '昵称不能为空';
                }
                return null;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              maxLength: 128,
              controller: _emailController,
              decoration: const InputDecoration(
                  labelText: Strings.email, prefixIcon: Icon(Icons.email)),
              validator: (value) {
                if (value.isEmpty) {
                  return '邮箱不能为空';
                }
                return null;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              maxLength: 32,
              controller: _bioController,
              decoration: const InputDecoration(
                  labelText: Strings.bio, prefixIcon: Icon(Icons.accessibility_new)),
              validator: (value) {
                if (value.isEmpty) {
                  return '个性签名不能为空';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _update(BuildContext context, User user) async {
    if(_formKey.currentState.validate()) {
      final nickname = _nicknameController.text;
      final email = _emailController.text;
      final bio = _bioController.text;
      Response resp = await DioWithToken.client.post(WebOURL.userUpdate, data: {
        "nickname": nickname,
        "email": email,
        "bio": bio
      });
      if (resp.statusCode == 200) {
        if (resp.data['code'] == WebOHttpCode.SUCCESS) {
          var data = resp.data['data'];
          print(data);
          user = User(
              id: user.id,
              username: user.username,
              nickname: nickname,
              email: email,
              bio: bio
          );
          var success = await _save(context, user);
          if (success) {
            Fluttertoast.showToast(msg: "成功");
            Navigator.pop(context, user);
          } else
            Fluttertoast.showToast(msg: '用户信息保存失败');
        } else if (resp.data['code'] == WebOHttpCode.SERVER_ERROR) {
          Fluttertoast.showToast(
              msg: "Error: " + resp.data['data']['exceptionMessage']);
        }
      } else {
        Fluttertoast.showToast(msg: "Error: " + resp.statusCode.toString());
      }
    }
  }


  Future<bool> _save(BuildContext context, User user) async {
    var p = Prefs.instance;
    var success = await Future.wait([
      p.setString("nickname", user.nickname),
      p.setString("email", user.email),
      p.setString("bio", user.bio)
    ]).then((xs) => xs.reduce((x, y) => x && y));

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUser(user);
    return success;
  }

}