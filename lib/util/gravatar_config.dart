import 'package:flutter/cupertino.dart';
import 'package:simple_gravatar/simple_gravatar.dart';
import 'package:webo/contants/user.dart';
import 'package:webo/widget/circle_image.dart';

Gravatar gravatarForEmail(String email) {
  return Gravatar(email);
}

String urlForGravatar(Gravatar gravatar, int size) {
  return gravatar.imageUrl(
    size: size,
    defaultImage: GravatarImage.retro,
    rating: GravatarRating.pg,
    fileExtension: true,
  );
}

NetworkImage getImageOfEmail(String email, {int size: 128}) {
  var url = urlForGravatar(gravatarForEmail(email), size);
  return NetworkImage(url);
}

CircleImageWidget getCircleImageForUser(User user, {int size: 128}) =>
    CircleImageWidget.fromImage(
      image: getImageOfEmail(user.email ?? '', size: size),
      radius: size.toDouble() / 2.0,
    );

NetworkImage getImageForUser(User user, {int size: 128}) =>
    getImageOfEmail(user.email ?? '', size: size);
