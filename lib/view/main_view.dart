import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webo/contants/values.dart';
import 'package:webo/rom/global_data.dart';
import 'package:webo/view/create_webo_view.dart';
import 'package:webo/view/follow_view.dart';
import 'package:webo/view/login_view.dart';
import 'package:webo/view/my_post_view.dart';
import 'package:webo/view/settings_view.dart';
import 'package:webo/view/webo_list_view.dart';
import 'package:webo/widget/circle_image.dart';

import '../rom/global_data.dart';
import '../rom/global_data.dart';

class WebOApp extends StatelessWidget {

  static BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return MaterialApp(
        title: Strings.appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: UserDataWidget(),
        debugShowCheckedModeBanner: false,
      );
  }
}

class UserDataWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserDataWidgetState();
}

class UserDataWidgetState extends State<StatefulWidget>{
  Widget build(BuildContext context) {
    var globalData = GlobalData.undefined();
    return GlobalDataWidget(
      data: globalData,
      child: WebOHomePage(
        title: Strings.appName,
      ),
    );
  }
}

class WebOHomePage extends StatefulWidget {
  WebOHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WebOHomePageState createState() => _WebOHomePageState();
}

class _WebOHomePageState extends State<WebOHomePage> {


  @override
  Widget build(BuildContext context) {
    GlobalData data = GlobalDataWidget.of(context)?.data ?? GlobalData.undefined();

    SharedPreferences.getInstance().then((it) {
        var un = it.getString("username");
        var nn = it.getString("nickname");
        if (data.nickName != nn || data.userName != un) {
          setState(() {
            data.userName = un;rt1
            data.nickName = nn;
            data.image = AssetImage(Strings.defaultAvatarPath);
          });
        }
    });

    Container drawerHeader = Container(
        height: 256.0,
        child: DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleImageWidget.fromImage(
                    radius: 128.0, image: data.image),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                ),
                Text(
                  data.nickName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
        ));

    SizedBox drawer = SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            drawerHeader,
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(Strings.accountSplit),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => WebOLoginPage()));
              },
            ),ListTile(
              leading: const Icon(Icons.create),
              title: const Text(Strings.mineSplit),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MyPostPage()));
              },
            ),

            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text(Strings.followSplit),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FollowPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(Strings.settingsSplit),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
          ],
        ),
      ),
    );

    return Scaffold(
            drawer: drawer,
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
              child: WebOListView(),
            ),
            floatingActionButton: Container(
              width: 64.0,
              height: 64.0,
              child: FittedBox(
                child: FloatingActionButton(
                  child: const Icon(Icons.create),
                  backgroundColor: Colors.lightBlue,
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => WebOCreatePage()));
                  },
                ),
              ),
            )
          );
  
  }
}
