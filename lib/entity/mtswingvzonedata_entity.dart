class MTSwingVZoneDataEntity {
  late double vZoneUpperAngle;
  late double vZoneUnderAngle;
  late double vZoneABAngle;
  late double vZoneBCAngle;
  late double vZoneCDAngle;
  late double vZoneDEAngle;
  late double hwbZoneAngle;
  late double topZoneAngle;
  late double nuZoneAngle;
  late double hwdZoneAngle;
  late int hwbZoneArea;
  late int topZoneArea;
  late int nuZoneArea;
  late int hwdZoneArea;

  MTSwingVZoneDataEntity() {
    vZoneUpperAngle = 0.0;
    vZoneUnderAngle = 0.0;
    vZoneABAngle = 0.0;
    vZoneBCAngle = 0.0;
    vZoneCDAngle = 0.0;
    vZoneDEAngle = 0.0;
    hwbZoneAngle = 0.0;
    topZoneAngle = 0.0;
    nuZoneAngle = 0.0;
    hwdZoneAngle = 0.0;
    hwbZoneArea = 0;
    topZoneArea = 0;
    nuZoneArea = 0;
    hwdZoneArea = 0;
  }

  MTSwingVZoneDataEntity.fromMap(final Map<String, dynamic> map) {
    vZoneUpperAngle = map.containsKey("vZoneUpperAngle") ? double.parse(map["vZoneUpperAngle"].toString()) : 0.0;
    vZoneUnderAngle = map.containsKey("vZoneUnderAngle") ? double.parse(map["vZoneUnderAngle"].toString()) : 0.0;
    vZoneABAngle = map.containsKey("vZoneABAngle") ? double.parse(map["vZoneABAngle"].toString()) : 0.0;
    vZoneBCAngle = map.containsKey("vZoneBCAngle") ? double.parse(map["vZoneBCAngle"].toString()) : 0.0;
    vZoneCDAngle = map.containsKey("vZoneCDAngle") ? double.parse(map["vZoneCDAngle"].toString()) : 0.0;
    vZoneDEAngle = map.containsKey("vZoneDEAngle") ? double.parse(map["vZoneDEAngle"].toString()) : 0.0;
    hwbZoneAngle = map.containsKey("hwbZoneAngle") ? double.parse(map["hwbZoneAngle"].toString()) : 0.0;
    topZoneAngle = map.containsKey("topZoneAngle") ? double.parse(map["topZoneAngle"].toString()) : 0.0;
    nuZoneAngle = map.containsKey("nuZoneAngle") ? double.parse(map["nuZoneAngle"].toString()) : 0.0;
    hwdZoneAngle = map.containsKey("hwdZoneAngle") ? double.parse(map["hwdZoneAngle"].toString()) : 0.0;
    hwbZoneArea = map.containsKey("hwbZoneArea") ? int.parse(map["hwbZoneArea"].toString()) : 0;
    topZoneArea = map.containsKey("topZoneArea") ? int.parse(map["topZoneArea"].toString()) : 0;
    nuZoneArea = map.containsKey("nuZoneArea") ? int.parse(map["nuZoneArea"].toString()) : 0;
    hwdZoneArea = map.containsKey("hwdZoneArea") ? int.parse(map["hwdZoneArea"].toString()) : 0;
  }
}
