import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webo/contants/http_code.dart';
import 'package:webo/contants/user.dart';
import 'package:webo/contants/webo_url.dart';
import 'package:webo/rom/user_provider.dart';
import 'package:webo/util/encry.dart';
import 'package:webo/view/main_view.dart';
import 'package:webo/widget/nothing.dart';

import '../contants/values.dart';

class WebOLoginPage extends StatefulWidget {
  @override
  _WebOLoginPageState createState() => _WebOLoginPageState();
}

class _WebOLoginPageState extends State<WebOLoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final buttonWidth = 108.0, buttonHeight = 42.0;

  bool isLoading = false;

  static const LOGIN_MODE = 1;
  static const REGISTER_MODE = 0;
  int mode = LOGIN_MODE;

  BuildContext _buildContext;

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    Row loginButtonArea = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MaterialButton(
          minWidth: buttonWidth,
          height: buttonHeight,
          child: const Text(Strings.registerSplit),
          color: Colors.white,
          textColor: Colors.lightBlue,
          onPressed: () => setState(() => mode = REGISTER_MODE),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
        ),
        MaterialButton(
          minWidth: buttonWidth,
          height: buttonHeight,
          child: const Text(Strings.loginSplit),
          color: Colors.lightBlue,
          textColor: Colors.white,
          onPressed: () => _login(),
        )
      ],
    );

    Center regButtonArea = Center(
        child: MaterialButton(
            minWidth: buttonWidth,
            height: buttonHeight,
            child: const Text(Strings.registerSplit),
            color: Colors.lightBlue,
            textColor: Colors.white,
            onPressed: () => _register()));

    Container buttonArea = Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 64.0),
      child: isLoading
          ? const Center(
              child: const CircularProgressIndicator(),
            )
          : mode == LOGIN_MODE ? loginButtonArea : regButtonArea,
    );

    Form form = Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset("images/logo.PNG"),
            const Padding(
              padding: const EdgeInsets.only(top: 32.0),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              maxLength: 16,
              controller: _usernameController,
              decoration: const InputDecoration(
                  labelText: Strings.userName, prefixIcon: Icon(Icons.person)),
              validator: (value) {
                if (value.isEmpty) {
                  return '用户名不能为空';
                }
                return null;
              },
            ),
            mode == REGISTER_MODE
                ? TextFormField(
                    keyboardType: TextInputType.text,
                    maxLength: 32,
                    controller: _nicknameController,
                    decoration: const InputDecoration(
                        labelText: Strings.nickname,
                        prefixIcon: Icon(Icons.lightbulb_outline)),
                    validator: (value) {
                      return null;
                    },
                  )
                : const Nothing(),
            mode == REGISTER_MODE
                ? TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 128,
                    controller: _emailController,
                    decoration: const InputDecoration(
                        labelText: Strings.email,
                        prefixIcon: Icon(Icons.email)),
                    validator: (value) {
                      return null;
                    },
                  )
                : const Nothing(),
            TextFormField(
              keyboardType: TextInputType.text,
              maxLength: 64,
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: Strings.password, prefixIcon: Icon(Icons.lock)),
              validator: (value) {
                if (value.isEmpty) {
                  return '密码不能为空';
                }
                return null;
              },
            ),
            mode == REGISTER_MODE
                ? TextFormField(
                    keyboardType: TextInputType.text,
                    maxLength: 64,
                    controller: _password2Controller,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: Strings.ackPassword,
                        prefixIcon: Icon(Icons.lock)),
                    validator: (value) {
                      if (value.isEmpty) return '请再次输入密码';
                      if (value != _passwordController.text)
                        return '两次输入的密码不一致';
                      return null;
                    },
                  )
                : const Nothing(),
            buttonArea
          ],
        ));

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          leading: IconButton(
              icon: Icon(mode == LOGIN_MODE ? Icons.close : Icons.arrow_back,
                  color: Colors.white),
              onPressed: () {
                if (mode == LOGIN_MODE)
                  Navigator.pop(context);
                else
                  setState(() => mode = LOGIN_MODE);
              }),
          title: Text(mode == LOGIN_MODE ? Strings.login : Strings.register),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(32.0),
            margin: const EdgeInsets.only(bottom: 52),
            child: form,
          ),
        ));
  }

  void _login() async {
    if (_formKey.currentState.validate()) {
      final String username = _usernameController.text.trim();
      final String pass = MD5.md5(_passwordController.text);
      setState(() => isLoading = true);
      try {
        Response resp = await Dio().post(WebOURL.login,
            data: {"username": username, "password": pass});
        print(resp.data.toString());
        if (resp.statusCode == 200) {
          if (resp.data['code'] == WebOHttpCode.SUCCESS) {
            var data = resp.data['data'];
            var success = await _save(data);
            if (success) {
              Fluttertoast.showToast(msg: "登录成功");
              Navigator.pop(context);
            } else
              Fluttertoast.showToast(msg: '用户信息保存失败');
          } else if (resp.data['code'] == WebOHttpCode.SERVER_ERROR) {
            Fluttertoast.showToast(
                msg: "Error: " + resp.data['data']['exceptionMessage']);
          }
        } else {
          Fluttertoast.showToast(msg: "Error: " + resp.statusCode.toString());
        }
      } on Exception catch (e) {
        print(e);
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void _register() async {
    if (_formKey.currentState.validate()) {
      final String username = _usernameController.text;
      final String pass = MD5.md5(_passwordController.text);
      final String nickname = _nicknameController.text;
      final String email = _emailController.text;
      setState(() => isLoading = true);
      try {
        Response resp = await Dio().post(WebOURL.register, data: {
          "username": username,
          "password": pass,
          "nickname": nickname,
          "email": email
        });
        print(resp.data.toString());
        if (resp.statusCode == 200) {
          if (resp.data['code'] == WebOHttpCode.SUCCESS) {
            var data = resp.data['data'];
            var success = await _save(data);
            if (success) {
              Fluttertoast.showToast(msg: "注册成功");
              Navigator.pop(context);
            } else
              Fluttertoast.showToast(msg: '用户信息保存失败');
          } else if (resp.data['code'] == WebOHttpCode.SERVER_ERROR) {
            Fluttertoast.showToast(
                msg: "Error: " + resp.data['data']['exceptionMessage']);
          }
        } else {
          Fluttertoast.showToast(msg: "Error: " + resp.statusCode.toString());
        }
      } on Exception catch (e) {
        print(e);
      } finally {
        setState(() => isLoading = false);
      }
    }
  }


  Future<bool> _save(dynamic data) async {
    var user = User(
        id: data['userId'],
        username: data['username'],
        nickname: data['nickname'],
        email: data['email']
    );

    var p = await SharedPreferences.getInstance();
    var success = await Future.wait([
      p.setString("token", data['token']),
      p.setString("refreshToken", data['refreshToken']),
      p.setInt("userId", user.id),
      p.setString("username", user.username),
      p.setString("nickname", user.nickname),
      p.setString("email", user.email),
    ]).then((xs) => xs.reduce((x, y) => x && y));

    final userProvider = Provider.of<UserProvider>(_buildContext, listen: false);
    userProvider.setUser(user);
    return success;
  }

}
