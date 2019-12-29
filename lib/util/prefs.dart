
import 'package:shared_preferences/shared_preferences.dart';

abstract class Prefs {

  static SharedPreferences _prefs;

  static void init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get instance {
    return _prefs;
  }

}