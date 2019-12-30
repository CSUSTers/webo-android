import 'package:flutter/material.dart';
import 'package:webo/contants/values.dart';

class GlobalDataWidget extends InheritedWidget {
  final GlobalData data;

  GlobalDataWidget({this.data, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(GlobalDataWidget oldWidget) {
    print('asdnfjhenrsajdiefijrnerj');
    if (oldWidget?.data == null || data == null) return true;
    return oldWidget.data != this.data;
  }

  static GlobalDataWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GlobalDataWidget>();
  }
}

class GlobalData {
  String userName;
  String nickName;
  ImageProvider image;

  @override
  bool operator==(dynamic other) {
    if (other.runtimeType == this.runtimeType) {
      return userName == other.userName &&
        nickName == other.nickName &&
        this.image == other.image;
    }

    return false;
  }

  @override
  int get hashCode => super.hashCode;

  GlobalData(this.userName, this.nickName, this.image);

  //can't work
//  static GlobalData init() {
//    GlobalData data;
//    SharedPreferences.getInstance().then((prefs) {
//      if (prefs.containsKey('username')) {
//        String username = prefs.getString('username');
//        String nickname = prefs.getString('nickname');
//        data = GlobalData(
//            username, nickname, AssetImage(Strings.defaultAvatarPath));
//      } else
//        data = GlobalData.undefined();
//    });
//    return data;
//  }


  GlobalData.undefined() :
        this.userName = 'undefined',
        this.nickName = 'undefined',
        this.image = AssetImage(Strings.defaultAvatarPath);
}