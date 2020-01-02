import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:webo/contants/http_code.dart';
import 'package:webo/contants/style.dart';
import 'package:webo/contants/webo.dart';
import 'package:webo/contants/webo_url.dart';
import 'package:webo/http/dio_with_token.dart';
import 'package:webo/rom/user_provider.dart';
import 'package:webo/widget/real_divider.dart';
import 'package:webo/widget/webo_card.dart';

class WebOListView extends StatefulWidget {
  static const ALL = 0;
  static const FOLLOW_ONLY = 1;
  static const MINE = 2;
  final mode;

  WebOListView({this.mode: WebOListView.ALL});

  @override
  _WebOListViewState createState() => _WebOListViewState(mode: mode);
}

class _WebOListViewState extends State<WebOListView> {
  final mode;

  _WebOListViewState({this.mode});

  final forms = List<WebO>();
  String nextFrom;

  var _controller;

  @override
  void initState() {
    super.initState();
    _controller = RefreshController(initialRefresh: !_couldNotLoad);
  }

  get _mainList => SmartRefresher(
        controller: _controller,
        onRefresh: _refresh,
        onLoading: _load,
        enablePullUp: true,
        enablePullDown: true,
        header: WaterDropMaterialHeader(),
        footer: ClassicFooter(),
        child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
            itemCount: forms.length,
            itemBuilder: (BuildContext context, int index) {
              return WebOCard(forms[index], shouldShowForwarding: true);
            },
            separatorBuilder: (BuildContext context, int index) =>
                const RealDivider()),
      );

  @override
  Widget build(BuildContext context) {
    if (_couldNotLoad) {
      return _notValid;
    }
    return _mainList;
  }

  get _couldNotLoad =>
      [WebOListView.MINE, WebOListView.FOLLOW_ONLY].any((it) => it == mode) &&
      !_currentIsLogin;

  get _currentIsLogin => _currentUserId != null && _currentUserId > 0;

  get _notValid {
    final color = Colors.blue.withOpacity(0.88);
    return Center(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Icon(Icons.warning, size: 64.0, color: color),
          Text("求求您登陆一下吧……", style: mainTextFont.apply(color: color))
        ]));
  }

  get _dio =>
      mode == WebOListView.FOLLOW_ONLY ? Dio() : DioWithToken.getInstance();

  get _currentUserId {
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    int id = provider?.user?.id;
    return id;
  }

  get modeParams {
    var params = {};
    if (_currentIsLogin) {
      if (mode == WebOListView.ALL) params["userId"] = _currentUserId;
      if ([WebOListView.FOLLOW_ONLY, WebOListView.MINE].any((it) => it == mode))
        params["id"] = _currentUserId;
    }

    return params;
  }

  get _firstFetchParam {
    var params = modeParams;
    return params;
  }

  get _loadMoreParam {
    var params = modeParams;
    print(nextFrom);
    params["before"] = nextFrom;
    return params;
  }

  void _load() async {
    Dio dio = _dio;
    var params = _loadMoreParam;
    final loaded = await addWebOs(dio, params, (webo) => forms.add(webo));
    setState(() {});
    if (loaded > 0) {
      _controller.loadComplete();
    } else {
      _controller.loadNoData();
      Fluttertoast.showToast(msg: "没有 WebO 了🏁");
    }
  }

  void _refresh() async {
    /*
    forms.clear();
    Dio dio = _dio;
    var params = await _firstFetchParam;
    final loaded = await addWebOs(dio, params, (webo) => forms.add(webo));
    //setState(() {});
    if (loaded == 0) Fluttertoast.showToast(msg: "似乎没有什么东西🤔");
    */
    Dio dio = _dio;
    var params = _firstFetchParam;
    setState(() => forms.clear());
    addWebOs(dio, params, (webo) => setState(() => forms.add(webo))).then((v) {
      if (v == 0) Fluttertoast.showToast(msg: "似乎没有什么东西🤔");
    });
    _controller.refreshCompleted(resetFooterState: true);
  }

  get _target => {
        WebOListView.ALL: WebOURL.allPosts,
        WebOListView.FOLLOW_ONLY: WebOURL.followingPosts,
        WebOListView.MINE: WebOURL.myPosts,
      }[this.mode];

  Future<int> addWebOs(Dio dio, params, handler) async {
    int loaded = 0;
    Response resp =
        await dio.get(_target, queryParameters: Map.castFrom(params));
    if (resp.statusCode == 200) {
      if (resp.data['code'] == WebOHttpCode.SUCCESS) {
        var data = resp.data['data'];
        nextFrom = data['nextFrom'];
        for (var webo in data['webos']) {
          loaded += 1;
          print(webo);
          handler(WebO.fromMap(webo));
        }
      } else if (resp.data['code'] == WebOHttpCode.SERVER_ERROR) {
        Fluttertoast.showToast(
            msg: "Error: " + resp.data['data']['exceptionMessage']);
      }
    } else {
      Fluttertoast.showToast(msg: "Error: " + resp.statusCode.toString());
    }
    return loaded;
  }
}
