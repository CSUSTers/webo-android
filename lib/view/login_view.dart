import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webo/webo_url.dart';

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
        )
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32.0),
        margin: const EdgeInsets.only(top: -54.0),
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
                    labelText: '用户名',
                    prefixIcon: Icon(Icons.person)
                ),
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
                    labelText: '密码',
                    prefixIcon: Icon(Icons.lock)
                ),
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
                          child: Text('注 册'),
                          color: Colors.white,
                          textColor: Colors.lightBlue,
                          onPressed: () {
                            //TODO: turn to register page
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                      ),
                      ButtonTheme(
                        minWidth: buttonWidth,
                        height: buttonHeight,
                        child: RaisedButton(
                          child: Text('登 录'),
                          color: Colors.lightBlue,
                          textColor: Colors.white,
                          onPressed: () => _login(),
                        )
                      )
                    ],
                  ),
              )
          ],
        ))),
    );
  }

  void _login() async {
    if(_formKey.currentState.validate()) {
      final String username = _usernameController.text;
      final String pass = _passwordController.text;
      setState(() {
        isLoading = true;
      });
      try {
        Response resp = await Dio().post(WebOURL.login, data: {
          "username": username,
          "password": pass
        });
        print(resp.data.toString());
        if (resp.statusCode == 200) {
          if (resp.data['code'] == 0) {
            dynamic data = resp.data['data'];
            var prefs = await SharedPreferences.getInstance()
              ..setString("token", data['token'])
              ..setString("refreshToken", data['refreshToken'])
              ..setInt("userId", data['userId'])
              ..setString("username", data['username'])
              ..setString("nickname", data['nickname']);
            Fluttertoast.showToast(msg: "登录成功");
          } else if (resp.data['code'] == 9) {
            Fluttertoast.showToast(msg: "Error: " + resp.data['data']['exceptionMessage']);
          }
        } else {
          Fluttertoast.showToast(msg: "Error: " + resp.statusCode.toString());
        }
      } on Exception catch (e) {
        print(e);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


}
