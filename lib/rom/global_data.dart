import 'package:flutter/material.dart';

class GlobalDataWidget extends InheritedWidget {
  final GlobalData data;

  GlobalDataWidget({this.data, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(GlobalDataWidget oldWidget) {
    return oldWidget.data != this.data;
  }

  static GlobalDataWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GlobalDataWidget>();
  }
}

class GlobalData {
  final String userName;
  final String nickName;
  final ImageProvider image;

  GlobalData(this.userName, this.nickName, this.image);

  GlobalData.undefined() :
        this.userName = 'undefined',
        this.nickName = 'undefined',
        this.image = AssetImage('images/avatar.jpeg');
}