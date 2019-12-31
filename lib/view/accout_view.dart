

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webo/contants/values.dart';
import 'package:webo/rom/user_provider.dart';

class AccountView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(Strings.account),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Image(
            height: 300.0,
            image: AssetImage(_userProvider.value.avatar),
            fit: BoxFit.fill,
          ),
          _ListItem(title: '用户名', content: _userProvider.value.username),
          const Divider(),
          _ListItem(title: '昵称', content: _userProvider.value.nickname),
          const Divider(),
          _ListItem(title: '邮箱', content: _userProvider.value.email),
          const Divider(),
          _ListItem(title: '签名', content: _userProvider.value.bio),
          const Divider(),
        ],
      ),
    );
  }

}


class _ListItem extends StatelessWidget {
  _ListItem({Key key, @required this.title, this.content}):super(key:key);

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
          Text(title,
            style: TextStyle(
              fontSize: 16.0
            ),
          ),
          Text(content,
            style: TextStyle(
              color: Colors.grey
            ),
          )
        ],
      ),
    );
  }

}
