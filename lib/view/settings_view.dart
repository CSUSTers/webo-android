import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webo/contants/values.dart';
import 'package:webo/rom/global_data.dart';
import 'package:webo/rom/user_provider.dart';
import 'package:webo/util/prefs.dart';
import 'package:webo/view/router.dart';

class SettingsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(Strings.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.pushNamed(context, Router.passChangePage),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('修改密码', style: TextStyle(fontSize: 16.0)),
                Icon(Icons.chevron_right)
              ],
            )
          ),
          Divider(),
          Container(
            margin: const EdgeInsets.all(4.0),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 40.0,
              color: Colors.redAccent,
              textColor: Colors.white,
              child: const Text(Strings.logout),
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('确认退出登录吗'),
                    content: const Text('此操作将清除本地保存的用户信息'),
                    actions: <Widget>[
                      MaterialButton(
                        color: Colors.red,
                        child: Text('退出'),
                        onPressed: () async {
//                          GlobalDataWidget.of(context).user = UserData.notLogin();
                          var provider = Provider.of<UserProvider>(context, listen: false);
                          provider.clear();
                          Prefs.instance.clear();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      ),
                      MaterialButton(
                          color: Colors.white,
                          child: Text('不了不了'),
                          onPressed: () => Navigator.pop(context)
                      )
                    ],
                  )
              ),
            )
          ),
        ],
      )
    );
  }

}

