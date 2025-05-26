package com.u5007710.mtracer.golf.sdk.example.service

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.core.content.ContextCompat
import com.epson.mtracer.sdk.dto.*
import com.epson.mtracer.sdk.dto.DSTType.*
import com.epson.mtracer.sdk.service.MTracerSDKService
import com.epson.mtracer.sdk.serviceinterface.MTracerSDKError
import com.epson.mtracer.sdk.serviceinterface.MTracerSDKInterface
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.shopify.promises.completeOn
import com.u5007710.mtracer.golf.sdk.example.dto.ProductInfoDtoGson
import com.u5007710.mtracer.golf.sdk.example.dto.ProfileInfoDtoGson
import com.u5007710.mtracer.golf.sdk.example.dto.SwingHeaderInfoDtoGson
import com.u5007710.mtracer.golf.sdk.example.dto.SwingInfoDtoGson
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.util.*

class MTracerService(private val applicationContext: Context) {
    //MARK: M-Tracerを検索する
    @ExperimentalUnsignedTypes
    fun startScan(eventSink: EventChannel.EventSink) {
        val mtracerSDK: MTracerSDKInterface = MTracerSDKService.getInstance(applicationContext)

        eventSink.success("start")

        mtracerSDK.startScan { localName ->
            eventSink.success(localName)
        }.completeOn(ContextCompat.getMainExecutor(applicationContext))
            .whenComplete(
                {
                    eventSink.success("finish")
                },
                {
                    eventSink.success(errorToString(it as MTracerSDKError))
                }
            )
    }

    //MARK: M-Tracerの検索を終了する
    @ExperimentalUnsignedTypes
    fun stopScan() {
        val mtracerSDK: MTracerSDKInterface = MTracerSDKService.getInstance(applicationContext)
        mtracerSDK.stopScanning()
    }

    //MARK: M-Tracerの監視を開始する(インパクト)
    @ExperimentalUnsignedTypes
    fun receiveImpactEvent(eventSink: EventChannel.EventSink, userId: String) {
        val mtracerSDK: MTracerSDKInterface = MTracerSDKService.getInstance(applicationContext)

        val dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = DSTType.Min0

        mtracerSDK.receiveImpactEvent(dateTimeInfo, userId, {
            eventSink.success(it)
        }, {
            eventSink.success("start")
        }, {

            eventSink.success(errorToString(it as MTracerSDKError))
        })
    }

    //MARK: M-Tracerの監視を終了する(インパクト)
    @ExperimentalUnsignedTypes
    fun ignoreImpactEvent(userId: String) {
        val mtracerSDK: MTracerSDKInterface = MTracerSDKService.getInstance(applicationContext)

        val dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = DSTType.Min0

        mtracerSDK.ignoreImpactEvent(dateTimeInfo, userId)
    }

    //MARK: M-Tracerの監視を開始する(Swing情報)
    @ExperimentalUnsignedTypes
    fun receiveSwingInfoEvent(eventSink: EventChannel.EventSink, userId: String) {
        val mtracerSDK: MTracerSDKInterface = MTracerSDKService.getInstance(applicationContext)

        val dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = DSTType.Min0

        mtracerSDK.receiveSwingInfoEvent(dateTimeInfo, userId,
            { isExist: Boolean, impactId: String, index: UInt ->
                var json = "{"
                json += "\"isExist\":"
                json += if (isExist) "1" else "0"
                json += ","
                json += "\"impactId\":\""
                json += impactId
                json += "\","
                json += "\"index\":"
                json += index.toString()
                json += "}"
                eventSink.success(json)
            },
            {
                eventSink.success("start")
            },
            {
                eventSink.success(errorToString(it as MTracerSDKError))
            }
        )
    }

    //MARK: M-Tracerの監視を終了する(Swing情報)
    @ExperimentalUnsignedTypes
    fun ignoreSwingInfoEvent(userId: String) {
        val mtracerSDK: MTracerSDKInterface = MTracerSDKService.getInstance(applicationContext)

        val dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = DSTType.Min0

        mtracerSDK.ignoreSwingInfoEvent(dateTimeInfo, userId)
    }

