import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mtracersdkexample/driver/awss3_driver.dart';
import 'package:mtracersdkexample/driverinterface/cloudstorage_driverinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudstorage_gatewayinterface.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class AWSS3Gateway extends CloudStorageGatewayInterface {
  late CloudStorageDriverInterface cloudStorageDriver;

  AWSS3Gateway() {
    cloudStorageDriver = AWSS3Driver();
  }

  @override
  void configure() {}

  @override
  Future<bool> upload(final String accessKeyId, final String sessionToken, final String secretAccessKey, final String region, final String endpoint, final String bucket, final int expiryMinutes, final String bucketKey, final File target) {
    final completer = Completer<bool>();

    cloudStorageDriver.putObject(accessKeyId, sessionToken, secretAccessKey, region, endpoint, bucket, expiryMinutes, bucketKey, target).then((final http.StreamedResponse response) {
      if (response.statusCode == 204) {
        completer.complete(true);
      } else {
        completer.completeError(response.statusCode);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  // Future<File?> download(
  //   final String accessKeyId,
  //   final String sessionToken,
  //   final String secretAccessKey,
  //   final String region,
  //   final String host,
  //   final String bucketKey,
  // ) {
  //   final completer = Completer<File?>();

  //   late final http.Response response;
  //   cloudStorageDriver.getObject(accessKeyId, sessionToken, secretAccessKey, region, host, bucketKey).then((final http.Response _response) {
  //     if (_response.statusCode != 200) {
  //       return Future.value(null);
  //     }

  //     response = _response;
  //     return getTemporaryDirectory();
  //   }).then((final Directory? directory) {
  //     if (directory == null) {
  //       return Future.value(null);
  //     }

  //     final tmp = File(directory.path + "/tmp/" + basename(bucketKey));
  //     if (tmp.existsSync()) {
  //       tmp.deleteSync();
  //     }
  //     tmp.createSync(recursive: true);

  //     return tmp.writeAsBytes(response.bodyBytes);
  //   }).then((final File? file) {
  //     completer.complete(file);
  //   }).catchError((error) {
  //     completer.completeError(error);
  //   });

  //   return completer.future;
  // }

  Future<File?> download(
    final String url,
  ) {
    final completer = Completer<File?>();

    late final http.Response response;
    http.get(Uri.parse(url)).then((final http.Response _response) {
      if (_response.statusCode != 200) {
        return Future.value(null);
      }

      response = _response;
      // return getTemporaryDirectory();
      return getApplicationDocumentsDirectory();
    }).then((final Directory? directory) {
      if (directory == null) {
        return Future.value(null);
      }

      final tmp = File(directory.path + "/tmp/" + const Uuid().v4());
      if (tmp.existsSync()) {
        tmp.deleteSync();
      }
      tmp.createSync(recursive: true);

      return tmp.writeAsBytes(response.bodyBytes);
    }).then((final File? file) {
      completer.complete(file);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }
}
