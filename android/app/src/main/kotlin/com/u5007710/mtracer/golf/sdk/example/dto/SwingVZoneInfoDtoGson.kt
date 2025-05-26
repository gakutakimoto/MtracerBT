package com.u5007710.mtracer.golf.sdk.example.dto

import com.epson.mtracer.sdk.dto.SwingVZoneType

class SwingVZoneInfoDtoGson constructor (_vZoneUpperAngle: Float,
                                         _vZoneUnderAngle: Float,
                                         _vZoneABAngle: Float,
                                         _vZoneBCAngle: Float,
                                         _vZoneCDAngle: Float,
                                         _vZoneDEAngle: Float,
                                         _hwbZoneAngle: Float,
                                         _topZoneAngle: Float,
                                         _nuZoneAngle: Float,
                                         _hwdZoneAngle: Float,
                                         _hwbZoneArea: SwingVZoneType,
                                         _topZoneArea: SwingVZoneType,
                                         _nuZoneArea: SwingVZoneType,
                                         _hwdZoneArea: SwingVZoneType) {
    var vZoneUpperAngle = _vZoneUpperAngle
    var vZoneUnderAngle = _vZoneUnderAngle
    var vZoneABAngle = _vZoneABAngle
    var vZoneBCAngle = _vZoneBCAngle
    var vZoneCDAngle = _vZoneCDAngle
    var vZoneDEAngle = _vZoneDEAngle
    var hwbZoneAngle = _hwbZoneAngle
    var topZoneAngle = _topZoneAngle
    var nuZoneAngle = _nuZoneAngle
    var hwdZoneAngle = _hwdZoneAngle
    var hwbZoneArea = _hwbZoneArea.rawValue
    var topZoneArea = _topZoneArea.rawValue
    var nuZoneArea = _nuZoneArea.rawValue
    var hwdZoneArea = _hwdZoneArea.rawValue
}