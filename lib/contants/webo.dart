import 'package:webo/contants/user.dart';

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

  WebO({this.id,
      this.user,
      this.time,
      this.message,
      this.likes,
      this.forwards,
      this.comments,
      this.isLike,
      this.forward
  });

  WebO.fromMap(Map<String, dynamic> dy) : this(
    id: dy['id'],
    user: User.fromMap(dy['publishedBy']),
    time: DateTime.parse(dy['publishTime']),
    message: dy['message'],
    forwards: dy['forwards'],
    comments: dy['comments'],
    isLike: dy['myselfIsLike'],
    forward: dy['forward'] == null ? null : WebO.fromMap(dy['forward'])
  );

  bool get isForward => this.forward != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WebO &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}