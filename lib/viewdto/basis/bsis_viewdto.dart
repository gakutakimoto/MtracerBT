class BasisViewDto {
  late int batteryLevel;
  late bool isReceiveImpact;
  late bool isReceiveSwingInfo;
  late int index;
  late double impactHeadSpeed;

  BasisViewDto() {
    batteryLevel = 0;
    isReceiveImpact = false;
    isReceiveSwingInfo = false;
    index = 0;
    impactHeadSpeed = 0.0;
  }
}
