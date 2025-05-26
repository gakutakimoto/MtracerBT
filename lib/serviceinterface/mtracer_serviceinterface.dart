import 'dart:async';

import 'package:mtracersdkexample/appdto/swingeventinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swinginfo_appdto.dart';

abstract class MTracerServiceInterface {
  Future<void> bookConnection();
  Future<void> cancelConnectViaNFC();
  Future<bool> connectViaAdvertize(final String localName);
  Future<bool> connectViaNFC();
  Future<void> disconnect();
  Future<void> readBatteryLevel();
  Future<bool> readLocalDeviceInfo();
  Future<void> readLocalSwingInfo();
  Future<SwingInfoAppDto> readSwingInfo(final int index);
  Future<int> readSwingInfoCount();
  StreamSubscription receiveImpactEvent(final Function onStart, void Function(SwingEventInfoAppDto) onData, final Function onError);
  StreamSubscription receiveSwingInfoEvent(final Function onStart, void Function(SwingEventInfoAppDto) onData, final Function onError);
  StreamSubscription startScan(final Function onStart, final Function onError);
  Future<bool> updateDeviceInfo();
  Future<void> writeClubInfo();
  Future<void> writeProfileInfo();
  Future<void> writeUploadFlag(final int index);
}
