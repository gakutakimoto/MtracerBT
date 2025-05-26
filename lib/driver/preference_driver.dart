import 'dart:async';
import 'package:mtracersdkexample/driverinterface/preference_driverinterface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceDriver extends PreferenceDriverInterface {
  @override
  Future<String?> readString(final String key) {
    final completer = Completer<String?>();

    SharedPreferences.getInstance().then((instance) {
      completer.complete(instance.getString(key));
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<bool> persistString(final String key, final String value) {
    final completer = Completer<bool>();

    SharedPreferences.getInstance().then((instance) {
      return instance.setString(key, value);
    }).then((isSuccess) {
      completer.complete(isSuccess);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<int?> readInt(final String key) {
    final completer = Completer<int?>();

    SharedPreferences.getInstance().then((instance) {
      completer.complete(instance.getInt(key));
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<bool> persistInt(final String key, final int value) {
    final completer = Completer<bool>();

    SharedPreferences.getInstance().then((instance) {
      return instance.setInt(key, value);
    }).then((isSuccess) {
      completer.complete(isSuccess);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<bool?> readBool(final String key) {
    final completer = Completer<bool?>();

    SharedPreferences.getInstance().then((instance) {
      completer.complete(instance.getBool(key));
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<bool> persistBool(final String key, final bool value) {
    final completer = Completer<bool>();

    SharedPreferences.getInstance().then((instance) {
      return instance.setBool(key, value);
    }).then((isSuccess) {
      completer.complete(isSuccess);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<bool> removeBy(final String key) {
    final completer = Completer<bool>();

    SharedPreferences.getInstance().then((instance) {
      return instance.remove(key);
    }).then((isSuccess) {
      completer.complete(isSuccess);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }
}
