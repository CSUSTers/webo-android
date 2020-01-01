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

CircleImageWidget getImageOfEmail(String email, {int size: 128}) {
  var url = urlForGravatar(gravatarForEmail(email), size);
  return CircleImageWidget.fromImage(
    image: NetworkImage(url),
    radius: size.toDouble() / 2.0
  );
}

CircleImageWidget getImageForUser(User user, {int size: 128}) =>
    getImageOfEmail(user.email ?? "", size: size);