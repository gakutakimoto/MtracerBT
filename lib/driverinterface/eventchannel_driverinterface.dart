import 'dart:async';

abstract class EventChannelDriverInterface {
  StreamSubscription receiveBroadcastStream(
    final String name,
    final dynamic arguments,
    void Function(dynamic)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  });
}
