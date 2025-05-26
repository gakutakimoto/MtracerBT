import 'dart:async';
import 'dart:io';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:mtracersdkexample/driver/component/S3Policy.dart';
import 'package:mtracersdkexample/driverinterface/cloudstorage_driverinterface.dart';
import 'package:path/path.dart' as path;

class AWSS3Driver extends CloudStorageDriverInterface {
  AWSS3Driver();

  @override
  Future<void> configure() {
    final completer = Completer<void>();
    completer.complete();
    return completer.future;
  }

  @override
  Future<http.StreamedResponse> putObject(
    final String accessKeyId,
    final String sessionToken,
    final String secretAccessKey,
    final String region,
    final String endpoint,
    final String bucket,
    final int expiryMinutes,
    final String bucketKey,
    final File target,
  ) {
    final completer = Completer<http.StreamedResponse>();

    final uri = Uri.parse(endpoint);
    final byteStream = http.ByteStream(DelegatingStream(target.openRead()));
    final length = target.lengthSync();
    final multipartFile = http.MultipartFile("file", byteStream, length, filename: path.basename(target.path));
    final policy = S3Policy.fromS3PresignedPost(accessKeyId, sessionToken, region, bucket, bucketKey, expiryMinutes, length);
    final key = SigV4.calculateSigningKey(secretAccessKey, policy.datetime, region, "s3");
    final signature = SigV4.calculateSignature(key, policy.encode());

    final req = http.MultipartRequest("POST", uri);
    req.files.add(multipartFile);
    req.fields["key"] = policy.bucketKey;
    req.fields["X-Amz-Credential"] = policy.credential;
    req.fields["X-Amz-Algorithm"] = "AWS4-HMAC-SHA256";
    req.fields["X-Amz-Date"] = policy.datetime;
    req.fields["Policy"] = policy.encode();
    req.fields["X-Amz-Signature"] = signature;
    req.fields["x-amz-security-token"] = sessionToken;

    req.send().then((final http.StreamedResponse response) {
      completer.complete(response);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<http.Response> getObject(
    final String accessKeyId,
    final String sessionToken,
    final String secretAccessKey,
    final String region,
    final String host,
    final String bucketKey,
  ) {
    final completer = Completer<http.Response>();

    final payload = SigV4.hashCanonicalRequest('');
    final datetime = SigV4.generateDatetime();

    final canonicalRequest = '''GET
${'/$bucketKey'.split('/').map((s) => Uri.encodeComponent(s)).join('/')}

host:$host
x-amz-content-sha256:$payload
x-amz-date:$datetime
x-amz-security-token:$sessionToken

host;x-amz-content-sha256;x-amz-date;x-amz-security-token
$payload''';

    final credentialScope = SigV4.buildCredentialScope(datetime, region, "s3");
    final stringToSign = SigV4.buildStringToSign(datetime, credentialScope, SigV4.hashCanonicalRequest(canonicalRequest));
    final signingKey = SigV4.calculateSigningKey(secretAccessKey, datetime, region, "s3");
    final signature = SigV4.calculateSignature(signingKey, stringToSign);

    final authorization = [
      "AWS4-HMAC-SHA256 Credential=$accessKeyId/$credentialScope",
      "SignedHeaders=host;x-amz-content-sha256;x-amz-date;x-amz-security-token",
      "Signature=$signature",
    ].join(",");

    http.get(Uri.https(host, bucketKey), headers: {
      "Authorization": authorization,
      "x-amz-content-sha256": payload,
      "x-amz-date": datetime,
      "x-amz-security-token": sessionToken,
    }).then((final http.Response response) {
      completer.complete(response);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }
}
