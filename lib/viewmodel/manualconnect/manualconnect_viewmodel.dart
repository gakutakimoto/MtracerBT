import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mtracersdkexample/service/mtracer_service.dart';
import 'package:mtracersdkexample/service/permission_service.dart';
import 'package:mtracersdkexample/serviceinterface/mtracer_serviceinterface.dart';
import 'package:mtracersdkexample/serviceinterface/permission_serviceinterface.dart';
import 'package:mtracersdkexample/viewvloc/manualconnect/manualconnect_viewvloc.dart';

class ManualConnectViewModel {
  late ManualConnectViewVLoC manualConnectViewVLoC;

  late MTracerServiceInterface mtracerService;
  late PermissionServiceInterface permissionService;

  late StreamSubscription? _stream;

  // late MTracerSDKServiceInterface mtracerSDKService;
  // late bool isScanning;
  // late StreamSubscription? startScanProgress;
  // late List<String> scanInfoList;
  // late ScanInfoListBLoC scanInfoListBLoC;
  // late NotificationInfoBLoC notificationInfoBLoC;

  ManualConnectViewModel() {
    manualConnectViewVLoC = ManualConnectViewVLoC();

    mtracerService = MTracerService();
    permissionService = PermissionService();

    _stream = null;

    // mtracerSDKService = MTracerSDKService();
    // isScanning = false;
    // startScanProgress = null;
    // scanInfoListBLoC = ScanInfoListBLoC();
    // notificationInfoBLoC = NotificationInfoBLoC();
  }

  void initState() {}

  void dispose() {
    _stopScanning();
  }

  Future<void> didBuiltView(final BuildContext context) async {
    //権限取得（Bluetooth、Location）
    await permissionService.requestPermissionForConnect();

    // _startScan();
  }

  void onPressedBackButton(final BuildContext context) {
    Navigator.of(context).pushReplacementNamed("/basis");
  }

  Future<void> startScan() async {
    final viewInfo = await manualConnectViewVLoC.viewInfo.first;
    viewInfo.isScanning = true;
    manualConnectViewVLoC.initViewInfo.add(viewInfo);

    _stream = mtracerService.startScan(_onStart, _onError);
  }

  Future<void> stopScanning() async {
    await _stopScanning();
  }

  Future<void> _stopScanning() async {
    final viewInfo = await manualConnectViewVLoC.viewInfo.first;
    viewInfo.isScanning = false;
    manualConnectViewVLoC.initViewInfo.add(viewInfo);

    if (_stream != null) {
      await _stream!.cancel();
      //スキャン終了を待つためのWait
      if (Platform.isAndroid) {
        await Future.delayed(const Duration(seconds: 1));
      }
      _stream = null;
    }
  }

  void _onStart() {
    log("_onStart");
  }

  void _onError(error) {
    log("_onError");
    log(error);
  }

  Future<void> connect(final String localName) {
    return mtracerService.connectViaAdvertize(localName).then((_) {
      Fluttertoast.showToast(
        msg: "接続完了",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        // timeInSecForIos: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: error.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        // timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }
}
