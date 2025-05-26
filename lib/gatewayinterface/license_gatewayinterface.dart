import 'package:mtracersdkexample/appdto/licenseinfo_appdto.dart';

abstract class LicenseGatewayInterface {
  Future<List<LicenseInfoAppDto>> readPackageLicenseInfos();
  Future<List<LicenseInfoAppDto>> readWebLicenseInfos();
  Future<List<LicenseInfoAppDto>> readFixedLicenseInfos();
}
