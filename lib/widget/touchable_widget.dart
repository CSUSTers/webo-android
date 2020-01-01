import 'package:flutter/material.dart';

class TapWidget extends StatelessWidget {
  final Function onTap;
  final Widget child;

  TapWidget(this.onTap, this.child);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: child,
    );
  }
}
