class MTFWDataEntity {
  late String versionNo;

  MTFWDataEntity() {
    versionNo = "";
  }

  MTFWDataEntity.fromMap(final Map<String, dynamic> map) {
    versionNo = map.containsKey("versionNo") ? map["versionNo"] : "";
  }
}
