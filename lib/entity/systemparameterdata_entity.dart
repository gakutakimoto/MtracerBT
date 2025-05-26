class SystemParameterDataEntity {
  late String decryptSICKey;
  late String decryptSICIv;
  late String decryptCBCKey;
  late String decryptCBCIv;

  SystemParameterDataEntity() {
    decryptSICKey = "";
    decryptSICIv = "";
    decryptCBCKey = "";
    decryptCBCIv = "";
  }

  SystemParameterDataEntity.fromMap(final Map<String, dynamic> map) {
    decryptSICKey = map.containsKey("decryptKey1") ? map["decryptKey1"] : "";
    decryptSICIv = map.containsKey("decryptKey2") ? map["decryptKey2"] : "";
    decryptCBCKey = map.containsKey("decryptKey3") ? map["decryptKey3"] : "";
    decryptCBCIv = map.containsKey("decryptKey4") ? map["decryptKey4"] : "";
  }
}