    //MARK: M-TracerからSwing情報一覧を取得する
    @ExperimentalUnsignedTypes
    fun readSwingHeaderInfo(eventSink: EventChannel.EventSink, userId: String) {
        val mtracerSDK: MTracerSDKInterface = MTracerSDKService.getInstance(applicationContext)

        eventSink.success("start")

        val dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = DSTType.Min0

        mtracerSDK.readSwingHeaderInfo(dateTimeInfo, userId) {
            val swingHeaderInfoDtoGson = SwingHeaderInfoDtoGson(it.index,
                it.isBroken,
                it.swingInfoId,
                it.userId,
                it.serialNo,
                it.fwMajorVersion,
                it.fwMinorVersion,
                it.fwPatchVersion,
                it.dataVersion,
                it.algMajorVersion,
                it.algMinorVersion,
                it.swingDate,
                it.timeZoneOffset,
                it.dst,
                it.swingDateAccuracy,
                it.profileGender,
                it.profileHeight,
                it.profileBirthYear,
                it.profileBirthMonth,
                it.profileBirthDay,
                it.clubLength,
                it.clubFaceAngle,
                it.clubLieAngle,
                it.clubLoftAngle,
                it.clubShaftHardness,
                it.clubMakerId,
                it.clubId,
                it.swingType)
            val gson = GsonBuilder().registerTypeAdapter(Date::class.java, GsonUTCDateAdapter()).create()
            val json = gson.toJson(swingHeaderInfoDtoGson)
            val h = Handler(Looper.getMainLooper())
            h.post() {
                eventSink.success(json)
            }
        }.completeOn(ContextCompat.getMainExecutor(applicationContext))
            .whenComplete(
                {
                    eventSink.success("finish")
                },
                {
                    eventSink.success(errorToString(it as MTracerSDKError))
                }
            )
    }

    //MARK: M-TracerとのBLE接続を開始する
    @ExperimentalUnsignedTypes
    fun connect(callback: MethodChannel.Result, userId: String, localName: String) {
        val mtracerSDK = MTracerSDKService.getInstance(applicationContext)

        val dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = Min0

        mtracerSDK.connect(dateTimeInfo, userId, localName).whenComplete(
            { uuid: String ->
                callback.success(uuid)
            }, {
                callback.success(errorToString(it as MTracerSDKError))
            }
        )
    }

    //MARK: M-Tracerと切断する
    @ExperimentalUnsignedTypes
    fun disconnect(callback: MethodChannel.Result) {
        val mtracerSDK = MTracerSDKService.getInstance(applicationContext)

        mtracerSDK.disconnect().whenComplete(
            {
                callback.success("DONE")
            }, {
                callback.success(errorToString(it as MTracerSDKError))
            }
        )
    }

    //MARK: M-TracerとのBLE自動再接続を予約する
    @ExperimentalUnsignedTypes
    fun bookConnection(callback: MethodChannel.Result, uuid: String) {
        val mtracerSDK: MTracerSDKInterface = MTracerSDKService.getInstance(applicationContext)

        mtracerSDK.bookConnection(uuid).whenComplete(
            {
                callback.success("DONE")
            },
            {
                callback.success(errorToString(it as MTracerSDKError))
            }
        )
    }

    // M-Tracerの電池残量を取得する
    @ExperimentalUnsignedTypes
    fun readBatteryLevel(callback: MethodChannel.Result, userId: String) {
        val mtracerSDK: MTracerSDKInterface = MTracerSDKService.getInstance(applicationContext)

        val dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = DSTType.Min0

        mtracerSDK.readBatteryLevel(dateTimeInfo, userId).whenComplete(
            {
                callback.success(it.toString())
            },
            {
                callback.success(errorToString(it as MTracerSDKError))
            }
        )
    }

    //MARK: M-Tracerのプロフィール情報を変更する
    @ExperimentalUnsignedTypes
    fun writeProfileInfo(callback: MethodChannel.Result, userId: String, json: String) {
        val mtracerSDK: MTracerSDKInterface = MTracerSDKService.getInstance(applicationContext)

        val profileInfoDtoGson = Gson().fromJson(json, ProfileInfoDtoGson::class.java)
        val profileInfoDto = ProfileInfoDto()
        profileInfoDto.height = profileInfoDtoGson.height
        profileInfoDto.genderType =  GenderType.values().first { it.rawValue == profileInfoDtoGson.genderType }
        profileInfoDto.birthYear = profileInfoDtoGson.birthYear
        profileInfoDto.birthMonth = profileInfoDtoGson.birthMonth
        profileInfoDto.birthDay = profileInfoDtoGson.birthDay

        val dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = DSTType.Min0

        mtracerSDK.writeProfileInfo(dateTimeInfo, userId, profileInfoDto).whenComplete(
            {
                callback.success("DONE")
            }, {
                callback.success(errorToString(it as MTracerSDKError))
            }
        )
    }

