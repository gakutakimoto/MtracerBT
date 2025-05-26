import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mtracersdkexample/appdto/swingeventinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swinginfo_appdto.dart';
import 'package:mtracersdkexample/service/mtracer_service.dart';
import 'package:mtracersdkexample/serviceinterface/mtracer_serviceinterface.dart';
import 'package:mtracersdkexample/viewvloc/basis/basis_viewvloc.dart';

class BasisViewModel {
  late BasisViewVLoC basisViewVLoC;

  late MTracerServiceInterface mtracerService;

  late StreamSubscription? _streamImpact;
  late StreamSubscription? _streamSwingInfo;

  BasisViewModel() {
    basisViewVLoC = BasisViewVLoC();

    mtracerService = MTracerService();

    _streamImpact = null;
    _streamSwingInfo = null;
  }

  void initState() {}

  void dispose() {
    if (_streamImpact != null) {
      _streamImpact!.cancel();
      _streamImpact = null;
    }

    if (_streamSwingInfo != null) {
      _streamSwingInfo!.cancel();
      _streamSwingInfo = null;
    }
  }

  Future<void> didBuiltView(final BuildContext context) async {}

  Future<void> readBatteryLevel() {
    return mtracerService.readBatteryLevel().then((_) {
      Fluttertoast.showToast(
        msg: "取得完了",
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

  Future<void> disconnect() {
    return mtracerService.disconnect().then((_) {
      Fluttertoast.showToast(
        msg: "切断完了",
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

  Future<void> receiveImpactEvent(final Function onStart) async {
    if (_streamImpact == null) {
      _streamImpact = mtracerService.receiveImpactEvent(() async {
        final viewInfo = await basisViewVLoC.viewInfo.first;
        viewInfo.isReceiveImpact = true;
        basisViewVLoC.initViewInfo.add(viewInfo);
        onStart();

        Fluttertoast.showToast(
          msg: "Impact監視開始",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          // timeInSecForIos: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }, (final SwingEventInfoAppDto swingEventInfo) {
        Fluttertoast.showToast(
          msg: "インパクト発生:" + swingEventInfo.impactId,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          // timeInSecForIos: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }, (error) {
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
    } else {
      final viewInfo = await basisViewVLoC.viewInfo.first;
      viewInfo.isReceiveImpact = false;
      basisViewVLoC.initViewInfo.add(viewInfo);
      onStart();

      _streamImpact!.cancel();
      _streamImpact = null;
    }
  }

  Future<void> receiveSwingInfoEvent(final Function onStart, final Function onData) async {
    if (_streamSwingInfo == null) {
      _streamSwingInfo = mtracerService.receiveSwingInfoEvent(() async {
        final viewInfo = await basisViewVLoC.viewInfo.first;
        viewInfo.isReceiveSwingInfo = true;
        basisViewVLoC.initViewInfo.add(viewInfo);
        onStart();

        Fluttertoast.showToast(
          msg: "Swing情報監視開始",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          // timeInSecForIos: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }, (final SwingEventInfoAppDto swingEventInfo) async {
        Fluttertoast.showToast(
          msg: "Swing情報発生:" + swingEventInfo.index.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          // timeInSecForIos: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        final swingInfo = await mtracerService.readSwingInfo(swingEventInfo.index);
        await mtracerService.writeUploadFlag(swingEventInfo.index);

        final viewInfo = await basisViewVLoC.viewInfo.first;
        viewInfo.index = swingInfo.swingHeaderInfo.index;
        viewInfo.impactHeadSpeed = swingInfo.swingMeasurementInfo.impactHeadSpeed;
        basisViewVLoC.initViewInfo.add(viewInfo);
        onData();
      }, (error) {
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
    } else {
      final viewInfo = await basisViewVLoC.viewInfo.first;
      viewInfo.isReceiveSwingInfo = false;
      basisViewVLoC.initViewInfo.add(viewInfo);
      onStart();

      _streamSwingInfo!.cancel();
      _streamSwingInfo = null;
    }
  }
}
