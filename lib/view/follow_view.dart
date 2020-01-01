
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  int _mode = _FOLLOWINGS;

  UserProvider _provider;

  List<User> _followerList = [];
  List<User> _followingList = [];
  int _followerPage = 0;
  int _followingPage = 0;
  final _pageSize = 10;


  var _controller = RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<UserProvider>(context, listen: false);
    Widget widget = SmartRefresher(
      controller: _controller,
      onRefresh: _refresh,
      onLoading: _load,
      enablePullUp: true,
      enablePullDown: true,
      header: MaterialClassicHeader(),
      footer: ClassicFooter(),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        itemCount: _mode == _FOLLOWERS ? _followerList.length : _followingList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                CircleImageWidget.fromImage(radius: 48.0,
                    image: AssetImage(Strings.defaultAvatarPath)),
                Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _mode == _FOLLOWERS ? _followerList[index].nickname
                              : _followingList[index].nickname,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _mode == _FOLLOWERS ? _followerList[index].bio
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
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(_mode==_FOLLOWINGS ? Strings.followings : Strings.followers),
        leading: const BackButton(),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: () => setState(() => _mode = _mode == _FOLLOWINGS ? _FOLLOWERS : _FOLLOWINGS)
          )
        ],
      ),
      body: widget,
    );

  }

  void _load() async {
    final loaded = await _getFollowList();
    setState(() {});
    if (loaded > 0) {
      _controller.loadComplete();
    } else {
      _controller.loadNoData();
      Fluttertoast.showToast(msg: "没有了🏁,真的没有了");
    }
  }

  void _refresh() async {
    if(_mode == _FOLLOWINGS) {
      _followingList.clear();
      _followingPage = 0;
    } else {
      _followerList.clear();
      _followerPage = 0;
    }
    final loaded = await _getFollowList();
    setState(() {});
    if (loaded == 0) Fluttertoast.showToast(msg: "似乎没有东西呢");
    _controller.refreshCompleted(resetFooterState: true);
  }

  Future<int> _getFollowList() async {
    int count = 0;
    Dio dio = DioWithToken.client;
    var params = {
      "id": _provider.user.id,
      "page": _mode == _FOLLOWINGS ? _followingPage : _followerPage,
      "size": _pageSize
    };
      Response resp = await dio.get(_mode == _FOLLOWERS
          ? WebOURL.followers
          : WebOURL.followings,
          queryParameters: params);
      if (resp.statusCode == 200) {
        if (resp.data['code'] == WebOHttpCode.SUCCESS) {
          var data = resp.data['data'];
          for (var u in data) {
            print(u);
            User user = User(id: u['id'], username: u['username'],
                nickname: u['nickname'], email: u['email'], bio: u['bio']??'');
            _mode == _FOLLOWERS ? _followerList.add(user) : _followingList.add(user);
            count += 1;
          }
        } else if (resp.data['code'] == WebOHttpCode.SERVER_ERROR) {
          Fluttertoast.showToast(
              msg: "Error: " + resp.data['data']['exceptionMessage']);
        }
      } else {
        Fluttertoast.showToast(msg: "Error: " + resp.statusCode.toString());
      }
    return count;
  }
}

