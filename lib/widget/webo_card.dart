import 'package:flutter/material.dart';
import 'package:webo/contants/style.dart';
import 'package:webo/contants/webo.dart';

class WebOCard extends StatelessWidget {
  final WebO data;

  WebOCard(this.data);

  @override
  Widget build(BuildContext context) {
    final nickname = data.user.nickname;
    final username = '@${data.user.username}';

    return Card(
        child: Column(
        children: <Widget>[
          // 第一行
          Container(
            // 昵称、用户名
            child: Row(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      // 昵称
                      Text(
                        nickname,
                        style: bigUserNameFont,
                      ),
                      // 用户名
                      Column(
                        children: <Widget>[
                          Text(
                            username,
                            style: smallUserNameFont,
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.end,
                      )
                    ],
                  ),
                  padding: EdgeInsets.only(right: 20.0),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      // 时间

                    ],
                  ),
                  padding: EdgeInsets.only(left: 5.0),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.0),
          )
        ],
      )
    );
  }
}
