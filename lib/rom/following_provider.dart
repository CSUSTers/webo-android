
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webo/contants/user.dart';
import 'package:webo/http/api.dart';
import 'package:webo/rom/user_provider.dart';

class FollowingProvider  with ChangeNotifier {
  List<User> _followerList = [];

  List<User> get followerList => _followerList;

  Future<void> update(BuildContext context) async {
    var provider = Provider.of<UserProvider>(context, listen: false);
    User curUser = provider.user;
    var res = await Api.getFollowingList(curUser.id, 0);
    if(res != null) _followerList = res;
    notifyListeners();
  }

  void clear() => _followerList = [];

  static FollowingProvider of(BuildContext context, {listen: true}) =>
    Provider.of<FollowingProvider>(context, listen: listen);
}
