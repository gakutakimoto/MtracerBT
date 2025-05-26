import 'dart:convert';

import 'package:mtracersdkexample/appdto/analyzeresult_type.dart';
import 'package:mtracersdkexample/appdto/swinggpsinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingheaderinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swinginfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingmeasurementinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingphaseinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingtrajectoryflatdetailinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingtrajectoryheaderinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingvzoneinfo_appdto.dart';
import 'package:mtracersdkexample/entity/mtswingdata_entity.dart';
import 'package:mtracersdkexample/entity/mtswinggpsdata_entity.dart';
import 'package:mtracersdkexample/entity/mtswingheaderdata_entity.dart';
import 'package:mtracersdkexample/entity/mtswingmeasurementdata_entity.dart';
import 'package:mtracersdkexample/entity/mtswingphasedata_entity.dart';
import 'package:mtracersdkexample/entity/mtswingtrajectoryflatdetaildata_entity.dart';
import 'package:mtracersdkexample/entity/mtswingtrajectoryheaderdata_entity.dart';
import 'package:mtracersdkexample/entity/mtswingvzonedata_entity.dart';
import 'package:mtracersdkexample/logic/club_logic.dart';
import 'package:mtracersdkexample/logicinterface/club_logicinterface.dart';
import 'package:mtracersdkexample/logicinterface/swing_logicinterface.dart';

class SwingLogic implements SwingLogicInterface {
  late ClubLogicInterface clubLogic;

  SwingLogic() {
    clubLogic = ClubLogic();
  }

  @override
  SwingHeaderInfoAppDto convertHeaderFromJson(final String rawJson) {
    final entity = MTSwingHeaderDataEntity.fromMap(json.decode(rawJson));
    return _convertToSwingHeaderInfo(entity);
  }

  @override
  SwingInfoAppDto convertFromJson(final String rawJson) {
    return _convertToSwingInfo(rawJson);
  }

  SwingInfoAppDto _convertToSwingInfo(final String rawJson) {
    final entity = MTSwingDataEntity.fromMap(json.decode(rawJson));
    final dto = SwingInfoAppDto();

    dto.raw = rawJson;

    dto.swingMeasurementInfo = _convertToSwingMeasurementInfo(entity.swingMeasurementData);
    dto.swingGPSInfo = _convertToSwingGPSInfo(entity.swingGPSData);
    switch (entity.analyzeResultType) {
      case 0:
        dto.analyzeResultType = AnalyzeResultType.noError;
        break;
      case 1:
        dto.analyzeResultType = AnalyzeResultType.inputSensorDataError;
        break;
      case 2:
        dto.analyzeResultType = AnalyzeResultType.inputClubLengthError;
        break;
      case 3:
        dto.analyzeResultType = AnalyzeResultType.inputFaceAngleError;
        break;
      case 4:
        dto.analyzeResultType = AnalyzeResultType.inputLieAngleError;
        break;
      case 5:
        dto.analyzeResultType = AnalyzeResultType.inputLoftAngleError;
        break;
      case 6:
        dto.analyzeResultType = AnalyzeResultType.inputShaftHardnessError;
        break;
      case 7:
        dto.analyzeResultType = AnalyzeResultType.outputERROR;
        break;
      case 8:
        dto.analyzeResultType = AnalyzeResultType.outputErrorAfterImpact;
        break;
      case 9:
        dto.analyzeResultType = AnalyzeResultType.inputAddressFaceAngleError;
        break;
      case 10:
        dto.analyzeResultType = AnalyzeResultType.inputUserInfoError;
        break;
      default:
        dto.analyzeResultType = AnalyzeResultType.outputERROR;
    }
    dto.swingVZoneInfo = _convertToSwingVZoneInfo(entity.swingVZoneData);
    dto.swingPhaseInfo = _convertToSwingPhaseInfo(entity.swingPhaseData);
    dto.swingHeaderInfo = _convertToSwingHeaderInfo(entity.swingHeaderData);
    dto.swingTrajectoryHeaderInfo = _convertToSwingTrajectoryHeaderInfo(entity.swingTrajectoryHeaderData);

    return dto;
  }

