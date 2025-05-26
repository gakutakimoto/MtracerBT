//
//  CallbackHolder.swift
//  Runner
//
//  Created by 5007710 on 2019/08/08.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//
import CoreNFC
import MTracerSDK

class DataHolder {
    static let sharedManager = DataHolder()

    var result :FlutterResult!
    var nfcSession :NFCNDEFReaderSession!
    var userId :String = "7f91458c26384f46b1606812cc253f48"
    var addressFaceAngleAdjustType = AddressFaceAngleAdjustType.SQUARE
    
    private init() {
    }
}
