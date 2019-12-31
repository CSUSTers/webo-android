
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:webo/contants/http_code.dart';
import 'package:webo/contants/user.dart';
import 'package:webo/contants/values.dart';
import 'package:webo/contants/webo_url.dart';
import 'package:webo/http/dio_with_token.dart';
import 'package:webo/rom/user_provider.dart';
import 'package:webo/widget/circle_image.dart';

class FollowPage extends StatefulWidget {

  @override
  _FollowPageState createState() =>_FollowPageState();

}

class _FollowPageState extends State<FollowPage> {

  static const _FOLLOWINGS = 0;
  static const _FOLLOWERS = 1;
  int mode = _FOLLOWINGS;

  bool isLoading = true;

  UserProvider _provider;

  List<User> _followerList = [];
  List<User> _followingList = [];

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<UserProvider>(context);
    if (isLoading) _getFollowList(mode);
    Widget widget = isLoading ? const Center(child: const CircularProgressIndicator()) : ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      itemCount: mode == _FOLLOWERS ? _followerList.length : _followingList.length,
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
                        mode == _FOLLOWERS ? _followerList[index].nickname
                            : _followingList[index].nickname,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        mode == _FOLLOWERS ? _followerList[index].bio
                            : _followingList[index].bio,
                      )
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
    );

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
            onPressed: () => setState(() => mode = mode == _FOLLOWINGS ? _FOLLOWERS : _FOLLOWINGS)
          )
        ],
      ),
      body: widget,
    );

  }

  Future<void> _getFollowList(int _mode) async {
    setState(() {
      isLoading = true;
    });
    Dio dio = DioWithToken.client;
    var params = {
      "id": _provider.user.id,
    };
    try {
      Response resp = await dio.get(_mode == _FOLLOWERS
          ? WebOURL.followers
          : WebOURL.followings,
          queryParameters: params);
      if (resp.statusCode == 200) {
        if (resp.data['code'] == WebOHttpCode.SUCCESS) {
          var data = resp.data['data'];
          _mode == _FOLLOWERS ? _followerList.clear() : _followingList.clear();
          for (var webo in data) {
            print(webo);
            User user = User(id: webo['id'], username: webo['username'],
                nickname: webo['nickname'], email: webo['email'], bio: webo['bio']??'');
            _mode == _FOLLOWERS ? _followerList.add(user) : _followingList.add(user);
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
      setState(() {
        isLoading = false;
      });
    }
  }
}

