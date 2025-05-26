class MTHWDataEntity {
  late String serialNo;

  MTHWDataEntity() {
    serialNo = "";
  }

  MTHWDataEntity.fromMap(final Map<String, dynamic> map) {
    serialNo = map.containsKey("serialNo") ? map["serialNo"] : "";
  }
}
