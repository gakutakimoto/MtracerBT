package com.u5007710.mtracer.golf.sdk.example.dto

import com.epson.mtracer.sdk.dto.*

class SwingInfoDtoGson constructor (_headerInfo: SwingHeaderInfoDto,
                                    _vendorId: String,
                                    _swingData: Array<UByte>,
                                    _gpsInfo: GPSInfoDto,
                                    _analyzeResultType: SwingAnalyzeResyltType,
                                    _swingPhaseInfo: SwingPhaseInfoDto,
                                    _measurementInfo: SwingMeasurementInfoDto,
                                    _trajectoryInfo: SwingTrajectoryHeaderInfoDto,
                                    _sensorInfo: SwingSensorHeaderInfoDto,
                                    _vZoneInfo: SwingVZoneInfoDto) {
    var headerInfo = SwingHeaderInfoDtoGson(_headerInfo.index.toUShort(),
        _headerInfo.isBroken,
        _headerInfo.swingInfoId,
        _headerInfo.userId,
        _headerInfo.serialNo,
        _headerInfo.fwMajorVersion,
        _headerInfo.fwMinorVersion,
        _headerInfo.fwPatchVersion,
        _headerInfo.dataVersion,
        _headerInfo.algMajorVersion,
        _headerInfo.algMinorVersion,
        _headerInfo.swingDate,
        _headerInfo.timeZoneOffset,
        _headerInfo.dst,
        _headerInfo.swingDateAccuracy,
        _headerInfo.profileGender,
        _headerInfo.profileHeight,
        _headerInfo.profileBirthYear,
        _headerInfo.profileBirthMonth,
        _headerInfo.profileBirthDay,
        _headerInfo.clubLength,
        _headerInfo.clubFaceAngle,
        _headerInfo.clubLieAngle,
        _headerInfo.clubLoftAngle,
        _headerInfo.clubShaftHardness,
        _headerInfo.clubMakerId,
        _headerInfo.clubId,
        _headerInfo.swingType
    )
    var vendorId = _vendorId
    var swingData = _swingData
    var gpsInfo = _gpsInfo
    var analyzeResultType = _analyzeResultType.rawValue
    var swingPhaseInfo = _swingPhaseInfo
    var measurementInfo = SwingMeasurementInfoDtoGson (
        _measurementInfo.impactHeadSpeed,
        _measurementInfo.impactGripSpeed,
        _measurementInfo.maxHeadSpeed,
        _measurementInfo.maxGripSpeed,
        _measurementInfo.impactFaceAngle,
        _measurementInfo.impactFaceAngleType,
        _measurementInfo.impactRelativeFaceAngle,
        _measurementInfo.impactClubPath,
        _measurementInfo.impactClubPathType,
        _measurementInfo.impactAttackAngle,
        _measurementInfo.impactAttackAngleType,
        _measurementInfo.impactLoftAngle,
        _measurementInfo.impactShaftRotation,
        _measurementInfo.downSwingShaftRotationMin,
        _measurementInfo.downSwingShaftRotationMax,
        _measurementInfo.addressLieAngle,
        _measurementInfo.impactLieAngle,
        _measurementInfo.naturalUncock,
        _measurementInfo.naturalReleaseTiming,
        _measurementInfo.swingTempo,
        _measurementInfo.estimateCarry,
        _measurementInfo.impactPointX,
        _measurementInfo.impactPointXType,
        _measurementInfo.impactPointY,
        _measurementInfo.impactPointYType,
        _measurementInfo.halfwaybackFaceAngleToVertical,
        _measurementInfo.topFaceAngleToHorizontal,
        _measurementInfo.halfwaydownFaceAngleToVertical,
        _measurementInfo.impactHandFirst,
        _measurementInfo.addressHandFirst,
        _measurementInfo.swingHandedType
    )
    var trajectoryInfo = _trajectoryInfo
    var sensorInfo = _sensorInfo
    var vZoneInfo = SwingVZoneInfoDtoGson(
        _vZoneInfo.vZoneUpperAngle,
        _vZoneInfo.vZoneUnderAngle,
        _vZoneInfo.vZoneABAngle,
        _vZoneInfo.vZoneBCAngle,
        _vZoneInfo.vZoneCDAngle,
        _vZoneInfo.vZoneDEAngle,
        _vZoneInfo.hwbZoneAngle,
        _vZoneInfo.topZoneAngle,
        _vZoneInfo.nuZoneAngle,
        _vZoneInfo.hwdZoneAngle,
        _vZoneInfo.hwbZoneArea,
        _vZoneInfo.topZoneArea,
        _vZoneInfo.nuZoneArea,
        _vZoneInfo.hwdZoneArea)
}