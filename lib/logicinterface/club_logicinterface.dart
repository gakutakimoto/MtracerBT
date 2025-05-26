import 'package:mtracersdkexample/appdto/impactattackangle_type.dart';
import 'package:mtracersdkexample/appdto/clubcategorytype.dart';
import 'package:mtracersdkexample/appdto/clubno_type.dart';
import 'package:mtracersdkexample/appdto/impactclubpathtype_type.dart';
import 'package:mtracersdkexample/appdto/impactfaceangle_type.dart';

abstract class ClubLogicInterface {
  ClubNoType getClubNoType(final String golfClubSubId);
  ClubCategoryType getClubCategoryType(final String golfClubSubId);
  ImpactAttackAngleType getImpactAttackAngleType(final int impactAttackAngleType);
  ImpactClubPathType getImpactClubPathType(final int impactClubPathType);
  ImpactFaceAngleType getImpactFaceAngleType(final int impactFaceAngleType);
}
