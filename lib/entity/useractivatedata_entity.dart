class UserActivateDataEntity {
  late String logId;
  late String at;
  late String userId;
  late String modelName;
  late String serialNo;
  late String fwVersion;

  UserActivateDataEntity() {
    logId = "";
    at = "";
    userId = "";
    modelName = "";
    serialNo = "";
    fwVersion = "";
  }

  UserActivateDataEntity.fromMap(final Map<String, dynamic> map) {
    logId = map.containsKey("logId") ? map["logId"] : "";
    userId = map.containsKey("userId") ? map["userId"] : "";
    modelName = map.containsKey("modelName") ? map["modelName"] : "";
    serialNo = map.containsKey("serialNo") ? map["serialNo"] : "";
    fwVersion = map.containsKey("fwVersion") ? map["fwVersion"] : "";
    at = map.containsKey("at") ? map["at"] : "";
  }
}
