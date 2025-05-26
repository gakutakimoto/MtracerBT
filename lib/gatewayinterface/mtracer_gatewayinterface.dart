import 'dart:async';

import 'package:mtracersdkexample/appdto/clubinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/fwinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/hwinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/productinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/profileinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingeventinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingheaderinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swinginfo_appdto.dart';

abstract class MTracerGatewayInterface {
  Future<String> connect(final String localName, final String userId);
  Future<bool> bookConnection(final String uuid);
  Future<void> disconnect();
  Future<int> readBatteryLevel(final String userId);
  Future<FWInfoAppDto> readFWInfo(final String userId);
  Future<HWInfoAppDto> readHWInfo(final String userId);
  Future<ProductInfoAppDto> readProductInfo(final String userId);
  Future<SwingInfoAppDto> readSwingInfo(final String userId, final int index, final double weight, final int averageScore, final int addressFaceAngleAdjustType);
  StreamSubscription readSwingHeaderInfoList(final String userId, final Function onStart, void Function(SwingHeaderInfoAppDto) onData, final Function onFinish, final Function onError, final bool cancelOnError);
  StreamSubscription receiveImpactEvent(final String userId, final Function onStart, void Function(SwingEventInfoAppDto) onData, final Function onError, final bool cancelOnError);
  StreamSubscription receiveSwingInfoEvent(final String userId, final Function onStart, void Function(SwingEventInfoAppDto) onData, final Function onError, final bool cancelOnError);
  StreamSubscription startScan(final Function onStart, void Function(String) onData, final Function onError, final bool cancelOnError);
  Future<bool> writeClubInfo(final String userId, final ClubInfoAppDto clubInfo);
  Future<bool> writeProfileInfo(final String userId, final ProfileInfoAppDto profileInfo);
  Future<void> writeUploadFlag(final String userId, final int index);
}
