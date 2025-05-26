import 'package:mtracersdkexample/appdto/clubcategorytype.dart';
import 'package:mtracersdkexample/appdto/clubno_type.dart';

class SwingHeaderInfoAppDto {
  late int index;
  late bool isBroken;
  late String swingInfoId;
  late String userId;
  late String serialNo;
  late int fwMajorVersion;
  late int fwMinorVersion;
  late int fwPatchVersion;
  late int dataVersion;
  late int algMajorVersion;
  late int algMinorVersion;
  late DateTime swingDate;
  late int timeZoneOffset;
  late int dst;
  late int swingDateAccuracy;
  late int profileGender;
  late double profileHeight;
  late int profileBirthYear;
  late int profileBirthMonth;
  late int profileBirthDay;
  late double clubLength;
  late double clubFaceAngle;
  late double clubLieAngle;
  late double clubLoftAngle;
  late int clubShaftHardness;
  late int clubMakerId;
  late String clubId;
  late ClubNoType clubNoType;
  late ClubCategoryType clubCategory;
  late int swingType;

  SwingHeaderInfoAppDto() {
    index = 0;
    isBroken = false;
    swingInfoId = "";
    userId = "";
    serialNo = "";
    fwMajorVersion = 0;
    fwMinorVersion = 0;
    fwPatchVersion = 0;
    dataVersion = 0;
    algMajorVersion = 0;
    algMinorVersion = 0;
    swingDate = DateTime(1900);
    timeZoneOffset = 0;
    dst = 0;
    swingDateAccuracy = 0;
    profileGender = 0;
    profileHeight = 0.0;
    profileBirthYear = 0;
    profileBirthMonth = 0;
    profileBirthDay = 0;
    clubLength = 0.0;
    clubFaceAngle = 0.0;
    clubLieAngle = 0.0;
    clubLoftAngle = 0.0;
    clubShaftHardness = 2;
    clubMakerId = 0;
    clubId = "";
    clubNoType = ClubNoType.other;
    clubCategory = ClubCategoryType.wood;
    swingType = 0;
  }
}
