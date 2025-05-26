import 'package:mtracersdkexample/appdto/userpointloginfo_appdto.dart';

class UserPointInfoAppDto {
  late String userId;
  late double totalPoint;
  late DateTime expiration;
  late int logCount;
  late List<UserPointLogInfoAppDto> userPointLogInfos;

  UserPointInfoAppDto() {
    userId = "";
    totalPoint = 0.0;
    expiration = DateTime(1900);
    logCount = 0;
    userPointLogInfos = [];
  }
}
