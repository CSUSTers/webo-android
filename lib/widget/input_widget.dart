import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webo/contants/style.dart';

class BottomInputDialog extends StatefulWidget {
  final Function onSubmit;
  final Function onChange;
  final bool canEmpty;

  BottomInputDialog({this.onSubmit, this.onChange, this.canEmpty: false});

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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
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
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.lightBlue,
                    size: 28.0,
                  ),
                  onPressed: () {
                    var t = text.trim();
                    if (!widget.canEmpty && t.length == 0) {
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
