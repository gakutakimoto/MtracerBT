class CloudStorageEndpointDataEntity {
  late String s3Region;
  late String s3EndPoint;
  late String s3Host;
  late String s3Bucket;

  CloudStorageEndpointDataEntity() {
    s3Region = "";
    s3EndPoint = "";
    s3Host = "";
    s3Bucket = "";
  }

  CloudStorageEndpointDataEntity.fromMap(final Map<String, dynamic> map) {
    s3Region = map.containsKey("s3Region") ? map["s3Region"] : "";
    s3EndPoint = map.containsKey("s3EndPoint") ? map["s3EndPoint"] : "";
    s3Host = map.containsKey("s3Host") ? map["s3Host"] : "";
    s3Bucket = map.containsKey("s3Bucket") ? map["s3Bucket"] : "";
  }
}
