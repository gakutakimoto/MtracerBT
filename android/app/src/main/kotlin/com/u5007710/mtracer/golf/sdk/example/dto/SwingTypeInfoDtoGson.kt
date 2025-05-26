package com.u5007710.mtracer.golf.sdk.example.dto

import com.epson.mtracer.sdk.dto.SwingType

class SwingTypeInfoDtoGson constructor (_swingType: SwingType) {
    var swingType = _swingType.rawValue
}
