import 'package:flutter/material.dart';

class WebOLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(32),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.text,
                maxLength: 12,
                style: TextStyle(fontSize: 16.0),
                decoration: const InputDecoration(
                  hintText: 'username'
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'username is empty';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                maxLength: 32,
                decoration: const InputDecoration(
                  hintText: 'password'
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'password is empty';
                  }
                  return null;
                },
              ),
              RaisedButton(
                child: Text('Login'),
                color: Colors.lightBlue,
                textColor: Colors.white,

                onPressed: () {

                },
              )
            ],
          )
        )
      ),
    );
  }

}