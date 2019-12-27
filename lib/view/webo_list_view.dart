import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webo/contants/http_code.dart';
import 'package:webo/contants/webo_url.dart';
import 'package:webo/http/dio_with_token.dart';

class WebOListView extends StatefulWidget {
  @override
  _WebOListViewState createState() => _WebOListViewState();
}

class _WebOListViewState extends State<WebOListView> {
  static const ALL = 0;
  static const FOLLOW_ONLY = 1;
  int mode = ALL;

  List<dynamic> forms = List<dynamic>();
  String nextForm;

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      _refresh();
    }
    return isLoading
        ? const Center(child: const CircularProgressIndicator())
        : ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
            itemCount: forms.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  child: InkWell(
                      splashColor: Colors.grey.withAlpha(30),
                      onTap: () {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content:
                              Text(forms[index]['publishedBy']['nickname']),
                          duration: Duration(milliseconds: 1000),
                        ));
                      },
                      child: Container(
                        height: 196,
                        child: Text(
                          forms[index]['message'],
                          style: TextStyle(fontSize: 18.0),
                        ),
                      )));
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider());
  }

  void _refresh() async {
    Dio dio = Dio();
    var params = {
      "before": nextForm,
    };
    if (mode == FOLLOW_ONLY) {
      dio = DioWithToken.getInstance();
      SharedPreferences refs = await SharedPreferences.getInstance();
      int userId = refs.getInt('userId');
      params["userId"] = userId.toString();
    }
    try {
      Response resp = await dio.get(WebOURL.allPosts, queryParameters: params);
      if (resp.statusCode == 200) {
        if (resp.data['code'] == WebOHttpCode.SUCCESS) {
          var data = resp.data['data'];
          nextForm = data['nextForm'];
          for (var webo in data['webos']) {
            print(webo);
            forms.add(webo);
          }
        } else if (resp.data['code'] == WebOHttpCode.SERVER_ERROR) {
          Fluttertoast.showToast(
              msg: "Error: " + resp.data['data']['exceptionMessage']);
        }
      } else {
        Fluttertoast.showToast(msg: "Error: " + resp.statusCode.toString());
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() => isLoading = false);
    }
  }
}
