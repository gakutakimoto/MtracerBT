// ignore_for_file: file_names
import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';

class S3Policy {
  String credential;
  String sessionToken;
  String region;
  String bucket;
  String bucketKey;
  String datetime;
  String expiration;
  int maxFileSize;

  S3Policy(this.credential, this.sessionToken, this.region, this.bucket, this.bucketKey, this.datetime, this.expiration, this.maxFileSize);

  factory S3Policy.fromS3PresignedPost(final String accessKeyId, final String sessionToken, final String region, final String bucket, final String bucketKey, final int expiryMinutes, final int maxFileSize) {
    final datetime = SigV4.generateDatetime();
    final expiration = (DateTime.now()).add(Duration(minutes: expiryMinutes)).toUtc().toString().split(" ").join("T");
    final credential = "$accessKeyId/${SigV4.buildCredentialScope(datetime, region, "s3")}";
    final s3Policy = S3Policy(credential, sessionToken, region, bucket, bucketKey, datetime, expiration, maxFileSize);
    return s3Policy;
  }

  String encode() {
    final bytes = utf8.encode(toString());
    return base64.encode(bytes);
  }

  @override
  String toString() {
    // Safe to remove the "acl" line if your bucket has no ACL permissions
    // {"acl": "public-read"},
    return '''
    { "expiration": "$expiration",
      "conditions": [
        {"x-amz-algorithm": "AWS4-HMAC-SHA256"},
        {"x-amz-credential": "$credential"},
        {"x-amz-security-token": "$sessionToken"},
        {"bucket": "$bucket"},
        ["starts-with", "\$key", "$bucketKey"],
        {"x-amz-date": "$datetime" },
        ["content-length-range", 1, $maxFileSize],
      ]
    }
    ''';
  }
}
