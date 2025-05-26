class UserActivateInfoAppDto {
  late String logId;
  late DateTime at;
  late String userId;
  late String modelName;
  late String serialNo;
  late String fwVersion;

  UserActivateInfoAppDto() {
    logId = "";
    at = DateTime.now();
    userId = "";
    modelName = "";
    serialNo = "";
    fwVersion = "";
  }
}
