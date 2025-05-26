class FixedLicenseDataEntity {
  late String licenseName;
  late String licenseText;

  FixedLicenseDataEntity() {
    licenseName = "";
    licenseText = "";
  }

  FixedLicenseDataEntity.fromMap(final Map<String, dynamic> map) {
    licenseName = map.containsKey("licenseName") ? map["licenseName"] : "";
    licenseText = map.containsKey("licenseText") ? map["licenseText"] : "";
  }
}
