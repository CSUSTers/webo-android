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
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.text,
              maxLength: 12,
              style: TextStyle(fontSize: 16.0),
              controller: _usernameController,
              decoration: const InputDecoration(
//                  hintText: 'username',
                  labelText: 'UserName',
                  prefixIcon: Icon(Icons.person)
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'username is empty';
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
//                  hintText: 'password',
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock)
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'password is empty';
                }
                return null;
              },
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RaisedButton(
                    child: Text('Login'),
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    onPressed: () async {
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
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.setString("token", data['token']);
                              await prefs.setString("refreshToken", data['refreshToken']);
                              await prefs.setInt("userId", data['userId']);
                              await prefs.setString("username", data['username']);
                              await prefs.setString("nickname", data['nickname']);
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
                    },
                  )
          ],
        ))),
    );
  }
}
