import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mtracersdkexample/driverinterface/cloudapi_driverinterface.dart';

class AWSAppSyncDriver extends CloudAPIDriverInterface {
  AWSAppSyncDriver();

  @override
  Future<void> configure() {
    final completer = Completer<void>();
    completer.complete();
    return completer.future;
  }

  @override
  Future<http.Response> request(final Uri endpoint, final String operationName, final String query, final String accessToken, {final int timeout = 20}) {
    final completer = Completer<http.Response>();

    final body = {
      "operationName": operationName,
      "query": query,
    };

    try {
      http.post(endpoint, headers: {"Authorization": accessToken, "Content-Type": "application/json"}, body: json.encode(body)).timeout(Duration(seconds: timeout)).then((final http.Response response) {
        completer.complete(response);
      }).catchError((error) {
        completer.completeError(error);
      });
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }
}
