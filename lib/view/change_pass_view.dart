import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webo/contants/http_code.dart';
import 'package:webo/contants/values.dart';
import 'package:webo/contants/webo_url.dart';
import 'package:webo/http/dio_with_token.dart';
import 'package:webo/util/encry.dart';
import 'package:webo/util/prefs.dart';

class ChangePassPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _originController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _new2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Form form = Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.text,
            maxLength: 64,
            controller: _originController,
            obscureText: true,
            decoration: InputDecoration(labelText: Strings.originPass),
            validator: (value) {
              if (value.length == 0) return '原密码不能为空';
              return null;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            maxLength: 64,
            controller: _newController,
            obscureText: true,
            decoration: InputDecoration(labelText: Strings.newPass),
            validator: (value) {
              if (value.length == 0) return '请填写新密码';
              return null;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            maxLength: 64,
            controller: _new2Controller,
            obscureText: true,
            decoration: InputDecoration(labelText: Strings.ackNewPass),
            validator: (value) {
              if (value.length == 0) return '请确认新密码';
              if (value != _newController.text) return '两次输入的密码不一致';
              return null;
            },
          ),
          Padding(padding: const EdgeInsets.symmetric(vertical: 16.0)),
          MaterialButton(
              minWidth: 256.0,
              height: 42.0,
              child: const Text(Strings.changePass),
              color: Colors.lightBlue,
              textColor: Colors.white,
              onPressed: () => _changePass(context))
        ],
      ),
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: const Text(Strings.changePass),
          leading: BackButton(),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(32.0),
//          margin: const EdgeInsets.only(bottom: 32.0),
            child: form,
          ),
        ));
  }

  void _changePass(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      final String origin = MD5.md5(_originController.text);
      final String newPass = MD5.md5(_newController.text);
      Response resp = await DioWithToken.client.post(WebOURL.userChangePassword,
          data: {"origin": origin, "changed": newPass});
      if (resp.statusCode == 200) {
        print(resp.data);
        if (resp.data['code'] == WebOHttpCode.SUCCESS) {
          var data = resp.data['data'];
          var success = await _save(data);
          if (success) {
            Fluttertoast.showToast(msg: "修改成功");
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
    }
  }

  Future<bool> _save(dynamic data) async {
    var p = Prefs.instance;
    var success = await Future.wait([
      p.setString("token", data['token']),
      p.setString("refreshToken", data['refreshToken'])
    ]).then((xs) => xs.reduce((x, y) => x && y));
    return success;
  }
}
