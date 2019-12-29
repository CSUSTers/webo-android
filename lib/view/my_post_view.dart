
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webo/contants/values.dart';

class MyPostPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(Strings.mine),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }


}