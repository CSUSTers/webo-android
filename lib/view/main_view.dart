import 'package:flutter/material.dart';
import 'package:webo/contants/values.dart';
import 'package:webo/rom/global_data.dart';
import 'package:webo/view/create_webo_view.dart';
import 'package:webo/view/login_view.dart';
import 'package:webo/view/settings_view.dart';
import 'package:webo/view/webo_list_view.dart';
import 'package:webo/widget/circle_image.dart';

class WebOApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GlobalDataWidget(
      data: GlobalData.undefined(),
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

  @override
  Widget build(BuildContext context) {
    GlobalData globalData = GlobalDataWidget.of(context).data;
    Container drawerHeader = Container(
        height: 256.0,
        child: DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleImageWidget.fromImage(
                    radius: 128.0, image: globalData.image),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                ),
                Text(
                  globalData.nickName,
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
              leading: Icon(Icons.person),
              title: Text(Strings.accountSplit),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => WebOLoginPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(Strings.settingsSplit),
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
