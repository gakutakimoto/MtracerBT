package com.u5007710.mtracer.golf.sdk.example

import com.epson.mtracer.sdk.dto.AddressFaceAngleAdjustType
import io.flutter.plugin.common.MethodChannel

data class DataHolder(var callback: MethodChannel.Result?, var userID: String?, var addressFaceAngleAdjustType: AddressFaceAngleAdjustType?) {
}
