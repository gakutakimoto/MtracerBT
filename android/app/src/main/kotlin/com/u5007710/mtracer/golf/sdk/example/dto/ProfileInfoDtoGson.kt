package com.u5007710.mtracer.golf.sdk.example.dto

import com.epson.mtracer.sdk.dto.GenderType

class ProfileInfoDtoGson constructor (_height: Int,
                                      _genderType: GenderType,
                                      _birthYear: Int,
                                      _birthMonth: Int,
                                      _birthDay: Int) {
    var height = _height
    var genderType = _genderType.rawValue
    var birthYear = _birthYear
    var birthMonth = _birthMonth
    var birthDay = _birthDay
}
