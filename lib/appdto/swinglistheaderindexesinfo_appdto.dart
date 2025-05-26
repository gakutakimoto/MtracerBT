import 'package:mtracersdkexample/appdto/clubcategorytype.dart';
import 'package:mtracersdkexample/appdto/clubno_type.dart';
import 'package:mtracersdkexample/appdto/impactattackangle_type.dart';
import 'package:mtracersdkexample/appdto/impactclubpathtype_type.dart';
import 'package:mtracersdkexample/appdto/impactfaceangle_type.dart';

class SwingListHeaderIndexesInfoAppDto {
  late String swingInfoId;
  late DateTime swingDate;
  late String golfClubSubId;
  late ClubNoType clubNoType;
  late ClubCategoryType clubCategoryType;
  late double impactHeadSpeed;
  late double estimateCarry;
  late double impactAttackAngle;
  late ImpactAttackAngleType impactAttackAngleType;
  late double impactClubPath;
  late ImpactClubPathType impactClubPathType;
  late double impactFaceAngle;
  late ImpactFaceAngleType impactFaceAngleType;

  SwingListHeaderIndexesInfoAppDto() {
    swingInfoId = "";
    swingDate = DateTime.now();
    golfClubSubId = "";
    clubNoType = ClubNoType.other;
    clubCategoryType = ClubCategoryType.unknown;
    impactHeadSpeed = 0.0;
    estimateCarry = 0.0;
    impactAttackAngle = 0.0;
    impactAttackAngleType = ImpactAttackAngleType.other;
    impactClubPath = 0.0;
    impactClubPathType = ImpactClubPathType.other;
    impactFaceAngle = 0.0;
    impactFaceAngleType = ImpactFaceAngleType.other;
  }
}
