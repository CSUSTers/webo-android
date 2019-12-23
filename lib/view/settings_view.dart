
import 'package:flutter/material.dart';
import 'package:webo/contants/values.dart';

class SettingsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(Strings.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: <Widget>[
          MaterialButton(
            minWidth: double.infinity,
            height: 40.0,
            color: Colors.redAccent,
            textColor: Colors.white,
            child: Text(Strings.logout),
            onPressed: () {
              //TODO logout
            },
          ),
        ],
      )
    );
  }

}

