class MTSwingGPSDataEntity {
  late double latitude;
  late double longitude;
  late double altitude;

  MTSwingGPSDataEntity() {
    latitude = 0.0;
    longitude = 0.0;
    altitude = 0.0;
  }

  MTSwingGPSDataEntity.fromMap(final Map<String, dynamic> map) {
    latitude = map.containsKey("latitude") ? double.parse(map["latitude"].toString()) : 0.0;
    longitude = map.containsKey("longitude") ? double.parse(map["longitude"].toString()) : 0.0;
    altitude = map.containsKey("altitude") ? double.parse(map["altitude"].toString()) : 0.0;
  }
}
