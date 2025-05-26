class RegisterSwingInputAppDto {
  late String swingId;
  late String userId;
  late int isExistVideo;
  late int isFavorite;
  late String memo;
  late String rawData;

  //tbd
  //delete
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

  RegisterSwingInputAppDto() {
    swingId = "";
    userId = "";
    isExistVideo = 0;
    isFavorite = 0;
    memo = "";
    rawData = "";

    swingInfoId = "";
    swingDate = "";
    golfClubSubId = "";
    impactHeadSpeed = 0.0;
    estimateCarry = 0.0;
    impactAttackAngle = 0.0;
    impactAttackAngleType = 0;
    impactClubPath = 0.0;
    impactClubPathType = 0;
    impactFaceAngle = 0.0;
    impactFaceAngleType = 0;
  }
}
