import 'package:mtracersdkexample/appdto/clubshafthardness_type.dart';

class ClubInfoAppDto {
  late double clubLength;
  late double faceAngle;
  late double lieAngle;
  late double loftAngle;
  late ClubShaftHardnessType shaftHardness;
  late String clubId;
  late String headMakerName;
  late String headModel;
  late int mClubId;

  ClubInfoAppDto() {
    clubLength = 0.0;
    faceAngle = 0.0;
    lieAngle = 0.0;
    loftAngle = 0.0;
    shaftHardness = ClubShaftHardnessType.r;
    clubId = "";
    headMakerName = "";
    headModel = "";
    mClubId = 0;
  }
}
