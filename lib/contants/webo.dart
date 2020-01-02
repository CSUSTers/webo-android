import 'package:webo/contants/user.dart';
import 'package:webo/contants/webo_url.dart';
import 'package:webo/http/dio_with_token.dart';

class WebO {
  final String id; // ID
  final User user; // 发帖用户
  final DateTime time; // 发帖时间
  final String message; // 主体文本
  final int likes; // 点赞数
  final int forwards; // 转发数
  final int comments; // 评论数
  final bool isLike; // 已点赞

  final WebO forward;

  WebO(
      {this.id,
      this.user,
      this.time,
      this.message,
      this.likes,
      this.forwards,
      this.comments,
      this.isLike,
      this.forward});

  WebO.fromMap(Map<String, dynamic> dy)
      : this(
            id: dy['id'],
            user: User.fromMap(dy['publishedBy']),
            time: DateTime.parse(dy['publishTime']),
            message: dy['message'],
            forwards: dy['forwards'],
            comments: dy['comments'],
            likes: dy['likes'],
            isLike: dy['myselfIsLike'],
            forward:
            dy['forwarding'] == null ? null : WebO.fromMap(dy['forwarding']));

  bool get isForward => this.forward != null;

  List<WebO> enumerateForwardChain() {
    var base = this.forward;
    final result = <WebO>[];
    while (base != null) {
      result.insert(0, base);
      base = base.forward;
    }
    return result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WebO && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Comment {
  final User user;
  final String text;
  final DateTime time;
  final String id;

  Comment({this.id, this.text, this.user, this.time});

  static Future<List<Comment>> fromWebO(WebO webo) async {
    var data = (await DioWithToken.client.get(
      WebOURL.getComment,
      queryParameters: {
        'id': webo.id,
      },
    )).data;

    var comments = <Comment>[];
    for (Map i in data['data']) {
      var user = User.fromMap(i['publisher']);
      var id = i['id'];
      var time = DateTime.parse(i['publishTime']);
      String text = i['content'];

      comments.add(Comment(
        id: id,
        time: time,
        text: text,
        user: user,
      ));
    }
    return comments;
  }
}
