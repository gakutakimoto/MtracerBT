import 'dart:async';
import 'package:flutter/services.dart';
import 'package:mtracersdkexample/driverinterface/eventchannel_driverinterface.dart';

class EventChannelDriver extends EventChannelDriverInterface {
  @override
  StreamSubscription receiveBroadcastStream(
    final String name,
    final dynamic arguments,
    void Function(dynamic)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return EventChannel(name).receiveBroadcastStream(arguments).listen(
          onData,
          onError: onError,
          onDone: onDone,
          cancelOnError: cancelOnError,
        );
  }
}
