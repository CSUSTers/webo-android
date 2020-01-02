import 'package:flutter/material.dart';
import 'package:webo/contants/values.dart';
import 'package:webo/view/account_edit_view.dart';
import 'package:webo/view/accout_view.dart';
import 'package:webo/view/change_pass_view.dart';
import 'package:webo/view/create_webo_view.dart';
import 'package:webo/view/follow_view.dart';
import 'package:webo/view/login_view.dart';
import 'package:webo/view/main_view.dart';
import 'package:webo/view/my_post_view.dart';
import 'package:webo/view/settings_view.dart';

import 'about_page.dart';

class Router {
  static const home = "/";
  static const loginPage = "/login";
  static const userPage = "/user";
  static const passChangePage = "/change-pass";
  static const accountEditPage = "/account-edit";
  static const createPage = "/create";
  static const myPostPage = "/my-post";
  static const followPage = "/follow";
  static const settingPage = "/settings";
  static const aboutPage = "/about";

  static List<String> needLoginRoute = [
    userPage,
    createPage,
    passChangePage,
    accountEditPage,
    myPostPage,
    followPage,
    settingPage
  ];

  static Map<String, WidgetBuilder> routeTable = {
    home: (context) => WebOHomePage(title: Strings.appName),
    loginPage: (context) => WebOLoginPage(),
    userPage: (context) =>
        AccountView(user: ModalRoute.of(context).settings.arguments),
    passChangePage: (context) => ChangePassPage(),
    accountEditPage: (context) => AccountEditView(),
    createPage: (context) => WebOCreatePage(),
    myPostPage: (context) => MyPostPage(),
    followPage: (context) => FollowPage(),
    settingPage: (context) => SettingsPage(),
    aboutPage: (context) => AboutPage(),
  };
}
