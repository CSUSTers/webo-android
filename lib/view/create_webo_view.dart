import 'package:flutter/material.dart';
import 'package:webo/contants/values.dart';

class WebOCreatePage extends StatefulWidget {
  @override
  _WebOCreatePageState createState() => _WebOCreatePageState();
}

class _WebOCreatePageState extends State<WebOCreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.lightBlue,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context)
            ),
            title: Text(Strings.createForm)
        )
    );
  }
}
