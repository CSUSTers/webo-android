import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webo/contants/user.dart';
import 'package:webo/contants/values.dart';
import 'package:webo/rom/user_provider.dart';
import 'package:webo/util/gravatar_config.dart';
import 'package:webo/view/router.dart';
import 'package:webo/widget/nothing.dart';
import 'package:webo/widget/real_divider.dart';

class AccountView extends StatefulWidget {
  AccountView({Key key, @required this.user}) : super(key: key);

  final User user;

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  User user;
  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    if (firstTime) {
      user = widget.user;
      firstTime = false;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(Strings.personInfo),
        leading: const BackButton(),
        actions: <Widget>[
          editable
              ? IconButton(
                  icon: const Icon(Icons.mode_edit),
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                        context, Router.accountEditPage,
                        arguments: user);
                    setState(() => user = result);
                  },
                )
              : Nothing()
        ],
      ),
      body: ListView(
        children: <Widget>[
          Image(
            height: 300.0,
            image: getImageForUser(user),
            fit: BoxFit.fill,
          ),
          _ListItem(title: '用户名', content: user.username),
          const RealDivider(),
          _ListItem(title: '昵称', content: user.nickname),
          const RealDivider(),
          _ListItem(title: '邮箱', content: user.email),
          const RealDivider(),
          _ListItem(title: '签名', content: user.bio),
          const RealDivider(),
        ],
      ),
    );
  }

  bool get editable {
    var provider = Provider.of<UserProvider>(context, listen: false);
    return widget.user.id == provider.user.id;
  }
}

class _ListItem extends StatelessWidget {
  _ListItem({Key key, @required this.title, this.content}) : super(key: key);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 56.0,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(
              content ?? '',
              style: const TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
