import 'package:flutter/material.dart';
import 'package:webo/contants/user.dart';
import 'package:webo/contants/webo.dart';
import 'package:webo/view/webo_detail_page.dart';

void openUserPage(BuildContext context, User user) {
  Navigator.of(context).pushNamed('/user', arguments: user);
}

void openDetailPage(BuildContext context, WebO webo) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => WebODetailPage(webo)
  ));
}