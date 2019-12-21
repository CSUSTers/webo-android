import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webo/contants/http_code.dart';
import 'package:webo/contants/webo_url.dart';

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

  final buttonWidth = 108.0, buttonHeight = 42.0;

  bool isLoading = false;

  static const LOGIN_MODE = 1;
  static const REGISTER_MODE = 0;
  int mode = LOGIN_MODE;

  @override
  Widget build(BuildContext context) {
    Row loginButtonArea = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ButtonTheme(
          minWidth: buttonWidth,
          height: buttonHeight,
          child: RaisedButton(
            child: Text(Strings.register),
            color: Colors.white,
            textColor: Colors.lightBlue,
            onPressed: () => setState(() => mode = REGISTER_MODE),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
        ),
        ButtonTheme(
            minWidth: buttonWidth,
            height: buttonHeight,
            child: RaisedButton(
              child: Text(Strings.login),
              color: Colors.lightBlue,
              textColor: Colors.white,
              onPressed: () => _login(),
            ))
      ],
    );

    Center regButtonArea = Center(
        child: ButtonTheme(
            minWidth: buttonWidth,
            height: buttonHeight,
            child: RaisedButton(
              child: Text(Strings.register),
              color: Colors.lightBlue,
              textColor: Colors.white,
              onPressed: () => _register(),
            )));

    Container buttonArea = Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 64.0),
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
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
              maxLength: 12,
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
                    maxLength: 16,
                    controller: _nicknameController,
                    decoration: const InputDecoration(
                        labelText: Strings.nickname,
                        prefixIcon: Icon(Icons.lightbulb_outline)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return '请填写昵称';
                      }
                      return null;
                    },
                  )
                : const Padding(
                    padding: const EdgeInsets.all(0),
                  ),
            TextFormField(
              keyboardType: TextInputType.text,
              maxLength: 32,
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
                    maxLength: 32,
                    controller: _password2Controller,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: Strings.ack_password,
                        prefixIcon: Icon(Icons.lock)),
                    validator: (value) {
                      if (value.isEmpty) return '请再次输入密码';
                      if (value == _passwordController.text)
                        return '两次输入的密码不一致';
                      return null;
                    },
                  )
                : const Padding(
                    padding: const EdgeInsets.all(0),
                  ),
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
      final String username = _usernameController.text;
      final String pass = _passwordController.text;
      setState(() => isLoading = true);
      try {
        Response resp = await Dio().post(WebOURL.login,
            data: {"username": username, "password": pass});
        print(resp.data.toString());
        if (resp.statusCode == 200) {
          if (resp.data['code'] == WebOHttpCode.SUCCESS) {
            var data = resp.data['data'];
            var p = await SharedPreferences.getInstance();
            var success = await Future.wait([
              p.setString("token", data['token']),
              p.setString("refreshToken", data['refreshToken']),
              p.setInt("userId", data['userId']),
              p.setString("username", data['username']),
              p.setString("nickname", data['nickname'])
            ]).then((xs) => xs.reduce((x, y) => x && y));
            if (success)
              Fluttertoast.showToast(msg: "登录成功");
            else
              Fluttertoast.showToast(msg: '用户信息写入失败');
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
        Navigator.pop(context);
      }
    }
  }

  void _register() async {}
}
