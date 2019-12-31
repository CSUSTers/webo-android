import 'package:flutter/material.dart';
import 'package:webo/contants/user.dart';
import 'package:webo/util/prefs.dart';

class UserProvider with ChangeNotifier {

  User _user = Prefs.user;
  User get value => _user;

  void setUser(User user) {
    this._user = user;
    notifyListeners();
  }
}