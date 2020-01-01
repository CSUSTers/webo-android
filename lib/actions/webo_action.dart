import 'package:flutter/material.dart';
import 'package:webo/contants/webo.dart';
import 'package:webo/widget/input_widget.dart';
import 'package:webo/widget/pop_route.dart';

void openMenu(WebO webo) {}


void inputText(BuildContext context, {onSubmit}) {
  Navigator.push(context, PopRoute(
      child: BottomInputDialog(
        onSubmit: onSubmit,
      ),
  ));
}