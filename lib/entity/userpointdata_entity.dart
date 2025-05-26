import 'userpointlogdata_entity.dart';

class UserPointDataEntity {
  late String userId;
  late double totalPoint;
  late String expiration;
  late int logCount;
  late List<UserPointLogDataEntity> userPointLogDatas;

  UserPointDataEntity() {
    userId = "";
    totalPoint = 0.0;
    expiration = "";
    logCount = 0;
    userPointLogDatas = [];
  }

  UserPointDataEntity.fromMap(final Map<String, dynamic> map) {
    userId = map.containsKey("userId") ? map["userId"] : "";
    totalPoint = map.containsKey("point") ? double.parse(map["point"].toString()) : 0.0;
    expiration = map.containsKey("expiration") ? map["expiration"] : "";
    logCount = map.containsKey("logCount") ? int.parse(map["logCount"].toString()) : 0;

    userPointLogDatas = [];
    if (map.containsKey("logs") && map["logs"] != null) {
      userPointLogDatas = [];
      for (final Map<String, dynamic> entity in map["logs"]) {
        final UserPointLogDataEntity pointLogData = UserPointLogDataEntity.fromMap(entity);
        userPointLogDatas.add(pointLogData);
      }
    }
  }
}
