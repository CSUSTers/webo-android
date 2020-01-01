

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webo/contants/values.dart';

class ChangePassPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(Strings.changePass),
        leading: BackButton(),
      ),
    );
  }

}