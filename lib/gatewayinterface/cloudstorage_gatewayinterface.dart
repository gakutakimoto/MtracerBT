import 'dart:io';

abstract class CloudStorageGatewayInterface {
  void configure();
  Future<bool> upload(
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
  // Future<File?> download(
  //   final String accessKeyId,
  //   final String sessionToken,
  //   final String secretAccessKey,
  //   final String region,
  //   final String host,
  //   final String bucketKey,
  // );
  Future<File?> download(
    final String url,
  );
}
