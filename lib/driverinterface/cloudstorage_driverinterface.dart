import 'dart:io';

import 'package:http/http.dart' as http;

abstract class CloudStorageDriverInterface {
  Future<void> configure();
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
  );
  Future<http.Response> getObject(
    final String accessKeyId,
    final String sessionToken,
    final String secretAccessKey,
    final String region,
    final String host,
    final String bucketKey,
  );
}
