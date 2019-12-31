import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webo/contants/values.dart';
import 'package:webo/rom/user_provider.dart';
import 'package:webo/view/accout_view.dart';
import 'package:webo/view/create_webo_view.dart';
import 'package:webo/view/follow_view.dart';
import 'package:webo/view/login_view.dart';
import 'package:webo/view/my_post_view.dart';
import 'package:webo/view/settings_view.dart';
import 'package:webo/view/webo_list_view.dart';
import 'package:webo/widget/circle_image.dart';

class WebOApp extends StatelessWidget {

  static BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    UserProvider _userProvider = UserProvider();
    return ChangeNotifierProvider.value(
        value: _userProvider,
        child: MaterialApp(
          title: Strings.appName,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: WebOHomePage(title: Strings.appName),
          debugShowCheckedModeBanner: false,
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
  /*@override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((pref) {
      var userName = pref.getString('username');
      var nickName = pref.getString('nickname');
      UserData user;
      if (userName == null || nickName == null)
        user = UserData.notLogin();
      else
        user = UserData.withDefaultPic(
          userName: userName,
          nickName: nickName
        );
      setState(() {
        GlobalDataWidget.of(context).user = user;
      });
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<UserProvider>(context);

    Container drawerHeader = Container(
        height: 256.0,
        child: DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleImageWidget.fromImage(
                    radius: 128.0, image: AssetImage(_userProvider.value.avatar)),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                ),
                Text(
                  _userProvider.value.nickname,
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
              leading: const Icon(Icons.vpn_key),
              title: const Text(Strings.login),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => WebOLoginPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(Strings.accountSplit),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AccountView()));
              },
            ),
            ListTile(
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
        ));
  }
}
