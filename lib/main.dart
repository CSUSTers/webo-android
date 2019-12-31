import 'package:flutter/material.dart';
import 'package:webo/util/prefs.dart';
import 'view/main_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  runApp(WebOApp());
}
