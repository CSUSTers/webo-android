import 'package:flutter/material.dart';
import 'package:webo/contants/user.dart';
import 'package:webo/contants/values.dart';

class GlobalDataWidget extends InheritedWidget {
  final Data<UserData> _userData;

  GlobalDataWidget({UserData userData, Widget child}) :
        this._userData = Data(userData),
        super(child: child);

  UserData get user => _userData.data;

  set user(UserData data) => _userData.data = data;

  @override
  bool updateShouldNotify(GlobalDataWidget oldWidget) {
    return oldWidget._userData != this._userData;
  }

  static GlobalDataWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GlobalDataWidget>();
  }
}

class Data<T> {
  T _data;

  Data(this._data);

  T get data => this._data;

  set data(T data) => this._data = data;

  void replace(T data) => this._data = data;
}

class UserData {
  final String userName;
  final String nickName;
  final ImageProvider image;

  UserData(this.userName, this.nickName, this.image);


  UserData.undefined() :
        this.userName = 'undefined',
        this.nickName = 'undefined',
        this.image = AssetImage(Strings.defaultAvatarPath);

  UserData.withDefaultPic({this.userName, this.nickName}) :
        this.image = AssetImage(Strings.defaultAvatarPath);

  static UserData notLogin() => UserData.undefined();
}