
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webo/contants/http_code.dart';
import 'package:webo/contants/user.dart';
import 'package:webo/contants/values.dart';
import 'package:webo/contants/webo_url.dart';
import 'package:webo/widget/circle_image.dart';

class FollowPage extends StatefulWidget {

  @override
  _FollowPageState createState() =>_FollowPageState();

}

class _FollowPageState extends State<FollowPage> {

  static const _FOLLOWINGS = 0;
  static const _FOLLOWERS = 1;
  int mode = _FOLLOWINGS;

  List<User> _list = [
    User(id: 1, username: "111", nickname: "1111", ),
    User(id: 1, username: "111", nickname: "1111", ),
    User(id: 1, username: "111", nickname: "1111", ),
    User(id: 1, username: "111", nickname: "1111", ),
    User(id: 1, username: "111", nickname: "1111", ),
    User(id: 1, username: "111", nickname: "1111", ),
    User(id: 1, username: "111", nickname: "1111", ),
    User(id: 1, username: "111", nickname: "1111", ),
    User(id: 1, username: "111", nickname: "1111", ),
    User(id: 1, username: "111", nickname: "1111", ),
    User(id: 1, username: "111", nickname: "1111", ),
  ];

  @override
  Widget build(BuildContext context) {
    //_getFollowList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(mode==_FOLLOWINGS ? Strings.followings : Strings.followers),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: () => setState(() => mode = mode == _FOLLOWINGS ? _FOLLOWERS : _FOLLOWINGS) ,
          )
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 8.0),
          itemCount: _list.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  CircleImageWidget.fromImage(radius: 48.0,
                      image: AssetImage(Strings.defaultAvatarPath)),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 4.0),),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _list[index].nickname,
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text("orz")
                        ],
                      )
                  ),
                  MaterialButton(
                    minWidth: 72,
                    height: 36,
                    child: const Text(Strings.cancelFollow),
                    color: Colors.white,
                    textColor: Colors.lightBlue,
                    onPressed: () {},
                  )
                ],
              ),
            );
          }, separatorBuilder: (BuildContext context, int index) => Divider(),
      ),
    );

  }

  void _getFollowList() async {
    Dio dio = Dio();
    var params = {
      "id": "1",
    };
    try {
      Response resp = await dio.get(
          mode == _FOLLOWERS ? WebOURL.followers
              : WebOURL.followings, queryParameters: params);
      if (resp.statusCode == 200) {
        if (resp.data['code'] == WebOHttpCode.SUCCESS) {
          var data = resp.data['data'];

          for (var webo in data['webos']) {
            print(webo);

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

    }
  }
}

