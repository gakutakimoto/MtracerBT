import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:mtracersdkexample/logicinterface/stringcodec_logicinterface.dart';

class StringCodecLogic implements StringCodecLogicInterface {
  StringCodecLogic();

  @override
  String encode(final String src) {
    List<int> dst = [];

    for (final srcCode in src.codeUnits) {
      dst.add(srcCode ^ 0xFF);
    }

    return base64.encode(dst);
  }

  @override
  String decode(final String src) {
    List<int> dst = [];

    for (final srcCode in base64.decode(src)) {
      dst.add(srcCode ^ 0xFF);
    }

    return String.fromCharCodes(dst);
  }

  @override
  String encrypt(final String key, final String iv, final String src, {final AESMode mode = AESMode.sic}) {
    final encryptkey = Key.fromUtf8(key);
    final encryptIv = IV.fromUtf8(iv);
    final encrypter = Encrypter(AES(encryptkey, mode: mode));

    final encrypted = encrypter.encrypt(src, iv: encryptIv);

    return encrypted.base64;
  }

  @override
  String decrypt(final String key, final String iv, final String src, {final AESMode mode = AESMode.sic}) {
    final encryptkey = Key.fromUtf8(key);
    final encryptIv = IV.fromUtf8(iv);
    final encrypter = Encrypter(AES(encryptkey, mode: mode));

    return encrypter.decrypt(Encrypted.fromBase64(src), iv: encryptIv);
  }
}