  SwingMeasurementInfoAppDto _convertToSwingMeasurementInfo(final MTSwingMeasurementDataEntity entity) {
    final dto = SwingMeasurementInfoAppDto();

    dto.impactHeadSpeed = entity.impactHeadSpeed;
    dto.impactGripSpeed = entity.impactGripSpeed;
    dto.maxHeadSpeed = entity.maxHeadSpeed;
    dto.maxGripSpeed = entity.maxGripSpeed;
    dto.impactFaceAngle = entity.impactFaceAngle;
    dto.impactFaceAngleType = entity.impactFaceAngleType;
    dto.impactRelativeFaceAngle = entity.impactRelativeFaceAngle;
    dto.impactClubPath = entity.impactClubPath;
    dto.impactClubPathType = entity.impactClubPathType;
    dto.impactAttackAngle = entity.impactAttackAngle;
    dto.impactAttackAngleType = entity.impactAttackAngleType;
    dto.impactLoftAngle = entity.impactLoftAngle;
    dto.impactShaftRotation = entity.impactShaftRotation;
    dto.downSwingShaftRotationMin = entity.downSwingShaftRotationMin;
    dto.downSwingShaftRotationMax = entity.downSwingShaftRotationMax;
    dto.addressLieAngle = entity.addressLieAngle;
    dto.impactLieAngle = entity.impactLieAngle;
    dto.naturalUncock = entity.naturalUncock;
    dto.naturalReleaseTiming = entity.naturalReleaseTiming;
    dto.swingTempo = entity.swingTempo;
    dto.estimateCarry = entity.estimateCarry;
    dto.impactPointX = entity.impactPointX;
    dto.impactPointXType = entity.impactPointXType;
    dto.impactPointY = entity.impactPointY;
    dto.impactPointYType = entity.impactPointYType;
    dto.halfwaybackFaceAngleToVertical = entity.halfwaybackFaceAngleToVertical;
    dto.topFaceAngleToHorizontal = entity.topFaceAngleToHorizontal;
    dto.halfwaydownFaceAngleToVertical = entity.halfwaydownFaceAngleToVertical;
    dto.impactHandFirst = entity.impactHandFirst;
    dto.addressHandFirst = entity.addressHandFirst;
    dto.swingHandedType = entity.swingHandedType;

    return dto;
  }

  SwingGPSInfoAppDto _convertToSwingGPSInfo(final MTSwingGPSDataEntity entity) {
    final dto = SwingGPSInfoAppDto();

    dto.latitude = entity.latitude;
    dto.longitude = entity.longitude;
    dto.altitude = entity.altitude;

    return dto;
  }

  SwingVZoneInfoAppDto _convertToSwingVZoneInfo(final MTSwingVZoneDataEntity entity) {
    final dto = SwingVZoneInfoAppDto();

    dto.vZoneUpperAngle = entity.vZoneUpperAngle;
    dto.vZoneUnderAngle = entity.vZoneUnderAngle;
    dto.vZoneABAngle = entity.vZoneABAngle;
    dto.vZoneBCAngle = entity.vZoneBCAngle;
    dto.vZoneCDAngle = entity.vZoneCDAngle;
    dto.vZoneDEAngle = entity.vZoneDEAngle;
    dto.hwbZoneAngle = entity.hwbZoneAngle;
    dto.topZoneAngle = entity.topZoneAngle;
    dto.nuZoneAngle = entity.nuZoneAngle;
    dto.hwdZoneAngle = entity.hwdZoneAngle;
    dto.hwbZoneArea = entity.hwbZoneArea;
    dto.topZoneArea = entity.topZoneArea;
    dto.nuZoneArea = entity.nuZoneArea;
    dto.hwdZoneArea = entity.hwdZoneArea;

    return dto;
  }

