import 'package:encrypt/encrypt.dart';

abstract class StringCodecLogicInterface {
  String encode(final String src);
  String decode(final String src);
  String encrypt(final String key, final String iv, final String src, {final AESMode mode = AESMode.sic});
  String decrypt(final String key, final String iv, final String src, {final AESMode mode = AESMode.sic});
}
