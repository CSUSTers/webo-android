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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.lightBlue,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context)
            ),
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
            maxLength: 320,
            keyboardType: TextInputType.multiline,
            minLines: 8,
            maxLines: 320,
            maxLengthEnforced: false,
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
      try {
        Response resp = await DioWithToken.getInstance().post(WebOURL.createPost,
            data: {"text": text});
        print(resp.data.toString());
        if (resp.statusCode == 200) {
          if (resp.data['code'] == WebOHttpCode.SUCCESS) {
              Fluttertoast.showToast(msg: "发布成功");
              Navigator.pop(context);
          } else if (resp.data['code'] == WebOHttpCode.SERVER_ERROR) {
            Fluttertoast.showToast(
                msg: "Error: " + resp.data['data']['exceptionMessage']);
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
