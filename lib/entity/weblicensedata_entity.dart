class WebLicenseDataEntity {
  late String licenseName;
  late String licenseUrl;

  WebLicenseDataEntity() {
    licenseName = "";
    licenseUrl = "";
  }

  WebLicenseDataEntity.fromMap(final Map<String, dynamic> map) {
    licenseName = map.containsKey("licenseName") ? map["licenseName"] : "";
    licenseUrl = map.containsKey("licenseUrl") ? map["licenseUrl"] : "";
  }
}
