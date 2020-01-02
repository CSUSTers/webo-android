import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:webo/actions/page_action.dart';
import 'package:webo/contants/http_code.dart';
import 'package:webo/contants/style.dart';
import 'package:webo/contants/values.dart';
import 'package:webo/contants/webo.dart';
import 'package:webo/contants/webo_url.dart';
import 'package:webo/http/dio_with_token.dart';
import 'package:webo/rom/user_provider.dart';
import 'package:webo/util/gravatar_config.dart';
import 'package:webo/util/timeline.dart';
import 'package:webo/widget/touchable_widget.dart';
import 'package:webo/widget/webo_card.dart';

class WebODetailPage extends StatelessWidget {
  final WebO data;

  createTimelineByWebos(List<WebO> webos) {
    var timeline;
    if (webos.length > 1) {
      final list = <TimelineModel>[];
      for (int i = 0; i < webos.length; i ++) {
        list.add(TimelineModel(
            WebOCard(webos[i]),
            icon: i != webos.length - 1 ?
            Icon(Icons.arrow_downward, color: Colors.white) :
            Icon(Icons.last_page, color: Colors.white),
            iconBackground: Colors.blueAccent
        ));
      }
      timeline = Timeline(
        shrinkWrap: true,
        lineColor: Colors.black26,
        children: list,
        position: TimelinePosition.Left,
      );
    } else {
      timeline = WebOCard(data);
    }
    return timeline;
  }

  WebODetailPage(this.data);
  @override
  Widget build(BuildContext context) {
    final webos = data.enumerateForwardChain();
    final timeline = createTimelineByWebos(webos);


    var list = <Widget>[
      timeline,
      Container(
        margin: EdgeInsets.symmetric(vertical: 3.5),
      ),
      CommentsCard(data),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(Strings.detail),
      ),
      body: Container(
        child: ListView(
          children: list,
        ),
        margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
      ),
    );
  }
}

class CommentsCard extends StatefulWidget {
  final WebO data;

  CommentsCard(this.data);

  createState() => _CommentsCardState();
}

class _CommentsCardState extends State<CommentsCard> {
  List<Comment> comments = <Comment>[];

  @override
  void initState() {
    super.initState();

    var webo = widget.data;
    Comment.fromWebO(webo).then((v) => setState(() => comments = v));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list;
    if (comments.isEmpty) {
      list = <Widget>[
        Text(
          "Nothing Here.",
          style: mainTextFont,
        )
      ];
    } else {
      var first = CommentArea(comments[0]);
      if (comments.length == 1) {
        list = <Widget>[first];
      }
      list = comments
          .map((m) => CommentArea(m))
          .skip(1)
          .map((m) => <Widget>[
                Divider(),
                m,
              ])
          .expand((i) => i)
          .toList()
            ..insert(0, first);
    }
    return Card(
      child: Container(
        child: Column(
          children: list,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 5.0),
      ),
    );
  }
}

class CommentArea extends StatelessWidget {
  final Comment comment;

  CommentArea(this.comment);

  @override
  Widget build(BuildContext context) {
    var nickname = comment.user.nickname;
    var username = '@${comment.user.username}';

    return Container(
      child: Column(
        children: <Widget>[
          // 第一行
          Container(
            // 昵称、用户名
            child: Row(
              children: <Widget>[
                TapWidget(
                  () => openUserPage(context, comment.user),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.5),
                        ),
                        // 头像
                        getCircleImageForUser(comment.user, size: 58),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.5),
                        ),
                        // 昵称
                        Text(
                          nickname,
                          style: userNameFont,
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
                          comment.time,
                          locDateTime: DateTime.now(),
                        ),
                      ),
                      // Menu
                      //CommentMenuIcon(comment),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 5.0, right: 8.0),
                  padding: EdgeInsets.all(0.0),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          // 第二行: 主体
          Container(
            child: Text(
              comment.text,
              style: mainTextFont,
            ),
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}

class CommentMenuIcon extends StatefulWidget {
  final Comment data;

  CommentMenuIcon(this.data);

  @override
  State createState() => _CommentMenuState();
}

class _CommentMenuState extends State<CommentMenuIcon> {
  @override
  Widget build(BuildContext context) {
    final comment = widget.data;
    var list = <PopupMenuItem>[];

    // 删除
    if (comment.user.id == UserProvider.of(context).user?.id)
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
      padding: EdgeInsets.all(0.0),
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
                  WebOURL.deleteComment,
                  queryParameters: {
                    'id': comment.id,
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