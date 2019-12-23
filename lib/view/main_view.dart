import 'package:flutter/material.dart';
import 'package:webo/contants/values.dart';
import 'package:webo/view/login_view.dart';
import 'package:webo/view/settings_view.dart';
import 'package:webo/view/webo_list_view.dart';
import 'package:webo/widget/circle_image.dart';

class WebOApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WebOHomePage(title: 'WebO'),
      debugShowCheckedModeBanner: false,
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

    Container drawerHeader = Container(
      height: 256.0,
      child: DrawerHeader(
        decoration: BoxDecoration(
            color: Colors.blue
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleImageWidget.fromImage(
                radius: 128.0,
                image: AssetImage("images/avatar.jpeg")
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
            ),
            Text(
              "Hugefiver",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      )
    );

    SizedBox drawer = SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            drawerHeader,
            ListTile(
              leading: Icon(Icons.person),
              title: Text(Strings.account),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WebOLoginPage()
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(Strings.settings),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SettingsPage()
                ));
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
              //TODO turn to create WebO page

            },
          ),
        ),
      )
    );
  }
}
