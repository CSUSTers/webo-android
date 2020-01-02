

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webo/contants/values.dart';

class AboutPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title:
        Text(Strings.about),
        leading: const BackButton()
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("images/logo.PNG"),
            Padding(padding: const EdgeInsets.symmetric(vertical: 16.0)),
            Text('开发团队', style: TextStyle(fontSize: 24.0)),
            Text('胡耀豪（2017160801xx）', style: TextStyle(fontSize: 18.0)),
            Text('余峻岑（201716080221）', style: TextStyle(fontSize: 18.0)),
            Text('晏政（201716080223）', style: TextStyle(fontSize: 18.0)),
            Text('吴文远（201716080422）', style: TextStyle(fontSize: 18.0)),
            Text('李越（201739160212）', style: TextStyle(fontSize: 18.0)),
            Padding(padding: const EdgeInsets.symmetric(vertical: 32.0)),
          ],
        ),
      ),
    );
  }

}