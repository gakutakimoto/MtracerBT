import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/withdrawalreason_type.dart';

abstract class UserServiceInterface {
  Future<UserInfoAppDto?> getUserInfo();
  Future<void> withdrawUser(final WithdrawalReasonType reasonType, final String comment);
}
