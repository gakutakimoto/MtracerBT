class SwingHeaderIndexesDataEntity {
  late String swingInfoId;
  late String swingDate;
  late String golfClubSubId;
  late double impactHeadSpeed;
  late double estimateCarry;
  late double impactAttackAngle;
  late int impactAttackAngleType;
  late double impactClubPath;
  late int impactClubPathType;
  late double impactFaceAngle;
  late int impactFaceAngleType;

  SwingHeaderIndexesDataEntity() {
    swingInfoId = "";
    swingDate = "";
    golfClubSubId = "";
    impactHeadSpeed = 0.0;
    estimateCarry = 0.0;
    impactAttackAngle = 0.0;
    impactClubPath = 0.0;
    impactFaceAngle = 0.0;
  }

  SwingHeaderIndexesDataEntity.fromMap(final Map<String, dynamic> map) {
    swingInfoId = map.containsKey("swingInfoId") ? map["swingInfoId"] : "";
    swingDate = map.containsKey("swingDate") ? map["swingDate"] : "";
    golfClubSubId = map.containsKey("golfClubSubId") ? map["golfClubSubId"] : "";
    impactHeadSpeed = map.containsKey("impactHeadSpeed") ? ((map["impactHeadSpeed"] as num) as double) * 1.0 : 0.0;
    estimateCarry = map.containsKey("estimateCarry") ? ((map["estimateCarry"] as num) as double) * 1.0 : 0.0;
    impactAttackAngle = map.containsKey("impactAttackAngle") ? ((map["impactAttackAngle"] as num) as double) * 1.0 : 0.0;
    impactAttackAngleType = map.containsKey("impactAttackAngleType") ? ((map["impactAttackAngleType"] as num) as int) * 1 : 0;
    impactClubPath = map.containsKey("impactClubPath") ? ((map["impactClubPath"] as num) as double) * 1.0 : 0.0;
    impactClubPathType = map.containsKey("impactClubPathType") ? ((map["impactClubPathType"] as num) as int) * 1 : 0;
    impactFaceAngle = map.containsKey("impactFaceAngle") ? ((map["impactFaceAngle"] as num) as double) * 1.0 : 0.0;
    impactFaceAngleType = map.containsKey("impactFaceAngleType") ? ((map["impactFaceAngleType"] as num) as int) * 1 : 0;
  }
}
