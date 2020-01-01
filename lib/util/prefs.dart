import 'package:shared_preferences/shared_preferences.dart';
import 'package:webo/contants/user.dart';
import 'package:webo/contants/values.dart';

abstract class Prefs {
  static SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get instance {
    return _prefs;
  }

  static User get user {
    return User(
        id: _prefs.getInt('id') ?? -1,
        username: _prefs.getString('username') ?? Strings.notLoginUser,
        nickname: _prefs.getString('nickname') ?? Strings.notLoginUser,
        email: _prefs.getString('email') ?? Strings.notLoginEmail);
  }
}
