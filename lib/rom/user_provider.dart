import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webo/contants/user.dart';
import 'package:webo/util/prefs.dart';

class UserProvider with ChangeNotifier {

  User _user = Prefs.user;
  User get value => _user;

  User get user => _user;
  set user(User user) => this.setUser(user);

  void setUser(User user) {
    this._user = user;
    notifyListeners();
  }

  void clear() => setUser(User());

  static UserProvider of(BuildContext context, {listen: true})
    => Provider.of<UserProvider>(context, listen: listen);
}