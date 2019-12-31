import 'package:webo/contants/user.dart';

class WebO {
  final String id;
  final User user;
  final DateTime time;
  final String message;
  final int likes;
  final int forwards;
  final int comments;
  final bool isLike;

  WebO({this.id,
      this.user,
      this.time,
      this.message,
      this.likes,
      this.forwards,
      this.comments,
      this.isLike});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WebO &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;



}