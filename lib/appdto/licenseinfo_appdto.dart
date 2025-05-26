import 'package:mtracersdkexample/appdto/license_type.dart';

class LicenseInfoAppDto {
  late String licenseName;
  late LicenseType licenseType;
  late String licenseInfo;

  LicenseInfoAppDto() {
    licenseName = "";
    licenseType = LicenseType.fixed;
    licenseInfo = "";
  }
}
