import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;

abstract class MD5 {
  static md5(String data) {
    var content = utf8.encode(data);
    var tmp = crypto.md5.convert(content);
    return hex.encode(tmp.bytes);
  }
}
