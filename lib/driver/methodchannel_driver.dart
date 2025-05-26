import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mtracersdkexample/driverinterface/methodchannel_driverinterface.dart';

class MethodChannelDriver implements MethodChannelDriverInterface {
  late MethodChannel methodChannel;

  MethodChannelDriver(final String methodChannelName) {
    methodChannel = MethodChannel(methodChannelName);
  }

  @override
  Future<T> invokeMethod<T>(final String methodName, [final dynamic arguments]) {
    final completer = Completer<T>();

    try {
      methodChannel.invokeMethod(methodName, arguments).then((value) {
        completer.complete(value);
      }).catchError((error) {
        completer.completeError(error);
      });
    } catch (error) {
      completer.completeError(error);
    }

    return completer.future;
  }
}