    //MARK: M-Tracerから製品情報を取得する
    @ExperimentalUnsignedTypes
    fun readProductInfo(callback: MethodChannel.Result, userId: String) {
        val mtracerSDK: MTracerSDKInterface = MTracerSDKService.getInstance(applicationContext)

        val dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = DSTType.Min0

        mtracerSDK.readProductInfo(dateTimeInfo, userId).whenComplete(
            {
                val productInfoDtoGson = ProductInfoDtoGson(it.modelName,
                    it.modelCode,
                    it.destinationCode,
                    it.productGrade)
                val json = Gson().toJson(productInfoDtoGson)
                callback.success(json.toString())
            },
            {
                callback.success(errorToString(it as MTracerSDKError))
            }
        )
    }

    //MARK: M-TracerからHW情報を取得する
    @ExperimentalUnsignedTypes
    fun readHWInfo(callback: MethodChannel.Result, userId: String) {
        val mtracerSDK: MTracerSDKInterface = MTracerSDKService.getInstance(applicationContext)

        val dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = DSTType.Min0

        mtracerSDK.readHWInfo(dateTimeInfo, userId).whenComplete(
            {
                val json = Gson().toJson(it)
                callback.success(json.toString())
            },
            {
                callback.success(errorToString(it as MTracerSDKError))
            }
        )
    }

    //MARK: M-TracerからFW情報を取得する
    @ExperimentalUnsignedTypes
    fun readFWInfo(callback: MethodChannel.Result, userId: String) {
        val mtracerSDK: MTracerSDKInterface = MTracerSDKService.getInstance(applicationContext)

        val dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = DSTType.Min0

        mtracerSDK.readFWInfo(dateTimeInfo, userId).whenComplete(
            {
                val json = Gson().toJson(it)
                callback.success(json.toString())
            },
            {
                callback.success(errorToString(it as MTracerSDKError))
            }
        )
    }

    //MARK: M-TracerからSwing情報を取得する
    @ExperimentalUnsignedTypes
    fun readSwingInfo(callback: MethodChannel.Result, index: Int, userId: String, weight: Double, averageScore: Int, addressFaceAngleAdjustType: AddressFaceAngleAdjustType) {
        val mtracerSDK: MTracerSDKInterface = MTracerSDKService.getInstance(applicationContext)

        val dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = DSTType.Min0

        mtracerSDK.readSwingInfo(dateTimeInfo,
            "Q4930jb7ESZugqMNmFVAbVILayY2",
            userId,
            index.toUShort(),
            weight,
            averageScore,
            addressFaceAngleAdjustType
        ) {
            Log.d("readSwingInfo.onProgress", it.toString())
        }.whenComplete(
                {
                    val swingInfoDtoGson = SwingInfoDtoGson(
                        it.headerInfo,
                        it.vendorId,
                        it.swingData,
                        it.gpsInfo,
                        it.analyzeResultType,
                        it.swingPhaseInfo,
                        it.measurementInfo,
                        it.trajectoryInfo,
                        it.sensorInfo,
                        it.vZoneInfo)
                    val gson = GsonBuilder().registerTypeAdapter(Date::class.java, GsonUTCDateAdapter()).create()
                    val json = gson.toJson(swingInfoDtoGson);
                    callback.success(json)
                },
                {
                    callback.success(errorToString(it as MTracerSDKError))
                }
        )
    }

    // M-Tracer内のSwing情報を取得済み状態にする
    @ExperimentalUnsignedTypes
    fun writeUploadFlag(callback: MethodChannel.Result, index: Int, userId: String) {
        val mtracerSDK: MTracerSDKInterface = MTracerSDKService.getInstance(applicationContext)

        val dateTimeInfo = DateTimeInfoDto()
        dateTimeInfo.date = Date()
        dateTimeInfo.timeZoneMin = 540
        dateTimeInfo.dstType = DSTType.Min0

        mtracerSDK.writeUploadFlag(dateTimeInfo, userId, index.toUShort()).whenComplete(
            {
                callback.success("DONE")
            },
            {
                callback.success(errorToString(it as MTracerSDKError))
            }
        )
    }

