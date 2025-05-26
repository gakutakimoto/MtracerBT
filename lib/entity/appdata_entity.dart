class AppDataEntity {
  late String version;
  late int isAccepted;

  AppDataEntity() {
    version = "";
    isAccepted = 0;
  }

  AppDataEntity.fromMap(final Map<String, dynamic> map) {
    version = map.containsKey("version") ? map["version"] : "";
    isAccepted = map.containsKey("isAccepted") ? (map["isAccepted"] as num) as int : 0;
  }
}
