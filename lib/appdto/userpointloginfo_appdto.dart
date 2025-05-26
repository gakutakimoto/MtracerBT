import 'package:mtracersdkexample/appdto/point_type.dart';

class UserPointLogInfoAppDto {
  late String userId;
  late String logId;
  late double point;
  late DateTime acquiredDate;
  late String pointTypeId;
  late String pointTypeName;
  late PointType pointType;

  UserPointLogInfoAppDto() {
    userId = "";
    logId = "";
    point = 0.0;
    acquiredDate = DateTime.now();
    pointTypeId = "";
    pointTypeName = "その他";
    pointType = PointType.etc;
  }
}
