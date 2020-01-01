import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:webo/actions/page_action.dart';
import 'package:webo/contants/http_code.dart';
import 'package:webo/contants/style.dart';
import 'package:webo/contants/values.dart';
import 'package:webo/contants/webo.dart';
import 'package:webo/contants/webo_url.dart';
import 'package:webo/http/dio_with_token.dart';
import 'package:webo/rom/user_provider.dart';
import 'package:webo/util/timeline.dart';
import 'package:webo/widget/touchable_widget.dart';

class WebOCard extends StatelessWidget {
  final WebO data;

  WebOCard(this.data);

  @override
  Widget build(BuildContext context) {
    final nickname = data.user.nickname;
    final username = '@${data.user.username}';

    return TapWidget(
      () => openDetailPage(context, data),
      Card(
        child: Container(
          child: Column(
            children: <Widget>[
              // 第一行
              Container(
                // 昵称、用户名
                child: Row(
                  children: <Widget>[
                    TapWidget(
                      () => openUserPage(context, data.user),
                      Container(
                        child: Row(
                          children: <Widget>[
                            // 昵称
                            Text(
                              nickname,
                              style: bigUserNameFont,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 2.0),
                            ),
                            // 用户名
                            Column(
                              children: <Widget>[
                                Text(
                                  username,
                                  style: smallUserNameFont,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.end,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          // 时间
                          Text(
                            TimelineUtil.formatByDateTime(
                              data.time,
                              locDateTime: DateTime.now(),
                            ),
                          ),
                          WebOMenuIcon(data),
                        ],
                      ),
                      margin: EdgeInsets.only(left: 5.0),
                      padding: EdgeInsets.all(0.0),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              // 第二行: 主体
              WebOText(data),
              // 第三行: 按钮
              ActionButtons(data),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          padding: EdgeInsets.symmetric(horizontal: 8.0),
        ),
      ),
    );
  }
}

class IconButtonWithMsg extends StatelessWidget {
  final Icon icon;
  final Text msg;
  final bool selected;
  final Function onTap;

  IconButtonWithMsg({this.msg, this.icon, this.onTap, this.selected: false});

  @override
  Widget build(BuildContext context) {
    return TapWidget(
        onTap,
        Container(
            child: Row(
              children: <Widget>[
                icon,
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                ),
                msg
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            margin: EdgeInsets.symmetric(vertical: 8.0),
            color: selected ? Colors.lightBlue : Colors.white));
  }
}

class ActionButtons extends StatefulWidget {
  final WebO data;

  ActionButtons(this.data);

  @override
  State createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  int likes;
  int forwards;
  int comments;

  bool isLike;

  @override
  void initState() {
    super.initState();

    var webo = widget.data;
    likes = webo.likes;
    forwards = webo.forwards;
    comments = webo.comments;
    isLike = webo.isLike;
  }

  @override
  Widget build(BuildContext context) {
    const size = 16.0;
    const style = TextStyle(fontSize: size);
    final webo = widget.data;

    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: IconButtonWithMsg(
              icon: Icon(
                Icons.reply,
                size: size,
              ),
              msg: Text(
                '${Strings.forward} $forwards',
                style: style,
              ),
              onTap: () {
                DioWithToken.client
                    .post(WebOURL.newComment, data: {
                      'id': webo.id,
                      'message': '❤❤❤'
                    }).then((v) {
                  if (v.statusCode == 200 &&
                      v.data['code'] == WebOHttpCode.SUCCESS) {
                    setState(() {
                      forwards += 1;
                    });
                  }
                });
              },
            ),
            flex: 4,
          ),
          Expanded(
            child: IconButtonWithMsg(
              icon: Icon(
                Icons.comment,
                size: size,
              ),
              msg: Text(
                '${Strings.comment} $comments',
                style: style,
              ),
              onTap: () {
                DioWithToken.client
                    .post(WebOURL.newComment, data: {'id': webo.id, 'text': 'comment'}).then((v) {
                  if (v.statusCode == 200 &&
                      v.data['code'] == WebOHttpCode.SUCCESS) {
                    setState(() {
                      comments += 1;
                    });
                  }
                });
              },
            ),
            flex: 4,
          ),
          Expanded(
            child: IconButtonWithMsg(
              icon: Icon(
                isLike ?
                  Icons.favorite :
                  Icons.favorite_border,
                size: size,
              ),
              msg: Text('${Strings.like} $likes'),
              selected: isLike,
              onTap: () {
                DioWithToken.client
                    .post(WebOURL.likePost, data: {'id': webo.id}).then((v) {
                  if (v.statusCode == 200 &&
                      v.data['code'] == WebOHttpCode.SUCCESS) {
                    setState(() {
                      likes += isLike ? -1 : 1;
                      isLike ^= true;
                    });
                  }
                });
              },
            ),
            flex: 4,
          ),
        ],
      ),
    );
  }
}

class WebOText extends StatelessWidget {
  final WebO data;

  WebOText(this.data);

  @override
  Widget build(BuildContext context) {
    var inner = <Widget>[
      Text(
        data.message,
        style: bigMainTextFont,
      ),
    ];

    if (data.isForward) {
      var f = data.forward;
      inner.add(Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      f.user.nickname,
                      style: userNameFont,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.5),
                    ),
                    Text(
                      '@${f.user.username}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Text(
                f.message,
                style: mainTextFont,
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        decoration: BoxDecoration(color: Colors.blueGrey),
      ));
    }

    return Container(
      child: Column(children: inner),
      margin: EdgeInsets.only(top: 5.0, bottom: 10.0, left: 8.0, right: 8.0),
    );
  }
}

class WebOMenuIcon extends StatefulWidget {
  final WebO data;

  WebOMenuIcon(this.data);

  @override
  State createState() => _WebOMenuState();
}

class _WebOMenuState extends State<WebOMenuIcon> {
  @override
  Widget build(BuildContext context) {
    final webo = widget.data;
    var list = <PopupMenuItem>[];

    // 删除
    if (webo.user.id == UserProvider.of(context).user?.id)
      list.add(PopupMenuItem(
        value: 'delete',
        child: Text(Strings.delete),
      ));
    else
      list.add(PopupMenuItem(
        enabled: false,
        child: Text('Nothing'),
      ));

    return PopupMenuButton(
      itemBuilder: (context) => list,
      icon: Icon(
        Icons.keyboard_arrow_down,
        size: 18.0,
      ),
      onSelected: (value) {
        switch (value) {
          case 'delete':
            setState(
              () {
                DioWithToken.client.delete(
                  WebOURL.postDelete,
                  queryParameters: {
                    'id': webo.id,
                  },
                ).then((v) {
                  if (v.statusCode == 200 &&
                      v.data['code'] == WebOHttpCode.SUCCESS) {
                    Fluttertoast.showToast(msg: '删除成功');
                  } else {
                    Fluttertoast.showToast(msg: '删除失败');
                  }
                });
              },
            );
        }
      },
    );
  }
}
