
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webo/contants/values.dart';

class FollowPage extends StatefulWidget {

  @override
  _FollowPageState createState() =>_FollowPageState();

}

class _FollowPageState extends State<FollowPage> {

  static const _FOLLOWINGS = 0;
  static const _FOLLOWERS = 1;
  int mode = _FOLLOWINGS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(mode==_FOLLOWINGS ? Strings.followings : Strings.followers),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: () => setState(() => mode = mode == _FOLLOWINGS ? _FOLLOWERS : _FOLLOWINGS) ,
          )
        ],
      ),
    );
  }

}