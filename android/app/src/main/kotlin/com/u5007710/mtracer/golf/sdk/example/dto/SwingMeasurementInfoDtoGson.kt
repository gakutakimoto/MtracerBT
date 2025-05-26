package com.u5007710.mtracer.golf.sdk.example.dto

import com.epson.mtracer.sdk.dto.*

class SwingMeasurementInfoDtoGson(impactHeadSpeed: Float,
                                  impactGripSpeed: Float,
                                  maxHeadSpeed: Float,
                                  maxGripSpeed: Float,
                                  impactFaceAngle: Float,
                                  impactFaceAngleType: ImpactFaceAngleType,
                                  impactRelativeFaceAngle: Float,
                                  impactClubPath: Float,
                                  impactClubPathType: ImpactClubPathType,
                                  impactAttackAngle: Float,
                                  impactAttackAngleType: ImpactAttackAngleType,
                                  impactLoftAngle: Float,
                                  impactShaftRotation: Float,
                                  downSwingShaftRotationMin: Float,
                                  downSwingShaftRotationMax: Float,
                                  addressLieAngle: Float,
                                  impactLieAngle: Float,
                                  naturalUncock: Float,
                                  naturalReleaseTiming: Float,
                                  swingTempo: Float,
                                  estimateCarry: Float,
                                  impactPointX: Float,
                                  impactPointXType: ImpactPointXType,
                                  impactPointY: Float,
                                  impactPointYType: ImpactPointYType,
                                  halfwaybackFaceAngleToVertical: Float,
                                  topFaceAngleToHorizontal: Float,
                                  halfwaydownFaceAngleToVertical: Float,
                                  impactHandFirst: Float,
                                  addressHandFirst: Float,
                                  swingHandedType: SwingHandedType) {

    var impactHeadSpeed = impactHeadSpeed
    var impactGripSpeed = impactGripSpeed
    var maxHeadSpeed = maxHeadSpeed
    var maxGripSpeed = maxGripSpeed
    var impactFaceAngle = impactFaceAngle
    var impactFaceAngleType = impactFaceAngleType.rawValue
    var impactRelativeFaceAngle = impactRelativeFaceAngle
    var impactClubPath = impactClubPath
    var impactClubPathType = impactClubPathType.rawValue
    var impactAttackAngle = impactAttackAngle
    var impactAttackAngleType = impactAttackAngleType.rawValue
    var impactLoftAngle = impactLoftAngle
    var impactShaftRotation = impactShaftRotation
    var downSwingShaftRotationMin = downSwingShaftRotationMin
    var downSwingShaftRotationMax = downSwingShaftRotationMax
    var addressLieAngle = addressLieAngle
    var impactLieAngle = impactLieAngle
    var naturalUncock = naturalUncock
    var naturalReleaseTiming = naturalReleaseTiming
    var swingTempo = swingTempo
    var estimateCarry = estimateCarry
    var impactPointX = impactPointX
    var impactPointXType = impactPointXType.rawValue
    var impactPointY = impactPointY
    var impactPointYType = impactPointYType.rawValue
    var halfwaybackFaceAngleToVertical = halfwaybackFaceAngleToVertical
    var topFaceAngleToHorizontal = topFaceAngleToHorizontal
    var halfwaydownFaceAngleToVertical = halfwaydownFaceAngleToVertical
    var impactHandFirst = impactHandFirst
    var addressHandFirst = addressHandFirst
    var swingHandedType = swingHandedType.rawValue
}