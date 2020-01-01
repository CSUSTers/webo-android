import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webo/contants/http_code.dart';
import 'package:webo/contants/values.dart';
import 'package:webo/contants/webo_url.dart';
import 'package:webo/http/dio_with_token.dart';

class WebOCreatePage extends StatefulWidget {

  @override
  _WebOCreatePageState createState() => _WebOCreatePageState();

}

class _WebOCreatePageState extends State<WebOCreatePage> {

  final TextEditingController _weboTextController = TextEditingController();
  final _weboMaxLength = 320;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.lightBlue,
            leading: const BackButton(),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.file_upload),
                tooltip: Strings.post,
                onPressed: () => _post(),
              )
            ],
            title: Text(Strings.createForm)
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 2.0),
          child: TextField(
            maxLength: _weboMaxLength,
            keyboardType: TextInputType.multiline,
            minLines: 8,
            maxLines: _weboMaxLength,
            maxLengthEnforced: false,
            controller: _weboTextController,
            decoration: InputDecoration(
              hintText: '写点什么吧',
              border: OutlineInputBorder()
            ),
          ),
        ),
    );

  }


  void _post() async {
      final String text = _weboTextController.text;
      if(text.length == 0) {
        Fluttertoast.showToast(msg: "球您还是写点什么吧");
        return;
      }
      if(text.length > _weboMaxLength) {
        Fluttertoast.showToast(msg: "字数超出限制");
        return;
      }
      try {
        Response resp = await DioWithToken.getInstance().post(WebOURL.createPost,
            data: {"text": text});
        print(resp.data.toString());
        if (resp.statusCode == 200) {
          int code = resp.data['code'];
          if (code == WebOHttpCode.SUCCESS) {
              Fluttertoast.showToast(msg: "发布成功");
              Navigator.pop(context);
          }
        } else {
          Fluttertoast.showToast(msg: "Error: " + resp.statusCode.toString());
        }
      } on Exception catch (e) {
        print(e);
      }
  }

  @override
  void dispose() {
    super.dispose();
  }


}
