package com.u5007710.mtracer.golf.sdk.example.dto

import com.epson.mtracer.sdk.dto.ProductGradeType

class ProductInfoDtoGson constructor (_modelName: String,
                                      _modelCode: String,
                                      _destinationCode: String,
                                      _productGrade: ProductGradeType) {
    var modelName = _modelName
    var modelCode = _modelCode
    var destinationCode = _destinationCode
    var productGrade = _productGrade.rawValue
}
