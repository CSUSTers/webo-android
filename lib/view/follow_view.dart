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
import 'package:webo/http/api.dart';
import 'package:webo/http/dio_with_token.dart';
import 'package:webo/rom/user_provider.dart';
import 'package:webo/util/gravatar_config.dart';
import 'package:webo/widget/real_divider.dart';

class FollowPage extends StatefulWidget {
  @override
  _FollowPageState createState() => _FollowPageState();
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
  final _pageSize = 20;

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
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () => User.openUserPage(context, _provider.user),
                  child: getCircleImageForUser(list[index], size: 96),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      Text(
                        list[index].nickname,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(list[index].bio)
                    ])),
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
        },
        separatorBuilder: (BuildContext context, int index) => RealDivider(),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title:
            Text(_mode == _FOLLOWINGS ? Strings.followings : Strings.followers),
        leading: const BackButton(),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.swap_horiz),
              onPressed: () => setState(() =>
                  _mode = _mode == _FOLLOWINGS ? _FOLLOWERS : _FOLLOWINGS))
        ],
      ),
      body: widget,
    );
  }

  List<User> get list => _mode == _FOLLOWINGS ? _followingList : _followerList;

  int get page => _mode == _FOLLOWINGS ? _followingPage : _followerPage;

  set page(value) {
    if (_mode == _FOLLOWINGS)
      _followingPage = value;
    else
      _followerPage = value;
  }

  void _load() async {
    page ++;
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
    list.clear();
    page = 0;
    final loaded = await _getFollowList();
    setState(() {});
    if (loaded == 0) Fluttertoast.showToast(msg: "似乎没有东西呢");
    _controller.refreshCompleted(resetFooterState: true);
  }

  Future<int> _getFollowList() async {
    List<User> tmp = [];
    if(_mode == _FOLLOWERS) {
      tmp = await Api.getFollowerList(_provider.user.id, page);
    } else {
      tmp = await Api.getFollowingList(_provider.user.id, page);
    }
    list.addAll(tmp);
    return tmp.length;
  }
}
