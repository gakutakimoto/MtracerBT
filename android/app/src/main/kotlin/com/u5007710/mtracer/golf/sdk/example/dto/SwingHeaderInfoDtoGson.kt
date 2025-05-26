package com.u5007710.mtracer.golf.sdk.example.dto

import com.epson.mtracer.sdk.dto.ClubShaftHardnessType
import com.epson.mtracer.sdk.dto.DateAccuracyType
import com.epson.mtracer.sdk.dto.GenderType
import com.epson.mtracer.sdk.dto.SwingType
import java.util.*

class SwingHeaderInfoDtoGson constructor (_index: UShort,
                                          _isBroken: Boolean,
                                          _swingInfoId: String,
                                          _userId: String,
                                          _serialNo: String,
                                          _fwMajorVersion: Int,
                                          _fwMinorVersion: Int,
                                          _fwPatchVersion: Int,
                                          _dataVersion: Int,
                                          _algMajorVersion: Int,
                                          _algMinorVersion: Int,
                                          _swingDate: Date,
                                          _timeZoneOffset: Int,
                                          _dst: Int,
                                          _swingDateAccuracy: DateAccuracyType,
                                          _profileGender: GenderType,
                                          _profileHeight: Float,
                                          _profileBirthYear: Int,
                                          _profileBirthMonth: Int,
                                          _profileBirthDay: Int,
                                          _clubLength: Float,
                                          _clubFaceAngle: Float,
                                          _clubLieAngle: Float,
                                          _clubLoftAngle: Float,
                                          _clubShaftHardness: ClubShaftHardnessType,
                                          _clubMakerId: UInt,
                                          _clubId: String,
                                          _swingType: SwingType) {
    var index = _index
    var isBroken = _isBroken
    var swingInfoId = _swingInfoId
    var userId = _userId
    var serialNo = _serialNo
    var fwMajorVersion = _fwMajorVersion
    var fwMinorVersion = _fwMinorVersion
    var fwPatchVersion = _fwPatchVersion
    var dataVersion = _dataVersion
    var algMajorVersion = _algMajorVersion
    var algMinorVersion = _algMinorVersion
    var swingDate = _swingDate
    var timeZoneOffset = _timeZoneOffset
    var dst = _dst
    var swingDateAccuracy = _swingDateAccuracy.rawValue
    var profileGender = _profileGender.rawValue
    var profileHeight = _profileHeight
    var profileBirthYear = _profileBirthYear
    var profileBirthMonth = _profileBirthMonth
    var profileBirthDay = _profileBirthDay
    var clubLength = _clubLength
    var clubFaceAngle = _clubFaceAngle
    var clubLieAngle = _clubLieAngle
    var clubLoftAngle = _clubLoftAngle
    var clubShaftHardness = _clubShaftHardness.rawValue
    var clubMakerId = _clubMakerId
    var clubId = _clubId
    var swingType = _swingType.rawValue
}
