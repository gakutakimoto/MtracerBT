import 'dart:async';

import 'package:mtracersdkexample/driver/methodchannel_driver.dart';
import 'package:mtracersdkexample/driverinterface/methodchannel_driverinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/nfc_gatewayinterface.dart';

class NFCGateway extends NFCGatewayInterface {
  late MethodChannelDriverInterface methodChannelDriver;

  NFCGateway() {
    methodChannelDriver = MethodChannelDriver("M-TracerGolf.NFC/io");
  }

  @override
  Future<String> wakeupNFCReader() {
    final completer = Completer<String>();

    methodChannelDriver.invokeMethod<String>("wakeupNFCReader").then((final String response) {
      if (response.contains("ERR.")) {
        completer.completeError(response);
        return;
      }

      completer.complete(response);
    });

    return completer.future;
  }

  @override
  Future<String> sleepNFCReader() {
    final completer = Completer<String>();

    methodChannelDriver.invokeMethod<String>("sleepNFCReader").then((final String response) {
      if (response.contains("ERR.")) {
        completer.completeError(response);
        return;
      }

      completer.complete(response);
    });

    return completer.future;
  }
}
