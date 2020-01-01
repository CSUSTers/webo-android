import 'package:flutter/material.dart';

class CircleImageWidget extends StatelessWidget {
  final ImageProvider image;
  final double radius;

  CircleImageWidget.fromImage({this.image, this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.radius,
      height: this.radius,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(fit: BoxFit.fill, image: image)),
    );
  }
}
