import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webo/contants/user.dart';
import 'package:webo/contants/values.dart';
import 'package:webo/rom/user_provider.dart';

class AccountView extends StatelessWidget {
  AccountView({Key key, @required this.user}):super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(Strings.account),
        leading: const BackButton(),
      ),
      body: ListView(
        children: <Widget>[
          Image(
            height: 300.0,
            image: AssetImage(user.avatar),
            fit: BoxFit.fill,
          ),
          _ListItem(title: '用户名', content: user.username),
          const Divider(),
          _ListItem(title: '昵称', content: user.nickname),
          const Divider(),
          _ListItem(title: '邮箱', content: user.email),
          const Divider(),
          _ListItem(title: '签名', content: user.bio),
          const Divider(),
        ],
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  _ListItem({Key key, @required this.title, this.content}) : super(key: key);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.0,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontSize: 16.0),
          ),
          Text(
            content??'',
            style: const TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
