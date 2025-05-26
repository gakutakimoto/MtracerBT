class UserPointLogDataEntity {
  late String userId;
  late String logId;
  late double point;
  late String at;
  late String pointRuleId;
  late String pointRuleName;
  late String pointTypeId;
  late String pointTypeName;

  UserPointLogDataEntity() {
    userId = "";
    logId = "";
    point = 0.0;
    at = "";
    pointRuleId = "";
    pointRuleName = "";
    pointTypeId = "";
    pointTypeName = "";
  }

  UserPointLogDataEntity.fromMap(final Map<String, dynamic> map) {
    userId = map.containsKey("userId") ? map["userId"] : "";
    logId = map.containsKey("logId") ? map["logId"] : "";
    point = map.containsKey("point") ? double.parse(map["point"].toString()) : 0.0;
    at = map.containsKey("at") ? map["at"] : "";
    pointRuleId = (map.containsKey("pointRuleId") && map["pointRuleId"] != null) ? map["pointRuleId"] : "";
    pointRuleName = (map.containsKey("pointRuleName") && map["pointRuleName"] != null) ? map["pointRuleName"] : "";
    pointTypeId = map.containsKey("pointTypeId") ? map["pointTypeId"] : "";
    pointTypeName = map.containsKey("pointTypeName") ? map["pointTypeName"] : "";
  }
}
