import 'package:flutter/material.dart';
import 'package:webo/view/login_view.dart';
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
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleImageWidget.fromImage(
                      radius: 96.0,
                      image: AssetImage("images/avatar.jpeg")
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                  ),
                  Text(
                    "Hugefiver",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Account'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebOLoginPage()
                  )
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: WebOListView(data: <String>['Hugefiver', 'MinGW', 'Hoo', '']),
      ),
      floatingActionButton: Container(
        width: 72.0,
        height: 72.0,
        child: FittedBox(
          child: FloatingActionButton(
            child: Icon(Icons.create),
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
