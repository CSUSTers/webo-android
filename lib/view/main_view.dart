import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
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
          children: const <Widget>[
            DrawerHeader(
              child: Text('UserName'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Account'),
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
        child: Text("Hello"),

      ),
    );
  }
}
