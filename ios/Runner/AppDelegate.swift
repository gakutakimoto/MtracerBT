import UIKit
import Flutter
import CoreNFC
import MTracerSDK
import Hydra
import Foundation

private enum EventSinkStartScan :String {
    case start
    case finish
}

private enum EventSinkUpdateFW :String {
    case start
    case finish
}

private enum EventSinkGetSwingHeaderInfo :String {
    case start
    case finish
}

private enum EventSinkExportAllSwingInfo :String {
    case start
    case finish
}

private enum EventSinkImpact :String {
    case start
}

private enum EventSinkSwingInfo :String {
    case start
}

private enum EventSink70Sec :String {
    case start
}

public class FluffViewFactory: NSObject, FlutterPlatformViewFactory {
    public func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FluffView(frame, viewId: viewId, args: args)
    }
}

public class FluffView : NSObject, FlutterPlatformView {
    let frame: CGRect
    let viewId: Int64
    
    init(_ frame: CGRect, viewId: Int64, args: Any?) {
        self.frame = frame
        self.viewId = viewId
    }
    
    
    public func view() -> UIView {
        return UISlider(frame: frame)
    }
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, NFCNDEFReaderSessionDelegate, FlutterStreamHandler {
    private var eventSinkStartScan: FlutterEventSink?
    private var eventSinkUpdateFW: FlutterEventSink?
    private var eventSinkGetSwingHeaderInfo: FlutterEventSink?
    private var eventSinkExportAllSwingInfo: FlutterEventSink?
    private var eventSinkImpact: FlutterEventSink?
    private var eventSinkSwingInfo: FlutterEventSink?
    private var eventSink70Sec: FlutterEventSink?
    private var isFWUpdating = false;
    
    override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        #if DEBUG
        debugPrint("Build:Debug(App)")
        #else
        debugPrint("Build:Release(App)")
        #endif

        let viewFactory = FluffViewFactory()
        registrar(forPlugin: "kitty")!.register(viewFactory, withId: "ramdom_noise")
        
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        
        let infoIOChannel = FlutterMethodChannel(name: "M-TracerSDK.INFO/io", binaryMessenger: controller.binaryMessenger)
        infoIOChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if (call.method == "setUserId") {
                guard let arguments = call.arguments as? [String : String] else {
                    result(false)
                    return
                }
                
                guard let userId = arguments["userId"] else {
                    result(false)
                    return
                }
                
                DataHolder.sharedManager.userId = userId
            } else if (call.method == "setAddressFaceAngleType") {
                guard let arguments = call.arguments as? [String : String] else {
                    result(false)
                    return
                }
                
                guard let type = arguments["addressFaceAngleType"] else {
                    result(false)
                    return
                }
                
                let addressFaceAngleAdjustType :AddressFaceAngleAdjustType
                switch (type) {
                case "Open(High)":
                    addressFaceAngleAdjustType = AddressFaceAngleAdjustType.OPEN_HIGH
                case "Open(Mid)":
                    addressFaceAngleAdjustType = AddressFaceAngleAdjustType.OPEN_MEDIUM
                case "Open(Low)":
                    addressFaceAngleAdjustType = AddressFaceAngleAdjustType.OPEN_LOW
                case "Square":
                    addressFaceAngleAdjustType = AddressFaceAngleAdjustType.SQUARE
                case "Close(Low)":
                    addressFaceAngleAdjustType = AddressFaceAngleAdjustType.CLOSE_LOW
                case "Close(Mid)":
                    addressFaceAngleAdjustType = AddressFaceAngleAdjustType.CLOSE_MEDIUM
                case "Close(High)":
                    addressFaceAngleAdjustType = AddressFaceAngleAdjustType.CLOSE_HIGH
                default:
                    addressFaceAngleAdjustType = AddressFaceAngleAdjustType.SQUARE
                }

                DataHolder.sharedManager.addressFaceAngleAdjustType = addressFaceAngleAdjustType
            }
        })

        let nfcIOChannel = FlutterMethodChannel(name: "M-TracerSDK.NFC/io", binaryMessenger: controller.binaryMessenger)
        nfcIOChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard call.method == "WakeNFCReader" else {
                result(FlutterMethodNotImplemented)
                return
            }
            
            self?.wakeNFCReader(result: result)
        })
        
        let apiIOChannel = FlutterMethodChannel(name: "M-TracerSDK.API/io", binaryMessenger: controller.binaryMessenger)
        apiIOChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "connect" {
                guard let arguments = call.arguments as? [String : String] else {
                    result(false)
                    return
                }
                
                guard let localName = arguments["LocalName"] else {
                    result(false)
                    return
                }
                
                self?.connect(result: result, localName: localName)
            } else if call.method == "disconnect" {
                self?.disconnect(result: result)
            } else if call.method == "switchToBLEEcoMode" {
                self?.switchToBLEEcoMode(result: result)
            } else if call.method == "bookConnection" {
                guard let arguments = call.arguments as? [String : String] else {
                    result(false)
                    return
                }
                
                guard let uuid = arguments["UUID"] else {
                    result(false)
                    return
                }
                
                self?.bookConnection(result: result, uuid: uuid)
            } else if call.method == "readProfileInfo" {
                self?.readProfileInfo(result: result)
            } else if call.method == "writeProfileInfo" {
                guard let arguments = call.arguments as? [String : String] else {
                    result(false)
                    return
                }
                
                guard let json = arguments["JSON"] else {
                    result(false)
                    return
                }
                
                self?.writeProfileInfo(result: result, json: json)
            } else if call.method == "readClubInfo" {
                self?.readClubInfo(result: result)
            } else if call.method == "writeClubInfo" {
                guard let arguments = call.arguments as? [String : String] else {
                    result(false)
                    return
                }
                
                guard let json = arguments["JSON"] else {
                    result(false)
                    return
                }
                
                self?.writeClubInfo(result: result, json: json)
            } else if call.method == "readNotificationInfo" {
                self?.readNotificationInfo(result: result)
            } else if call.method == "writeNotificationInfo" {
                guard let arguments = call.arguments as? [String : String] else {
                    result(false)
                    return
                }
                
                guard let json = arguments["JSON"] else {
                    result(false)
                    return
                }
                
                self?.writeNotificationInfo(result: result, json: json)
            } else if call.method == "writeSwingTypeInfo" {
                guard let arguments = call.arguments as? [String : String] else {
                    result(false)
                    return
                }
                
                guard let json = arguments["JSON"] else {
                    result(false)
                    return
                }
                
                self?.writeSwingTypeInfo(result: result, json: json)
            } else if call.method == "readProductInfo" {
                self?.readProductInfo(result: result)
            } else if call.method == "readHWInfo" {
                self?.readHWInfo(result: result)
            } else if call.method == "writeHWInfo" {
                guard let arguments = call.arguments as? [String : String] else {
                    result(false)
                    return
                }
                
                guard let json = arguments["JSON"] else {
                    result(false)
                    return
                }
                
                self?.writeHWInfo(result: result, json: json)
            } else if call.method == "readBatteryLevel" {
                self?.readBatteryLevel(result: result)
            } else if call.method == "resetToFactorySetting" {
                self?.resetToFactorySetting(result: result)
            } else if call.method == "calibrate" {
                self?.calibrate(result: result)
            } else if call.method == "readFWInfo" {
                self?.readFWInfo(result: result)
            } else if call.method == "readLatestFWInfo" {
                self?.readLatestFWInfo(result: result)
            } else if call.method == "readSwingInfo" {
                guard let arguments = call.arguments as? [String : Any] else {
                    result(false)
                    return
                }
                
                guard let index = arguments["index"] else {
                    result(false)
                    return
                }
                
                self?.readSwingInfo(result: result, index: index as! UInt)
            } else if call.method == "writeUploadFlag" {
                guard let arguments = call.arguments as? [String : UInt] else {
                    result(false)
                    return
                }
                
                guard let index = arguments["index"] else {
                    result(false)
                    return
                }
                
                self?.writeUploadFlag(result: result, index: index)
            }
        })
        
        FlutterEventChannel(name: "M-TracerSDK.API/stream_startScan", binaryMessenger: controller.binaryMessenger).setStreamHandler(self)
        FlutterEventChannel(name: "M-TracerSDK.API/stream_updateFW", binaryMessenger: controller.binaryMessenger).setStreamHandler(self)
        FlutterEventChannel(name: "M-TracerSDK.API/stream_receiveImpactEvent", binaryMessenger: controller.binaryMessenger).setStreamHandler(self)
        FlutterEventChannel(name: "M-TracerSDK.API/stream_receiveSwingInfoEvent", binaryMessenger: controller.binaryMessenger).setStreamHandler(self)
        FlutterEventChannel(name: "M-TracerSDK.API/stream_receive70SecEvent", binaryMessenger: controller.binaryMessenger).setStreamHandler(self)
        FlutterEventChannel(name: "M-TracerSDK.API/stream_getSwingHeaderInfo", binaryMessenger: controller.binaryMessenger).setStreamHandler(self)
        FlutterEventChannel(name: "M-TracerSDK.API/stream_exportAllSwingInfo", binaryMessenger: controller.binaryMessenger).setStreamHandler(self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func wakeNFCReader(result :@escaping FlutterResult) {
        let holder = DataHolder.sharedManager
        holder.result = result

        if NFCNDEFReaderSession.readingAvailable {
            holder.nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
            holder.nfcSession.alertMessage = "iPhoneをM-Tracer本体に近づけてください"
            holder.nfcSession.begin()
        } else {
            result("ERR.NFC.NOTAVAILABLE")
        }
    }

    func readerSession(_ session :NFCNDEFReaderSession, didInvalidateWithError error :Error) {
        let holder = DataHolder.sharedManager

        if let readerError = error as? NFCReaderError {
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                debugPrint("ERR.NFC.\(error.localizedDescription)")

                holder.result("ERR.NFC.\(error.localizedDescription)")
            }
        }

        holder.nfcSession = nil
    }

    func readerSession(_ session :NFCNDEFReaderSession, didDetectNDEFs messages :[NFCNDEFMessage]) {
        let holder = DataHolder.sharedManager

        DispatchQueue.main.async {
            for message in messages {
                for payload in message.records {
                    debugPrint("Type name format: \(payload.typeNameFormat)")
                    debugPrint("Payload: \(payload.payload)")
                    debugPrint("Type: \(payload.type)")
                    debugPrint("Identifier: \(payload.identifier)")

                    holder.result(String(bytes:payload.payload.suffix(payload.payload.count - 3), encoding: String.Encoding.utf8))
                    break
                }
            }
        }
        holder.nfcSession = nil
    }

    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
    }
    
    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        guard let args = arguments as? Array<Any> else {
            return nil
        }
        
        guard args.count > 0 else {
            return nil
        }
        
        guard let eventName = args[0] as? String else {
            return nil
        }
        
        if (eventName == "startScan") {
            startScan(eventSink: eventSink)
        } else if (eventName == "updateFW") {
            updateFW(eventSink: eventSink)
        } else if (eventName == "readSwingHeaderInfo") {
            readSwingHeaderInfo(eventSink: eventSink)
        } else if (eventName == "exportAllSwingInfo") {
            exportAllSwingInfo(eventSink: eventSink)
        } else if (eventName == "receiveImpactEvent") {
            receiveImpactEvent(eventSink: eventSink)
        } else if (eventName == "receiveSwingInfoEvent") {
            receiveSwingInfoEvent(eventSink: eventSink)
        } else if (eventName == "receive70SecEvent") {
            receive70SecEvent(eventSink: eventSink)
        }
        
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        guard let args = arguments as? Array<Any> else {
            return nil
        }
        
        guard args.count > 0 else {
            return nil
        }
        
        guard let eventName = args[0] as? String else {
            return nil
        }
        
        if (eventName == "startScan") {
            stopScanning()
        } else if (eventName == "updateFW") {
            ignoreUpdateFW()
        } else if (eventName == "readSwingHeaderInfo") {
            ignoreGetSwingHeaderInfo()
        } else if (eventName == "exportAllSwingInfo") {
            ignoreExportAllSwingInfo()
        } else if (eventName == "receiveImpactEvent") {
            ignoreImpactEvent()
        } else if (eventName == "receiveSwingInfoEvent") {
            ignoreSwingInfoEvent()
        } else if (eventName == "receive70SecEvent") {
            ignore70SecEvent()
        }
        
        return nil
    }
    
    //MARK: M-TracerとのBLE接続を開始する
    private func connect(result :@escaping FlutterResult, localName :String) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)
        debugPrint(mt.getVersionNo())

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0

        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.connect(dateTimeInfo: dateTimeInfo, userId: userId, localName: localName).then({ (uuid) in
            result(uuid)
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }
    
    //MARK: M-Tracerと切断する
    private func disconnect(result :@escaping FlutterResult) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        mt.disconnect().then({ (_) in
            result("DONE")
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }
    
    //MARK: M-Tracerを検索する
    private func startScan(eventSink: @escaping FlutterEventSink) {
        eventSinkStartScan = eventSink
        guard let eventSinkStartScan = self.eventSinkStartScan else {
            return
        }
        
        eventSinkStartScan(EventSinkStartScan.start.rawValue)
        
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        mt.startScan(callback: { (localName) in
            guard let eventSinkStartScan = self.eventSinkStartScan else {
                return
            }
            
            eventSinkStartScan(localName)
        }).catch({ (error) in
            guard let eventSinkStartScan = self.eventSinkStartScan else {
                return
            }
            
            eventSinkStartScan(self.errorToString(error: error))
        })
    }
    
    //MARK: M-Tracerの検索を終了する
    private func stopScanning() {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        mt.stopScanning()
        self.eventSinkStartScan = nil
    }
    
    //MARK: M-Tracerを省電力状態にする
    private func switchToBLEEcoMode(result :@escaping FlutterResult) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0
        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.switchToBLEEcoMode(dateTimeInfo: dateTimeInfo, userId: userId).then ({ (_) in
            result("DONE")
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }
    
    //MARK: - M-TracerとのBLE自動再接続を予約する
    private func bookConnection(result :@escaping FlutterResult, uuid :String) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        mt.bookConnection(uuid: uuid).then({ (_) in
            result("DONE")
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }
    
    //MARK: M-Tracerの電池残量を取得する
    private func readBatteryLevel(result :@escaping FlutterResult) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0
        
        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.readBatteryLevel(dateTimeInfo: dateTimeInfo, userId: userId).then({ (battery) in
            result(String(battery))
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }
    
    //MARK: M-Tracerから製品情報を取得する
    private func readProductInfo(result :@escaping FlutterResult) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0

        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.readProductInfo(dateTimeInfo: dateTimeInfo, userId: userId).then({ (productInfoDto) in
            do {
                let data = try JSONEncoder().encode(productInfoDto)
                let json :String = String(data: data, encoding: .utf8)!
                
                result(json)
            } catch {
                debugPrint(error.localizedDescription)
                result("ERR." + error.localizedDescription)
            }
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }
    
    //MARK: M-TracerからHW情報を取得する
    private func readHWInfo(result :@escaping FlutterResult) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0
        
        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.readHWInfo(dateTimeInfo: dateTimeInfo, userId: userId).then({ (hwInfoDto) in
            do {
                let data = try JSONEncoder().encode(hwInfoDto)
                let json :String = String(data: data, encoding: .utf8)!
                
                result(json)
            } catch {
                debugPrint(error.localizedDescription)
                result("ERR." + error.localizedDescription)
            }
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }
    
    //MARK: M-TracerのHW情報を変更する
    private func writeHWInfo(result :@escaping FlutterResult, json :String) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0

        let holder = DataHolder.sharedManager
        let userId = holder.userId

        let hwInfo = try! JSONDecoder().decode(HWInfoDto.self, from: json.data(using: .utf8)!)
        mt.writeHWInfo(dateTimeInfo: dateTimeInfo, userId: userId, hwInfo: hwInfo).then({ (_) in
            result("DONE")
        }).catch({ (error) in
            //TBD
            switch (error) {
            default:
                debugPrint(error)
                result("ERR.API.UNKNOWN")
            }
        })
    }
    
    //MARK: M-Tracerからプロフィール情報を取得する
    private func readProfileInfo(result :@escaping FlutterResult) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0

        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.readProfileInfo(dateTimeInfo: dateTimeInfo, userId: userId).then({ (profileInfo) in
            do {
                let data = try JSONEncoder().encode(profileInfo)
                let json = String(data: data, encoding: .utf8)!
                
                result(json)
            } catch {
                debugPrint(error.localizedDescription)
                result("ERR_" + error.localizedDescription)
            }
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }
    
    //MARK: M-Tracerのプロフィール情報を変更する
    private func writeProfileInfo(result :@escaping FlutterResult, json :String) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let profileInfo = try! JSONDecoder().decode(ProfileInfoDto.self, from: json.data(using: .utf8)!)
        
        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0

        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.writeProfileInfo(dateTimeInfo: dateTimeInfo, userId: userId, profileInfo: profileInfo).then({ (_) in
            result("DONE")
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }
    
    //MARK: M-Tracerからクラブ情報を取得する
    private func readClubInfo(result :@escaping FlutterResult) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0

        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.readClubInfo(dateTimeInfo: dateTimeInfo, userId: userId).then({ (clubInfo) in
            do {
                let data = try JSONEncoder().encode(clubInfo)
                let json = String(data: data, encoding: .utf8)!
                result(json)
            } catch {
                debugPrint(error.localizedDescription)
                result("ERR_" + error.localizedDescription)
            }
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }
    
    //MARK: M-Tracerのクラブ情報を変更する
    private func writeClubInfo(result :@escaping FlutterResult, json :String) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let clubInfo = try! JSONDecoder().decode(ClubInfoDto.self, from: json.data(using: .utf8)!)
        
        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0

        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.writeClubInfo(dateTimeInfo: dateTimeInfo, userId: userId, clubInfo: clubInfo).then({ (_) in
            result("DONE")
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }
    
    //MARK: M-Tracerから通知設定情報を取得する
    private func readNotificationInfo(result :@escaping FlutterResult) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0

        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.readNotificationInfo(dateTimeInfo: dateTimeInfo, userId: userId).then({ (notificationInfo) in
            do {
                let data = try JSONEncoder().encode(notificationInfo)
                let json = String(data: data, encoding: .utf8)!
                
                debugPrint(json)
                result(json)
            } catch {
                debugPrint(error.localizedDescription)
                result("ERR_" + error.localizedDescription)
            }
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }
    
    //MARK: M-Tracerの通知設定情報を変更する
    private func writeNotificationInfo(result :@escaping FlutterResult, json :String) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let notificationInfo = try! JSONDecoder().decode(NotificationInfoDto.self, from: json.data(using: .utf8)!)
        
        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0

        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.writeNotificationInfo(dateTimeInfo: dateTimeInfo, userId: userId, notificationInfo: notificationInfo).then({ (_) in
            result("DONE")
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }
    
    //MARK: M-TracerのSwingType設定情報を変更する
    private func writeSwingTypeInfo(result :@escaping FlutterResult, json :String) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let swingTypeInfo = try! JSONDecoder().decode(SwingTypeInfoDto.self, from: json.data(using: .utf8)!)
        
        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0

        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.writeSwingTypeInfo(dateTimeInfo: dateTimeInfo, userId: userId, swingTypeInfo: swingTypeInfo).then({ (_) in
            result("DONE")
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }
    
    //MARK: M-TracerからFW情報を取得する
    private func readFWInfo(result :@escaping FlutterResult) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0

        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.readFWInfo(dateTimeInfo: dateTimeInfo, userId: userId).then({ (fwInfo) in
            do {
                let data = try JSONEncoder().encode(fwInfo)
                let json :String = String(data: data, encoding: .utf8)!
                result(json)
            } catch {
                debugPrint(error.localizedDescription)
                result("ERR." + error.localizedDescription)
            }
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }
    
    //MARK: ダウンロードセンターから最新のFW情報を取得する
    private func readLatestFWInfo(result :@escaping FlutterResult) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0

        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.readLatestFWInfo(dateTimeInfo: dateTimeInfo, userId: userId).then({ (latestFWInfoDto) in
            do {
                let data = try JSONEncoder().encode(latestFWInfoDto)
                let json :String = String(data: data, encoding: .utf8)!
                
                result(json)
            } catch {
                debugPrint(error.localizedDescription)
                result("ERR." + error.localizedDescription)
            }
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }
    
    //MARK: M-TracerのFWを更新する
    private func updateFW(eventSink: @escaping FlutterEventSink) {
        eventSinkUpdateFW = eventSink
        guard let event = self.eventSinkUpdateFW else {
            return
        }
        event(EventSinkUpdateFW.start.rawValue)
        
        self.isFWUpdating = true
        
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0

        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.updateFW(dateTimeInfo: dateTimeInfo, userId: userId, callback: { (progress) -> Void in
            guard let event = self.eventSinkUpdateFW else {
                return
            }
            
            event(String(progress))
        }).then({ (_) in
            guard let event = self.eventSinkUpdateFW else {
                return
            }
            
            self.isFWUpdating = false
            
            event(EventSinkUpdateFW.finish.rawValue)
        }).catch({ (error) in
            guard let event = self.eventSinkUpdateFW else {
                return
            }
            
            self.isFWUpdating = false
            
            event(self.errorToString(error: error))
        })
    }
    
    //MARK: M-TracerのFW更新を中止する
    private func ignoreUpdateFW() {
        guard isFWUpdating == true else {
            return
        }
        
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        mt.cancelUpdateFW().then({ (_) in
            debugPrint("success")
        }).catch({ (error) in
            debugPrint(error)
        })
        self.eventSinkUpdateFW = nil
    }
    
    //MARK: M-Tracerの監視を開始する(インパクト)
    private func receiveImpactEvent(eventSink: @escaping FlutterEventSink) {
        eventSinkImpact = eventSink
        
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0

        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.receiveImpactEvent(dateTimeInfo: dateTimeInfo, userId: userId, eventCallback: { (impactId) in
            guard let eventSinkImpact = self.eventSinkImpact else {
                return
            }

            eventSinkImpact(impactId)
        }, successCallback: { () in
            guard let eventSinkImpact = self.eventSinkImpact else {
                return
            }
            
            eventSinkImpact(EventSinkImpact.start.rawValue)
        }, failureCallback: { (error) in
            guard let eventSinkImpact = self.eventSinkImpact else {
                return
            }
            
            eventSinkImpact(self.errorToString(error: error))
        })
    }
    
    //MARK: M-Tracerの監視を終了する(インパクト)
    private func ignoreImpactEvent() {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0

        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.ignoreImpactEvent(dateTimeInfo: dateTimeInfo, userId: userId)
        self.eventSinkImpact = nil
    }
    
    //MARK: M-Tracerの監視を開始する(Swing情報)
    private func receiveSwingInfoEvent(eventSink: @escaping FlutterEventSink) {
        eventSinkSwingInfo = eventSink
        
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0
        let userId = DataHolder.sharedManager.userId
        let addressFaceAngleAdjustType = DataHolder.sharedManager.addressFaceAngleAdjustType
        mt.receiveSwingInfoEvent(dateTimeInfo: dateTimeInfo, userId: userId, eventCallback: { (isExist, impactId, index) in
            guard let eventSinkSwingInfo = self.eventSinkSwingInfo else {
                return
            }

            mt.readSwingInfo(dateTimeInfo: dateTimeInfo, vendorId: "Q4930jb7ESZugqMNmFVAbVILayY2", userId: userId, index: index,weight: 65.6, averageScore: 100, addressFaceAngleAdjustType: addressFaceAngleAdjustType, callback: { (progress) -> Void in
                debugPrint(String(progress) + "%")
            }).then({ (swingInfo) in
                let message = SwingInfoMessage(
                    isExist: isExist,
                    impactId: impactId,
                    index: index,
                    hs: swingInfo.measurementInfo.impactHeadSpeed,
                    angle1: swingInfo.measurementInfo.impactFaceAngle,
                    angle2: swingInfo.measurementInfo.impactClubPath,
                    angle3: swingInfo.measurementInfo.impactAttackAngle
                )
                do {
                    let data = try JSONEncoder().encode(message)
                    if let json = String(data: data, encoding: .utf8) {
                        debugPrint(json)
                        eventSinkSwingInfo(json)
                    }
                } catch {
                    eventSinkSwingInfo("ERR.JSON")
                }
            }).catch({ (error) in
                debugPrint("error")
                eventSinkSwingInfo(self.errorToString(error: error))
            })
        }, successCallback: { () in
            guard let eventSinkSwingInfo = self.eventSinkSwingInfo else {
                return
            }
            
            eventSinkSwingInfo(EventSinkSwingInfo.start.rawValue)
        }, failureCallback: { (error) in
            guard let eventSinkSwingInfo = self.eventSinkSwingInfo else {
                return
            }
            
            eventSinkSwingInfo(self.errorToString(error: error))
        })
    }
    
    //MARK: M-Tracerの監視を終了する(Swing情報)
    private func ignoreSwingInfoEvent() {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0

        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.ignoreSwingInfoEvent(dateTimeInfo: dateTimeInfo, userId: userId)
        self.eventSinkSwingInfo = nil
    }
    
    //MARK: 70秒間隔の通知に合わせて計測データを取得する(for Debug)
    private func receive70SecEvent(eventSink: @escaping FlutterEventSink) {
        eventSink70Sec = eventSink
        
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0
        let userId = DataHolder.sharedManager.userId
        let addressFaceAngleAdjustType = DataHolder.sharedManager.addressFaceAngleAdjustType
        mt.receiveSwingInfoEvent(dateTimeInfo: dateTimeInfo, userId: userId, eventCallback: { (isExist, impactId, index) in
            guard let eventSink70Sec = self.eventSink70Sec else {
                return
            }

            async({ (_) in
                do {
                    let swingInfo = try Hydra.await(mt.readSwingInfo(dateTimeInfo: dateTimeInfo, vendorId: "Q4930jb7ESZugqMNmFVAbVILayY2", userId: userId, index: index, weight: 65.6, averageScore: 100, addressFaceAngleAdjustType: addressFaceAngleAdjustType, callback: { (_) -> Void in }))
                    swingInfo.toFile(for: .documentDirectory)
                    let _ = try Hydra.await(mt.writeUploadFlag(dateTimeInfo: dateTimeInfo, userId: userId, index: index))

                    let message = SwingInfoMessage(
                        isExist: isExist,
                        impactId: impactId,
                        index: index,
                        hs: swingInfo.measurementInfo.impactHeadSpeed,
                        angle1: swingInfo.measurementInfo.impactFaceAngle,
                        angle2: swingInfo.measurementInfo.impactClubPath,
                        angle3: swingInfo.measurementInfo.impactAttackAngle
                    )
                    if let data = try? JSONEncoder().encode(message),
                       let json = String(data: data, encoding: .utf8) {
                        eventSink70Sec(json)
                    }
                } catch {
                    debugPrint("catch")
                }
            }).then { (_) in
            }
        }, successCallback: { () in
            guard let eventSink70Sec = self.eventSink70Sec else {
                return
            }
            
            eventSink70Sec(EventSink70Sec.start.rawValue)
        }, failureCallback: { (error) in
            guard let eventSink70Sec = self.eventSink70Sec else {
                return
            }
            
            eventSink70Sec(self.errorToString(error: error))
        })
    }
    
    private func ignore70SecEvent() {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0

        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.ignoreSwingInfoEvent(dateTimeInfo: dateTimeInfo, userId: userId)
        self.eventSink70Sec = nil
    }
    
    //MARK: M-TracerからSwing情報一覧を取得する
    private func readSwingHeaderInfo(eventSink :@escaping FlutterEventSink) {
        eventSinkGetSwingHeaderInfo = eventSink
        guard let event = eventSinkGetSwingHeaderInfo else {
            return
        }
        event(EventSinkGetSwingHeaderInfo.start.rawValue)
        
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0

        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.readSwingHeaderInfo(dateTimeInfo: dateTimeInfo, userId: userId, callback: { (swingHeaderInfo) -> Void in
            guard let event = self.eventSinkGetSwingHeaderInfo else {
                return
            }
            
            do {
                let encoder: JSONEncoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                let data = try encoder.encode(swingHeaderInfo)
                let json :String = String(data: data, encoding: .utf8)!
                event(json)
            } catch {
                debugPrint(error.localizedDescription)
                event("ERR." + error.localizedDescription)
            }
        }).then({ (_) in
            guard let event = self.eventSinkGetSwingHeaderInfo else {
                return
            }
            
            event(EventSinkGetSwingHeaderInfo.finish.rawValue)
        }).catch({ (error) in
            guard let event = self.eventSinkGetSwingHeaderInfo else {
                return
            }
            
            event(self.errorToString(error: error))
        })
    }
    
    private func ignoreGetSwingHeaderInfo() {
        self.eventSinkGetSwingHeaderInfo = nil
    }
    
    //MARK: M-TracerからSwing情報を取得する
    private func readSwingInfo(result :@escaping FlutterResult, index :UInt) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)
        
        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0
        let userId = DataHolder.sharedManager.userId
        let addressFaceAngleAdjustType = DataHolder.sharedManager.addressFaceAngleAdjustType
        mt.readSwingInfo(dateTimeInfo: dateTimeInfo, vendorId: "6", userId: userId, index: index, weight: 65.6, averageScore: 100, addressFaceAngleAdjustType: addressFaceAngleAdjustType, callback: { (progress) -> Void in
            debugPrint(String(progress) + "%")
        }).then({ (swingInfo) in
            do {
                let encoder: JSONEncoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                encoder.outputFormatting = .prettyPrinted
                let data = try encoder.encode(swingInfo)
                let json :String = String(data: data, encoding: .utf8)!
                
//                print(json)
                result(json)
            } catch {
                debugPrint(error.localizedDescription)
                result("ERR." + error.localizedDescription)
            }
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }
    
    //MARK: M-Tracerから全ての計測データファイル出力する(for Debug)
    private func exportAllSwingInfo(eventSink :@escaping FlutterEventSink) {
        eventSinkExportAllSwingInfo = eventSink
        guard let event = eventSinkExportAllSwingInfo else {
            return
        }
        event(EventSinkExportAllSwingInfo.start.rawValue)
        
        var swingHeaderInfoList = Array<SwingHeaderInfoDto>()
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0
        let userId = DataHolder.sharedManager.userId
        let addressFaceAngleAdjustType = DataHolder.sharedManager.addressFaceAngleAdjustType
        mt.readSwingHeaderInfo(dateTimeInfo: dateTimeInfo, userId: userId, callback: { (swingHeaderInfo) -> Void in
            swingHeaderInfoList.append(swingHeaderInfo)
        }).then({ (_) in
            guard let event = self.eventSinkExportAllSwingInfo else {
                return
            }
            
            async({ (_) in
                swingHeaderInfoList.forEach { (swingHeaderInfo) in
                    do {
                        let swingInfo = try Hydra.await(mt.readSwingInfo(dateTimeInfo: dateTimeInfo, vendorId: "Q4930jb7ESZugqMNmFVAbVILayY2", userId: userId, index: swingHeaderInfo.index, weight: 65.6, averageScore: 100, addressFaceAngleAdjustType: addressFaceAngleAdjustType, callback: { (_) -> Void in }))
                        swingInfo.toFile(for: .documentDirectory)
                        let _ = try Hydra.await(mt.writeUploadFlag(dateTimeInfo: dateTimeInfo, userId: userId, index: swingInfo.headerInfo.index))
                    } catch {
                        debugPrint("catch")
                    }
                }
            }).then { (_) in
                event(EventSinkExportAllSwingInfo.finish.rawValue)
            }
        }).catch({ (error) in
            guard let event = self.eventSinkGetSwingHeaderInfo else {
                return
            }
            
            event(self.errorToString(error: error))
        })
    }
    
    private func ignoreExportAllSwingInfo() {
        self.eventSinkExportAllSwingInfo = nil
    }
    
    //MARK: M-Tracer内のSwing情報を取得済み状態にする
    private func writeUploadFlag(result :@escaping FlutterResult, index :UInt) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0
        
        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.writeUploadFlag(dateTimeInfo: dateTimeInfo, userId: userId, index: index).then({ (_) in
            result("DONE")
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }
    
    //MARK: M-Tracerを工場出荷時の状態に戻す
    private func resetToFactorySetting(result :@escaping FlutterResult) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0
        
        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.resetToFactorySetting(dateTimeInfo: dateTimeInfo, userId: userId).then({ (_) in
            result("DONE")
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }
    
    //MARK: M-Tracerを校正する
    private func calibrate(result :@escaping FlutterResult) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        let dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = .Min0
        
        let holder = DataHolder.sharedManager
        let userId = holder.userId
        mt.calibrate(dateTimeInfo: dateTimeInfo, userId: userId).then({ (_) in
            result("DONE")
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }

    //MARK: M-Tracerとの通信を中止する
    private func cancelRequest(result :@escaping FlutterResult) {
        let mt :MTracerSDKInterface = MTracerSDKService.getInstance()
        mt.setAllowedAnalytics(true)

        mt.cancelRequest().then({ (_) in
            result("DONE")
        }).catch({ (error) in
            result(self.errorToString(error: error))
        })
    }
    
    private func errorToString(error :Error) -> String {
        let str :String
        switch (error) {
        case MTracerSDKError.API.BUSY:
            str = "ERR.API.BUSY"
        case MTracerSDKError.API.CANCEL:
            str = "ERR.API.CANCEL"
        case MTracerSDKError.API.INVALIDPARAMETER:
            str = "ERR.API.INVALIDPARAMETER"
        case MTracerSDKError.API.TIMEDOUT:
            str = "ERR.API.TIMEDOUT"
        case MTracerSDKError.API.UNSUPPORTED:
            str = "ERR.API.UNSUPPORTED"
        case MTracerSDKError.API.UNKNOWN:
            str = "ERR.API.UNKNOWN"
        case MTracerSDKError.BLE.BUSY:
            str = "ERR.BLE.BUSY"
        case MTracerSDKError.BLE.DELAYED:
            str = "ERR.BLE.DELAYED"
        case MTracerSDKError.BLE.DISCONNECTED:
            str = "ERR.BLE.DISCONNECTED"
        case MTracerSDKError.BLE.DOWNGRADE:
            str = "ERR.BLE.DOWNGRADE"
        case MTracerSDKError.BLE.INVALIDINDEX:
            str = "ERR.BLE.INVALIDINDEX"
        case MTracerSDKError.BLE.INVALIDPARAMETER:
            str = "ERR.BLE.INVALIDPARAMETER"
        case MTracerSDKError.BLE.INVALIDREQUEST:
            str = "ERR.BLE.INVALIDREQUEST"
        case MTracerSDKError.BLE.INVALIDRESPONSE:
            str = "ERR.BLE.INVALIDRESPONSE"
        case MTracerSDKError.BLE.MUTEXLOCKED:
            str = "ERR.BLE.MUTEXLOCKED"
        case MTracerSDKError.BLE.NOTENOUGHBATTERY:
            str = "ERR.BLE.NOTENOUGHBATTERY"
        case MTracerSDKError.BLE.POWEREDOFF:
            str = "ERR.BLE.POWEREDOFF"
        case MTracerSDKError.BLE.INVALIDSIZE:
            str = "ERR.BLE.INVALIDSIZE"
        case MTracerSDKError.BLE.TIMEDOUT:
            str = "ERR.BLE.TIMEDOUT"
        case MTracerSDKError.BLE.UNAUTHORIZED:
            str = "ERR.BLE.UNAUTHORIZED"
        case MTracerSDKError.BLE.UNKNOWN:
            str = "ERR.BLE.UNKNOWN"
        case MTracerSDKError.CRC.UNMATCH:
            str = "ERR.CRC.UNMATCH"
        case MTracerSDKError.FW.INVALIDVERSION:
            str = "ERR.FW.INVALIDVERSION"
        case MTracerSDKError.FW.NOTFOUND:
            str = "ERR.FW.NOTFOUND"
        case MTracerSDKError.FW.LATEST:
            str = "ERR.FW.LATEST"
        case MTracerSDKError.HTTP.BADREQUEST:
            str = "ERR.HTTP.BADREQUEST"
        case MTracerSDKError.HTTP.NOTFOUND:
            str = "ERR.HTTP.NOTFOUND"
        case MTracerSDKError.HTTP.REQUESTTIMEOUT:
            str = "ERR.HTTP.REQUESTTIMEOUT"
        case MTracerSDKError.HTTP.INTERNALSERVERERROR:
            str = "ERR.HTTP.INTERNALSERVERERROR"
        case MTracerSDKError.HTTP.NOTIMPLEMENTED:
            str = "ERR.HTTP.NOTIMPLEMENTED"
        case MTracerSDKError.HTTP.BADGATEWAY:
            str = "ERR.HTTP.BADGATEWAY"
        case MTracerSDKError.HTTP.SERVICEUNAVAILABLE:
            str = "ERR.HTTP.SERVICEUNAVAILABLE"
        case MTracerSDKError.HTTP.INVALIDDATA:
            str = "ERR.HTTP.INVALIDDATA"
        case MTracerSDKError.HTTP.INVALIDRESPONSE:
            str = "ERR.HTTP.INVALIDRESPONSE"
        case MTracerSDKError.HTTP.OFFLINE:
            str = "ERR.HTTP.OFFLINE"
        case MTracerSDKError.MAINTENANCE.CALIBRATEFAILED:
            str = "ERR.MAINTENANCE.CALIBRATEFAILED"
        default:
            str = "ERR.UNKNOWN"
        }

        return str
    }
}