  SwingPhaseInfoAppDto _convertToSwingPhaseInfo(final MTSwingPhaseDataEntity entity) {
    final dto = SwingPhaseInfoAppDto();

    dto.isValidStart = entity.isValidStart;
    dto.isValidHWB = entity.isValidHWB;
    dto.isValidTop = entity.isValidTop;
    dto.isValidImpact = entity.isValidImpact;
    dto.isValidHWD = entity.isValidHWD;
    dto.isValidFinish = entity.isValidFinish;
    dto.isValidMaxHeadSpeed = entity.isValidMaxHeadSpeed;
    dto.isValidMaxGripSpeed = entity.isValidMaxGripSpeed;

    return dto;
  }

  SwingHeaderInfoAppDto _convertToSwingHeaderInfo(final MTSwingHeaderDataEntity entity) {
    final dto = SwingHeaderInfoAppDto();

    dto.index = entity.index;
    dto.isBroken = entity.isBroken;
    dto.swingInfoId = entity.swingInfoId;
    dto.userId = entity.userId;
    dto.serialNo = entity.serialNo;
    dto.fwMajorVersion = entity.fwMajorVersion;
    dto.fwMinorVersion = entity.fwMinorVersion;
    dto.fwPatchVersion = entity.fwPatchVersion;
    dto.dataVersion = entity.dataVersion;
    dto.algMajorVersion = entity.algMajorVersion;
    dto.algMinorVersion = entity.algMinorVersion;

    final swingDateAtLocal = DateTime.parse(entity.swingDate);
    final swingDateAtUtc = DateTime.utc(swingDateAtLocal.year, swingDateAtLocal.month, swingDateAtLocal.day, swingDateAtLocal.hour, swingDateAtLocal.minute, swingDateAtLocal.second);
    dto.swingDate = swingDateAtUtc;

    dto.timeZoneOffset = entity.timeZoneOffset;
    dto.dst = entity.dst;
    dto.swingDateAccuracy = entity.swingDateAccuracy;
    dto.profileGender = entity.profileGender;
    dto.profileHeight = entity.profileHeight;
    dto.profileBirthYear = entity.profileBirthYear;
    dto.profileBirthMonth = entity.profileBirthMonth;
    dto.profileBirthDay = entity.profileBirthDay;
    dto.clubLength = entity.clubLength;
    dto.clubFaceAngle = entity.clubFaceAngle;
    dto.clubLieAngle = entity.clubLieAngle;
    dto.clubLoftAngle = entity.clubLoftAngle;
    dto.clubShaftHardness = entity.clubShaftHardness;
    dto.clubMakerId = entity.clubMakerId;
    dto.clubId = entity.clubId;
    dto.clubNoType = clubLogic.getClubNoType(entity.clubId);
    dto.clubCategory = clubLogic.getClubCategoryType(entity.clubId);
    dto.swingType = entity.swingType;

    return dto;
  }

  SwingTrajectoryHeaderInfoAppDto _convertToSwingTrajectoryHeaderInfo(final MTSwingTrajectoryHeaderDataEntity entity) {
    final dto = SwingTrajectoryHeaderInfoAppDto();

    dto.indexStart = entity.indexStart;
    dto.indexHWB = entity.indexHWB;
    dto.indexTop = entity.indexTop;
    dto.indexImpact = entity.indexImpact;
    dto.indexHWD = entity.indexHWD;
    dto.indexFinish = entity.indexFinish;
    dto.indexMaxHeadSpeed = entity.indexMaxHeadSpeed;
    dto.indexMaxGripSpeed = entity.indexMaxGripSpeed;
    dto.swingTrajectoryFlatDetailInfo = _convertToSwingTrajectoryFlatDetailInfo(entity.trajectoryFlatDetailInfo);

    return dto;
  }

  SwingTrajectoryFlatDetailInfoAppDto _convertToSwingTrajectoryFlatDetailInfo(final MTSwingTrajectoryFlatDetailDataEntity entity) {
    final dto = SwingTrajectoryFlatDetailInfoAppDto();

    dto.headSpeeds = entity.headSpeeds;
    dto.gripSpeeds = entity.gripSpeeds;
    dto.elapsedTimes = entity.elapsedTimes;

    return dto;
  }
}
