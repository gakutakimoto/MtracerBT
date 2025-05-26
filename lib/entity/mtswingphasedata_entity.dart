class MTSwingPhaseDataEntity {
  late bool isValidStart;
  late bool isValidHWB;
  late bool isValidTop;
  late bool isValidImpact;
  late bool isValidHWD;
  late bool isValidFinish;
  late bool isValidMaxHeadSpeed;
  late bool isValidMaxGripSpeed;

  MTSwingPhaseDataEntity() {
    isValidStart = false;
    isValidHWB = false;
    isValidTop = false;
    isValidImpact = false;
    isValidHWD = false;
    isValidFinish = false;
    isValidMaxHeadSpeed = false;
    isValidMaxGripSpeed = false;
  }

  MTSwingPhaseDataEntity.fromMap(final Map<String, dynamic> map) {
    isValidStart = map.containsKey("isValidStart") ? map["isValidStart"] : false;
    isValidHWB = map.containsKey("isValidHWB") ? map["isValidHWB"] : false;
    isValidTop = map.containsKey("isValidTop") ? map["isValidTop"] : false;
    isValidImpact = map.containsKey("isValidImpact") ? map["isValidImpact"] : false;
    isValidHWD = map.containsKey("isValidHWD") ? map["isValidHWD"] : false;
    isValidFinish = map.containsKey("isValidFinish") ? map["isValidFinish"] : false;
    isValidMaxHeadSpeed = map.containsKey("isValidMaxHeadSpeed") ? map["isValidMaxHeadSpeed"] : false;
    isValidMaxGripSpeed = map.containsKey("isValidMaxGripSpeed") ? map["isValidMaxGripSpeed"] : false;
  }
}
