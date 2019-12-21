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

  final buttonWidth = 108.0, buttonHeight = 42.0;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(Strings.login),
        ),
        body: SingleChildScrollView(
          child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(32.0),
              margin: const EdgeInsets.only(bottom: 52),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset("images/logo.PNG"),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        maxLength: 12,
                        controller: _usernameController,
                        decoration: const InputDecoration(
                            labelText: Strings.userName,
                            prefixIcon: Icon(Icons.person)),
                        validator: (value) {
                          if (value.isEmpty) {
                            return '用户名不能为空';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        maxLength: 32,
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: Strings.password,
                            prefixIcon: Icon(Icons.lock)),
                        validator: (value) {
                          if (value.isEmpty) {
                            return '密码不能为空';
                          }
                          return null;
                        },
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 64.0),
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ButtonTheme(
                                    minWidth: buttonWidth,
                                    height: buttonHeight,
                                    child: RaisedButton(
                                      child: Text(Strings.registered),
                                      color: Colors.white,
                                      textColor: Colors.lightBlue,
                                      onPressed: () {
                                        //TODO: turn to register page
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
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
                              ),
                      )
                    ],
                  ))),
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
            Fluttertoast.showToast(msg: "Error: " + resp.data['data']['exceptionMessage']);
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
}
