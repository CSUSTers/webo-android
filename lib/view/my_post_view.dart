import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webo/contants/values.dart';
import 'package:webo/view/webo_list_view.dart';

class MyPostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(Strings.mine),
        leading: const BackButton(),
      ),
      body: WebOListView(mode: WebOListView.MINE),
    );
  }
}
