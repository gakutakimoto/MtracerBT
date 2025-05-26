package com.u5007710.mtracer.golf.sdk.example

import android.app.PendingIntent
import android.content.Intent
import android.content.IntentFilter
import android.nfc.NdefMessage
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.nfc.tech.Ndef
import android.os.Bundle
import android.util.Log
import com.epson.mtracer.sdk.dto.AddressFaceAngleAdjustType
import com.u5007710.mtracer.golf.sdk.example.service.MTracerService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*
import kotlin.collections.ArrayList
import kotlin.concurrent.schedule

class MainActivity: FlutterActivity() {
    private lateinit var startScanChannel: EventChannel
    private lateinit var receiveImpactEventChannel: EventChannel
    private lateinit var receiveSwingInfoEventChannel: EventChannel
    private lateinit var readSwingHeaderInfoListChannel: EventChannel

    private var nfcAdapter: NfcAdapter? = null
    private var pendingIntent: PendingIntent? = null
    private var intentFilters: Array<IntentFilter>? = null
    private var techLists: Array<Array<String>>? = null
    private var dataHolder = DataHolder(null, null, null)
    private val mtracerService  = MTracerService(this)

    private var timerNFCReader: TimerTask? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        val nfcIOChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "M-TracerSDK.NFC/io")
        nfcIOChannel.setMethodCallHandler { methodCall: MethodCall, callback: MethodChannel.Result ->
            when (methodCall.method) {
                "wakeupNFCReader" -> {
                    wakeupNFCReader(callback)
                }
                "sleepNFCReader" -> {
                    sleepNFCReader()
                }
            }
        }

        startScanChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "M-TracerSDK.API/stream_startScan")
        startScanChannel.setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                    when ((arguments as ArrayList<*>)[0].toString()) {
                        "startScan" -> {
                            startScan(events)
                        }
                    }
                }
                override fun onCancel(arguments: Any?) {
                    when ((arguments as ArrayList<*>)[0].toString()) {
                        "startScan" -> {
                            stopScan()
                        }
                    }
                }
            }
        )

        receiveImpactEventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "M-TracerSDK.API/stream_receiveImpactEvent")
        receiveImpactEventChannel.setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                    val eventName = (arguments as ArrayList<*>)[0].toString()
                    val userId = (arguments)[1].toString()
                    when (eventName) {
                        "receiveImpactEvent" -> {
                            receiveImpactEvent(events, userId)
                        }
                    }
                }
                override fun onCancel(arguments: Any?) {
                    val eventName = (arguments as ArrayList<*>)[0].toString()
                    val userId = (arguments)[1].toString()

                    when (eventName) {
                        "receiveImpactEvent" -> {
                            ignoreImpactEvent(userId)
                        }
                    }
                }
            }
        )

        receiveSwingInfoEventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "M-TracerSDK.API/stream_receiveSwingInfoEvent")
        receiveSwingInfoEventChannel.setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                    val eventName = (arguments as ArrayList<*>)[0].toString()
                    val userId = (arguments)[1].toString()
                    when (eventName) {
                        "receiveSwingInfoEvent" -> {
                            receiveSwingInfoEvent(events, userId)
                        }
                    }
                }
                override fun onCancel(arguments: Any?) {
                    val eventName = (arguments as ArrayList<*>)[0].toString()
                    val userId = (arguments)[1].toString()

                    when (eventName) {
                        "receiveSwingInfoEvent" -> {
                            ignoreSwingInfoEvent(userId)
                        }
                    }
                }
            }
        )

        readSwingHeaderInfoListChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "M-TracerSDK.API/stream_readSwingHeaderInfoList")
        readSwingHeaderInfoListChannel.setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                    val eventName = (arguments as ArrayList<*>)[0].toString()
                    val userId = (arguments)[1].toString()
                    when (eventName) {
                        "readSwingHeaderInfoList" -> {
                            readSwingHeaderInfo(events, userId)
                        }
                    }
                }
                override fun onCancel(arguments: Any?) {
                    when ((arguments as ArrayList<*>)[0].toString()) {
                        "readSwingHeaderInfoList" -> {
                            ignoreSwingHeaderInfo()
                        }
                    }
                }
            }
        )

        val apiIOChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "M-TracerSDK.API/io")
        apiIOChannel.setMethodCallHandler { methodCall: MethodCall, callback: MethodChannel.Result ->
            when (methodCall.method) {
                "connect" -> {
                    val userId = methodCall.argument<String>("userId").toString()
                    val localName = methodCall.argument<String>("localName").toString()
                    connect(callback, userId, localName)
                }
                "disconnect" -> {
                    disconnect(callback)
                }
                "bookConnection" -> {
                    val uuid = methodCall.argument<String>("uuid").toString()
                    bookConnection(callback, uuid)
                }
                "readBatteryLevel" -> {
                    val userId = methodCall.argument<String>("userId").toString()
                    readBatteryLevel(callback, userId)
                }
                "writeProfileInfo" -> {
                    val userId = methodCall.argument<String>("userId").toString()
                    val json = methodCall.argument<String>("JSON").toString()
                    writeProfileInfo(callback, userId, json)
                }
                "readProductInfo" -> {
                    val userId = methodCall.argument<String>("userId").toString()
                    readProductInfo(callback, userId)
                }
                "readHWInfo" -> {
                    val userId = methodCall.argument<String>("userId").toString()
                    readHWInfo(callback, userId)
                }
                "readFWInfo" -> {
                    val userId = methodCall.argument<String>("userId").toString()
                    readFWInfo(callback, userId)
                }
                "readSwingInfo" -> {
                    val index = (methodCall.arguments as HashMap<*, *>)["index"] as Int
                    val userId = (methodCall.arguments as HashMap<*, *>)["userId"] as String
                    val weight = (methodCall.arguments as HashMap<*, *>)["weight"] as Double
                    val averageScore = (methodCall.arguments as HashMap<*, *>)["averageScore"] as Int
                    val faceAngleAdjustType = (methodCall.arguments as HashMap<*, *>)["addressFaceAngleAdjustType"] as Int
                    var addressFaceAngleAdjustType: AddressFaceAngleAdjustType
                    when (faceAngleAdjustType) {
                        0 -> {
                            addressFaceAngleAdjustType = AddressFaceAngleAdjustType.OPEN_HIGH
                        }
                        1 -> {
                            addressFaceAngleAdjustType = AddressFaceAngleAdjustType.OPEN_MEDIUM
                        }
                        2 -> {
                            addressFaceAngleAdjustType = AddressFaceAngleAdjustType.OPEN_LOW
                        }
                        3 -> {
                            addressFaceAngleAdjustType = AddressFaceAngleAdjustType.SQUARE
                        }
                        4 -> {
                            addressFaceAngleAdjustType = AddressFaceAngleAdjustType.CLOSE_LOW
                        }
                        5 -> {
                            addressFaceAngleAdjustType = AddressFaceAngleAdjustType.CLOSE_MEDIUM
                        }
                        6 -> {
                            addressFaceAngleAdjustType = AddressFaceAngleAdjustType.CLOSE_HIGH
                        }
                        else ->{
                            addressFaceAngleAdjustType = AddressFaceAngleAdjustType.SQUARE
                        }
                    }
                    readSwingInfo(callback, index, userId,weight,averageScore, addressFaceAngleAdjustType)
                }
                "writeUploadFlag" -> {
                    val userId = methodCall.argument<String>("userId").toString()
                    val index = methodCall.argument<Int>("index") as Int
                    writeUploadFlag(callback, index, userId)
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val intent = Intent(this, javaClass).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
        pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_IMMUTABLE)
    }

    override fun onResume() {
        super.onResume()
        if (nfcAdapter != null) {
            nfcAdapter?.enableForegroundDispatch(this, pendingIntent, intentFilters, techLists)
        }
    }

    override fun onPause() {
        super.onPause()
//        if (nfcAdapter != null) {
//            nfcAdapter?.disableForegroundDispatch(this)
//        }
        disableForegroundDispatch()
    }

    override fun onDestroy() {
        super.onDestroy()
    }

    private fun disableForegroundDispatch() {
        if (nfcAdapter != null) {
            nfcAdapter?.disableForegroundDispatch(this)
        }
    }

    private fun wakeupNFCReader(callback: MethodChannel.Result) {
        intentFilters = arrayOf(IntentFilter(NfcAdapter.ACTION_NDEF_DISCOVERED))
        techLists = arrayOf(arrayOf(android.nfc.tech.Ndef::class.java.name), arrayOf(android.nfc.tech.NdefFormatable::class.java.name))
        nfcAdapter = NfcAdapter.getDefaultAdapter(applicationContext)
        if (nfcAdapter != null) {
            nfcAdapter?.enableForegroundDispatch(this, pendingIntent, intentFilters, techLists)
        }

        dataHolder.callback = callback


        timerNFCReader = Timer().schedule(60000) {
            println("3 second elapsed")
            sleepNFCReader()
        }
    }

    private fun sleepNFCReader() {
        if (timerNFCReader != null) {
            timerNFCReader?.cancel()
            timerNFCReader = null
        }

        disableForegroundDispatch()

        if (dataHolder.callback != null) {
            dataHolder.callback?.success("ERR.NFC.CANCEL")
            dataHolder.callback = null
        }
    }

    override fun onNewIntent(intent: Intent) {
        if(NfcAdapter.ACTION_TECH_DISCOVERED == intent.action || NfcAdapter.ACTION_NDEF_DISCOVERED == intent.action) {
            val tag = intent.getParcelableExtra<Tag>(NfcAdapter.EXTRA_TAG) ?: return
            Ndef.get(tag) ?: return
            val raws = intent.getParcelableArrayExtra(NfcAdapter.EXTRA_NDEF_MESSAGES) ?: return
            val msgs = arrayOfNulls<NdefMessage>(raws.size)
            var deviceName = ""

            for(i in raws.indices) {
                msgs[i] = raws[i] as NdefMessage?
                if(msgs[i] != null) {
                    for (record in msgs[i]?.records!!) {
                        Log.d("TAG", "TNF：" + record.tnf)
                        Log.d("TAG", "Type：" + String(record.type))

                        // payload（データ本体）
                        Log.d("TAG", "payload：" + String(record.payload))
                        // payloadからメッセージ部分を抽出
                        deviceName = String(record.payload, 3, record.payload.size - 3)
                        Log.d("TAG", "payload-message：$deviceName")

                        // payloadの中身を1byteずつ表示
                        for(j in record.payload.indices){
                            Log.d("TAG", String.format("payload[%d] : 0x%02x / %c", j, record.payload[j].toInt() and 0xFF, record.payload[j].toInt() and 0xFF))
                        }
                    }
                }
            }

            intentFilters = null
            techLists = null
            nfcAdapter = null

            if (timerNFCReader != null) {
                timerNFCReader?.cancel()
                timerNFCReader = null
            }

            if (dataHolder.callback != null) {
                dataHolder.callback?.success(deviceName)
                dataHolder.callback = null
            }
        }
    }

    //MARK: M-Tracerを検索する
    @ExperimentalUnsignedTypes
    private fun startScan(eventSink: EventChannel.EventSink) {
        mtracerService.startScan(eventSink)
    }

    //MARK: M-Tracerの検索を終了する
    private fun stopScan() {
        mtracerService.stopScan()
    }

    //MARK: M-Tracerの監視を開始する(インパクト)
    private fun receiveImpactEvent(eventSink: EventChannel.EventSink, userId: String) {
        mtracerService.receiveImpactEvent(eventSink, userId)
    }

    //MARK: M-Tracerの監視を終了する(インパクト)
    private fun ignoreImpactEvent(userId: String) {
        mtracerService.ignoreImpactEvent(userId)
    }

    //MARK: M-Tracerの監視を開始する(Swing情報)
    private fun receiveSwingInfoEvent(eventSink: EventChannel.EventSink, userId: String) {
        mtracerService.receiveSwingInfoEvent(eventSink, userId)
    }

    //MARK: M-Tracerの監視を終了する(Swing情報)
    private fun ignoreSwingInfoEvent(userId: String) {
        mtracerService.ignoreSwingInfoEvent(userId)
    }

    //MARK: M-TracerからSwing情報一覧を取得する
    private fun readSwingHeaderInfo(eventSink: EventChannel.EventSink, userId: String) {
        mtracerService.readSwingHeaderInfo(eventSink, userId)
    }

    //MARK: M-TracerからSwing情報一覧を取得停止する
    private fun ignoreSwingHeaderInfo() {
    }

    //MARK: M-TracerとのBLE接続を開始する
    private fun connect(callback: MethodChannel.Result, userId: String, localName: String) {
        mtracerService.connect(callback, userId, localName)
    }

    //MARK: M-Tracerと切断する
    private fun disconnect(callback: MethodChannel.Result) {
        mtracerService.disconnect(callback)
    }

    //MARK: M-TracerとのBLE自動再接続を予約する
    private fun bookConnection(callback: MethodChannel.Result, uuid: String) {
        mtracerService.bookConnection(callback, uuid)
    }

    // M-Tracerの電池残量を取得する
    private fun readBatteryLevel(callback: MethodChannel.Result, userId: String) {
        mtracerService.readBatteryLevel(callback, userId)
    }

    //MARK: M-Tracerのプロフィール情報を変更する
    private fun writeProfileInfo(callback: MethodChannel.Result, userId: String, json: String) {
        mtracerService.writeProfileInfo(callback, userId, json)
    }

    //MARK: M-Tracerから製品情報を取得する
    private fun readProductInfo(callback: MethodChannel.Result, userId: String) {
        mtracerService.readProductInfo(callback, userId)
    }

    //MARK: M-TracerからHW情報を取得する
    private fun readHWInfo(callback: MethodChannel.Result, userId: String) {
        mtracerService.readHWInfo(callback, userId)
    }

    //MARK: M-TracerからFW情報を取得する
    private fun readFWInfo(callback: MethodChannel.Result, userId: String) {
        mtracerService.readFWInfo(callback, userId)
    }

    //MARK: M-TracerからSwing情報を取得する
    private fun readSwingInfo(callback: MethodChannel.Result, index: Int, userId: String, weight: Double, averageScore: Int, addressFaceAngleAdjustType: AddressFaceAngleAdjustType) {
        mtracerService.readSwingInfo(callback, index, userId, weight, averageScore, addressFaceAngleAdjustType)
    }

    // M-Tracer内のSwing情報を取得済み状態にする
    private fun writeUploadFlag(callback: MethodChannel.Result, index: Int, userId: String) {
        mtracerService.writeUploadFlag(callback, index, userId)
    }
}
