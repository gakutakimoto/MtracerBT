import 'package:mtracersdkexample/appdto/validation_type.dart';

abstract class ProfileLogicInterface {
  ValidationType validateUserId(final String? value);
  ValidationType validatePassword(final String? value);
}
