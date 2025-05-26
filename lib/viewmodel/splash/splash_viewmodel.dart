import "dart:async";

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashViewModel {
  void initState() {}

  void dispose() {}

  Future<void> didBuiltView(final BuildContext context) {
    final completer = Completer<void>();

    Future.wait([
      _splash(),
    ]).then((value) {
      Navigator.of(context).pushReplacementNamed("/app");
    }).whenComplete(() {
      completer.complete();
    });

    return completer.future;
  }

  Future<void> _splash() {
    final completer = Completer<void>();

    Future.delayed(const Duration(milliseconds: 500)).whenComplete(() {
      completer.complete();
    });

    return completer.future;
  }
}