    private fun errorToString(error: MTracerSDKError): String {
        when (error.error) {
            MTracerSDKError.API.BUSY -> return "ERR.API.BUSY"
            MTracerSDKError.API.CANCEL -> return "ERR.API.CANCEL"
            MTracerSDKError.API.INVALIDPARAMETER -> return "ERR.API.INVALIDPARAMETER"
            MTracerSDKError.API.TIMEDOUT -> return "ERR.API.TIMEDOUT"
            MTracerSDKError.API.UNSUPPORTED -> return "ERR.API.UNSUPPORTED"
            MTracerSDKError.API.UNKNOWN -> return "ERR.API.UNKNOWN"
            MTracerSDKError.BLE.BUSY -> return "ERR.BLE.BUSY"
            MTracerSDKError.BLE.DELAYED -> return "ERR.BLE.DELAYED"
            MTracerSDKError.BLE.DISCONNECTED -> return "ERR.BLE.DISCONNECTED"
            MTracerSDKError.BLE.DOWNGRADE -> return "ERR.BLE.DOWNGRADE"
            MTracerSDKError.BLE.INVALIDINDEX -> return "ERR.BLE.INVALIDINDEX"
            MTracerSDKError.BLE.INVALIDPARAMETER -> return "ERR.BLE.INVALIDPARAMETER"
            MTracerSDKError.BLE.INVALIDREQUEST -> return "ERR.BLE.INVALIDREQUEST"
            MTracerSDKError.BLE.INVALIDRESPONSE -> return "ERR.BLE.INVALIDRESPONSE"
            MTracerSDKError.BLE.MUTEXLOCKED -> return "ERR.BLE.MUTEXLOCKED"
            MTracerSDKError.BLE.NOTENOUGHBATTERY -> return "ERR.BLE.NOTENOUGHBATTERY"
            MTracerSDKError.BLE.POWEREDOFF -> return "ERR.BLE.POWEREDOFF"
            MTracerSDKError.BLE.LOCATIONOFF -> return "ERR.BLE.LOCATIONOFF"
            MTracerSDKError.BLE.INVALIDSIZE -> return "ERR.BLE.INVALIDSIZE"
            MTracerSDKError.BLE.TIMEDOUT -> return "ERR.BLE.TIMEDOUT"
            MTracerSDKError.BLE.UNAUTHORIZED -> return "ERR.BLE.UNAUTHORIZED"
            MTracerSDKError.BLE.UNKNOWN -> return "ERR.BLE.UNKNOWN"
            MTracerSDKError.CRC.UNMATCH -> return "ERR.CRC.UNMATCH"
            MTracerSDKError.FW.INVALIDVERSION -> return "ERR.FW.INVALIDVERSION"
            MTracerSDKError.FW.NOTFOUND -> return "ERR.FW.NOTFOUND"
            MTracerSDKError.FW.LATEST -> return "ERR.FW.LATEST"
            MTracerSDKError.HTTP.BADREQUEST -> return "ERR.HTTP.BADREQUEST"
            MTracerSDKError.HTTP.NOTFOUND -> return "ERR.HTTP.NOTFOUND"
            MTracerSDKError.HTTP.REQUESTTIMEOUT -> return "ERR.HTTP.REQUESTTIMEOUT"
            MTracerSDKError.HTTP.INTERNALSERVERERROR -> return "ERR.HTTP.INTERNALSERVERERROR"
            MTracerSDKError.HTTP.NOTIMPLEMENTED -> return "ERR.HTTP.NOTIMPLEMENTED"
            MTracerSDKError.HTTP.BADGATEWAY -> return "ERR.HTTP.BADGATEWAY"
            MTracerSDKError.HTTP.SERVICEUNAVAILABLE -> return "ERR.HTTP.SERVICEUNAVAILABLE"
            MTracerSDKError.HTTP.INVALIDDATA -> return "ERR.HTTP.INVALIDDATA"
            MTracerSDKError.HTTP.INVALIDRESPONSE -> return "ERR.HTTP.INVALIDRESPONSE"
            MTracerSDKError.HTTP.OFFLINE -> return "ERR.HTTP.OFFLINE"
            MTracerSDKError.MAINTENANCE.CALIBRATEFAILED -> return "ERR.MAINTENANCE.CALIBRATEFAILED"
            else -> return "ERR.UNKNOWN"
        }
    }
}
