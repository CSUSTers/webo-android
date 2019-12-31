
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webo/contants/user.dart';

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
      id: _prefs.getInt('userId'),
      username: _prefs.getString('username'),
      nickname: _prefs.getString('nickname'),
      email: _prefs.getString('email')
    );
  }

}