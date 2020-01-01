import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:webo/contants/user.dart';
import 'package:webo/contants/values.dart';
import 'package:webo/rom/user_provider.dart';
import 'package:webo/util/gravatar_config.dart';
import 'package:webo/util/prefs.dart';
import 'package:webo/view/router.dart';
import 'package:webo/view/webo_list_view.dart';

class WebOApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider _userProvider = UserProvider();
    return ChangeNotifierProvider.value(
      value: _userProvider,
      child: MaterialApp(
        title: Strings.appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: Router.home,
//        routes: Router.routeTable,
        onGenerateRoute: (RouteSettings settings) {
          final routeName = settings.name;
          var builder = Router.routeTable[routeName];
          if(Prefs.user.id == -1 && Router.needLoginRoute.contains(routeName)) {
            builder = Router.routeTable[Router.loginPage];
            Fluttertoast.showToast(msg: "请先登录");
          }
          var router = MaterialPageRoute(builder: builder, settings: settings);
          return router;
        },
//        home: WebOHomePage(title: Strings.appName),
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

class _WebOHomePageState extends State<WebOHomePage>
    with SingleTickerProviderStateMixin{
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    this._tabController = TabController(length: 2, vsync: this);
  }

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
              getImageForUser(_userProvider.user, size: 256),
              Padding(
                padding: const EdgeInsets.all(4.0),
              ),
              Text(
                _userProvider.user.nickname,
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
              onTap: () => Navigator.pushNamed(context, Router.loginPage),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(Strings.accountSplit),
              onTap: () => User.openUserPage(context, _userProvider.user),
            ),
            ListTile(
              leading: const Icon(Icons.create),
              title: const Text(Strings.mineSplit),
              onTap: () => Navigator.pushNamed(context, Router.myPostPage),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text(Strings.followSplit),
              onTap: () => Navigator.pushNamed(context, Router.followPage),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(Strings.settingsSplit),
              onTap: () => Navigator.pushNamed(context, Router.settingPage),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
        drawer: drawer,
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            controller: _tabController,
            tabs: <Widget>[Tab(text: "发现",), Tab(text: "关注",)],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children:<Widget>[
            WebOListView(mode: WebOListView.ALL),
            WebOListView(mode: WebOListView.FOLLOW_ONLY)
          ],
        ),
        floatingActionButton: Container(
          width: 64.0,
          height: 64.0,
          child: FittedBox(
            child: FloatingActionButton(
              child: const Icon(Icons.create),
              backgroundColor: Colors.lightBlue,
              onPressed: () => Navigator.pushNamed(context, Router.createPage),
            ),
          ),
        ));
  }
}
