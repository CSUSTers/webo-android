import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webo/contants/http_code.dart';
import 'package:webo/contants/webo.dart';
import 'package:webo/contants/webo_url.dart';
import 'package:webo/http/dio_with_token.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:webo/widget/webo_card.dart';

class WebOListView extends StatefulWidget {
  @override
  _WebOListViewState createState() => _WebOListViewState();
}

class _WebOListViewState extends State<WebOListView> {
  static const ALL = 0;
  static const FOLLOW_ONLY = 1;
  int mode = ALL;

  final forms = List<WebO>();
  String nextForm;

  final _controller = RefreshController(initialRefresh: true);


  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
          controller: _controller,
          onRefresh: _refresh,
          onLoading: _load,
          enablePullUp: true,
          enablePullDown: true,
          header: ClassicHeader(),
          footer: ClassicFooter(),
          child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
              itemCount: forms.length,
              itemBuilder: (BuildContext context, int index) {
                return WebOCard(forms[index]);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider()),
        );
  }



  get _dio => mode == FOLLOW_ONLY ? Dio() : DioWithToken.getInstance();

  get modeParams async {
    var params = {};
    if (mode == FOLLOW_ONLY) {
      SharedPreferences refs = await SharedPreferences.getInstance();
      int id = refs.getInt('id');
      params["id"] = id.toString();
    }
    return params;
  }

  get _firstFetchParam async {
    var params = await modeParams;
    return params;
  }

  get _loadMoreParam async {
    var params = await modeParams;
    params["before"] = nextForm;
    return params;
  }

  void _load() async {
    Dio dio = _dio;
    var params = await _loadMoreParam;
    await addWebos(dio, params, (webo) => forms.add(webo));
    setState(() {});
    _controller.loadComplete();
  }

  void _refresh() async {
    forms.clear();
    Dio dio = _dio;
    var params = await _firstFetchParam;
    await addWebos(dio, params, (webo) => forms.add(webo));
    setState(() {});
    _controller.refreshCompleted(resetFooterState: true);
  }

  Future addWebos(Dio dio, params, handler) async {
      Response resp = await dio.get(WebOURL.allPosts, queryParameters: Map.castFrom(params));
      if (resp.statusCode == 200) {
        if (resp.data['code'] == WebOHttpCode.SUCCESS) {
          var data = resp.data['data'];
          nextForm = data['nextForm'];
          for (var webo in data['webos']) {
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
  }
}
