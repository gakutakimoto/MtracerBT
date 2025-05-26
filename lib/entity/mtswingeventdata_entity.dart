class MTSwingEventDataEntity {
  late String impactId;
  late bool isExist;
  late int index;

  MTSwingEventDataEntity() {
    impactId = "";
    isExist = false;
    index = 0;
  }

  MTSwingEventDataEntity.fromMap(final Map<String, dynamic> map) {
    impactId = map.containsKey("impactId") ? map["impactId"] : "";
    isExist = map.containsKey("isExist")
        ? ((map["isExist"] as num) as int == 1)
            ? true
            : false
        : false;
    index = map.containsKey("index") ? (map["index"] as num) as int : 0;
  }
}
