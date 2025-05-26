import 'dart:async';

import 'package:flutter/services.dart' show rootBundle;
import 'package:mtracersdkexample/driverinterface/stringassets_driverinterface.dart';

class StringAssetsDriver implements StringAssetsDriverInterface {
  @override
  Future<String> read(final String key) {
    final completer = Completer<String>();

    try {
      rootBundle.loadString(key).then((final String value) {
        completer.complete(value);
      }).catchError((error) {
        completer.completeError(error);
      });
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }
}
