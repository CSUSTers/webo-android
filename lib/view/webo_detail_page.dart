import 'package:flutter/material.dart';
import 'package:webo/actions/page_action.dart';
import 'package:webo/contants/style.dart';
import 'package:webo/contants/values.dart';
import 'package:webo/contants/webo.dart';
import 'package:webo/util/timeline.dart';
import 'package:webo/widget/touchable_widget.dart';
import 'package:webo/widget/webo_card.dart';

class WebODetailPage extends StatelessWidget {
  final WebO data;

  WebODetailPage(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(Strings.detail),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              WebOCard(data),
              Container(
                margin: EdgeInsets.symmetric(vertical: 3.5),
              ),
            ],
          ),
          margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
        ),
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
    setState(() {
      Comment.fromWebO(webo).then((v) => comments = v);
    });
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
      child: Column(
        children: list,
        crossAxisAlignment: CrossAxisAlignment.center,
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
          Container(
            child: Text(
              comment.text,
              style: mainTextFont,
            ),
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
          ),
        ],
      ),
    );
  }
}
