import 'package:mtracersdkexample/appdto/impactattackangle_type.dart';
import 'package:mtracersdkexample/appdto/clubcategorytype.dart';
import 'package:mtracersdkexample/appdto/clubno_type.dart';
import 'package:mtracersdkexample/appdto/impactclubpathtype_type.dart';
import 'package:mtracersdkexample/appdto/impactfaceangle_type.dart';
import 'package:mtracersdkexample/logicinterface/club_logicinterface.dart';

class ClubLogic extends ClubLogicInterface {
  @override
  ClubNoType getClubNoType(final String golfClubSubId) {
    if (golfClubSubId.isEmpty) {
      return ClubNoType.other;
    }

    switch (golfClubSubId.substring(0, 2)) {
      case "00":
        return ClubNoType.w1;
      case "01":
        return ClubNoType.w3;
      case "02":
        return ClubNoType.w5;
      case "03":
        return ClubNoType.w7;
      case "04":
        return ClubNoType.w9;
      case "05":
        return ClubNoType.w11;
      case "06":
        return ClubNoType.h2;
      case "07":
        return ClubNoType.h3;
      case "08":
        return ClubNoType.h4;
      case "09":
        return ClubNoType.h5;
      case "0A":
        return ClubNoType.h6;
      case "0B":
        return ClubNoType.i2;
      case "0C":
        return ClubNoType.i3;
      case "0D":
        return ClubNoType.i4;
      case "0E":
        return ClubNoType.i5;
      case "0F":
        return ClubNoType.i6;
      case "10":
        return ClubNoType.i7;
      case "11":
        return ClubNoType.i8;
      case "12":
        return ClubNoType.i9;
      case "13":
        return ClubNoType.pw;
      case "14":
        return ClubNoType.awuw;
      case "15":
        return ClubNoType.sw;
      case "16":
        return ClubNoType.lw;
      case "17":
        return ClubNoType.four6;
      case "18":
        return ClubNoType.four8;
      case "19":
        return ClubNoType.five0;
      case "1A":
        return ClubNoType.five2;
      case "1B":
        return ClubNoType.five4;
      case "1C":
        return ClubNoType.five6;
      case "1D":
        return ClubNoType.five8;
      case "1E":
        return ClubNoType.six0;
      default:
        return ClubNoType.other;
    }
  }

  @override
  ClubCategoryType getClubCategoryType(final String golfClubSubId) {
    if (golfClubSubId.isEmpty) {
      return ClubCategoryType.unknown;
    }

    switch (golfClubSubId.substring(0, 2)) {
      case "00":
      case "01":
      case "02":
      case "03":
      case "04":
      case "05":
        return ClubCategoryType.wood;
      case "06":
      case "07":
      case "08":
      case "09":
      case "0A":
        return ClubCategoryType.hybridUtility;
      case "0B":
      case "0C":
      case "0D":
      case "0E":
      case "0F":
      case "10":
      case "11":
      case "12":
        return ClubCategoryType.iron;
      case "13":
      case "14":
      case "15":
      case "16":
        return ClubCategoryType.wedge;
      case "17":
      case "18":
      case "19":
      case "1A":
      case "1B":
      case "1C":
      case "1D":
      case "1E":
        return ClubCategoryType.hybridUtility;
      default:
        return ClubCategoryType.unknown;
    }
  }

  @override
  ImpactAttackAngleType getImpactAttackAngleType(final int impactAttackAngleType) {
    switch (impactAttackAngleType) {
      case 0:
        return ImpactAttackAngleType.upper;
      case 1:
        return ImpactAttackAngleType.level;
      case 2:
        return ImpactAttackAngleType.down;
      default:
        return ImpactAttackAngleType.other;
    }
  }

  @override
  ImpactClubPathType getImpactClubPathType(final int impactClubPathType) {
    switch (impactClubPathType) {
      case 0:
        return ImpactClubPathType.inout;
      case 1:
        return ImpactClubPathType.inin;
      case 2:
        return ImpactClubPathType.outin;
      default:
        return ImpactClubPathType.other;
    }
  }

  @override
  ImpactFaceAngleType getImpactFaceAngleType(final int impactFaceAngleType) {
    switch (impactFaceAngleType) {
      case 0:
        return ImpactFaceAngleType.open;
      case 1:
        return ImpactFaceAngleType.square;
      case 2:
        return ImpactFaceAngleType.close;
      default:
        return ImpactFaceAngleType.other;
    }
  }
}
