import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webo/contants/http_code.dart';
import 'package:webo/contants/webo.dart';
import 'package:webo/contants/webo_url.dart';
import 'package:webo/http/dio_with_token.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:webo/rom/user_provider.dart';
import 'package:webo/util/prefs.dart';
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
  String nextForm;

  final _controller = RefreshController(initialRefresh: true);


  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      child: SmartRefresher(
        controller: _controller,
        onRefresh: _refresh,
        onLoading: _load,
        enablePullUp: true,
        enablePullDown: true,
        header: MaterialClassicHeader(),
        footer: ClassicFooter(),
        child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
            itemCount: forms.length,
            itemBuilder: (BuildContext context, int index) {
              return WebOCard(forms[index]);
            },
            separatorBuilder: (BuildContext context, int index) =>
            const Divider()),
      ),
    );
  }



  get _dio => mode == WebOListView.FOLLOW_ONLY ? Dio() : DioWithToken.getInstance();

  get modeParams {
    var params = {};
    if (mode == WebOListView.FOLLOW_ONLY || mode == WebOListView.MINE) {
      UserProvider provider = Provider.of<UserProvider>(context, listen: false);
      int id = provider.user.id;
      print("MODEPARAMES: $id");
      params["id"] = id;
    }
    return params;
  }

  get _firstFetchParam {
    var params = modeParams;
    return params;
  }

  get _loadMoreParam {
    var params = modeParams;
    params["before"] = nextForm;
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
    forms.clear();
    Dio dio = _dio;
    var params = await _firstFetchParam;
    final loaded = await addWebOs(dio, params, (webo) => forms.add(webo));
    setState(() {});
    if (loaded == 0) Fluttertoast.showToast(msg: "似乎没有什么东西🤔");
    _controller.refreshCompleted(resetFooterState: true);
  }
  
  get _target => {
    WebOListView.ALL: WebOURL.allPosts,
    WebOListView.FOLLOW_ONLY: WebOURL.followingPosts,
    WebOListView.MINE: WebOURL.myPosts,
  }[this.mode];

  Future<int> addWebOs(Dio dio, params, handler) async {
    int loaded = 0;
    Response resp = await dio.get(_target, queryParameters: Map.castFrom(params));
    if (resp.statusCode == 200) {
      if (resp.data['code'] == WebOHttpCode.SUCCESS) {
        var data = resp.data['data'];
        nextForm = data['nextForm'];
        for (var webo in data['webos']) {
          print(webo);
          loaded += 1;
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
