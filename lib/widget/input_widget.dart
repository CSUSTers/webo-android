import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webo/contants/style.dart';

class BottomInputDialog extends StatefulWidget {
  final Function onSubmit;
  final Function onChange;

  BottomInputDialog({this.onSubmit, this.onChange});

  @override
  createState() => _BottomInputDialogState();
}

class _BottomInputDialogState extends State<BottomInputDialog> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              child: Container(
                color: Colors.black54,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 0.5),
            child: Row(

              children: <Widget>[
                Expanded(
                  child: TextField(
                    autofocus: true,
                    onChanged: (v) => text = v,
                    maxLength: 220,
                    keyboardType: TextInputType.multiline,
                    style: bigMainTextFont,
                    maxLines: 10,
                    minLines: 1,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.lightBlue,
                    size: 28.0,
                  ),
                  onPressed: () {
                    var t = text.trim();
                    if (t.length == 0) {
                      Fluttertoast.showToast(msg: '不能为空');
                    } else {
                      widget.onSubmit(text);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
