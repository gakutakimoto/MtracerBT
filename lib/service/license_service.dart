import 'dart:async';
import 'package:mtracersdkexample/appdto/licenseinfo_appdto.dart';
import 'package:mtracersdkexample/datastore/licenseinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/gateway/license_gateway.dart';
import 'package:mtracersdkexample/gatewayinterface/license_gatewayinterface.dart';
import 'package:mtracersdkexample/serviceinterface/license_serviceinterface.dart';

class LicenseService extends LicenseServiceInterface {
  late LicenseGatewayInterface licenseGateway;

  late DatastoreInterface<void Function(List<LicenseInfoAppDto>), List<LicenseInfoAppDto>> licenseInfoDatastore;

  LicenseService() {
    licenseGateway = LicenseGateway();
    licenseInfoDatastore = LicenseInfoDatastore();
  }

  @override
  Future<void> configure() {
    final completer = Completer<void>();

    var licenseInfos = <LicenseInfoAppDto>[];
    licenseGateway.readPackageLicenseInfos().then((final List<LicenseInfoAppDto> _packageLicenseInfos) {
      for (final packageLicenseInfo in _packageLicenseInfos) {
        licenseInfos.add(packageLicenseInfo);
      }

      return licenseGateway.readWebLicenseInfos();
    }).then((final List<LicenseInfoAppDto> _webLicenseInfos) {
      for (final webLicenseInfo in _webLicenseInfos) {
        licenseInfos.add(webLicenseInfo);
      }

      return licenseGateway.readFixedLicenseInfos();
    }).then((final List<LicenseInfoAppDto> _fixedLicenseInfos) {
      for (final fixedLicenseInfo in _fixedLicenseInfos) {
        licenseInfos.add(fixedLicenseInfo);
      }

      return Future.value();
    }).then((_) {
      licenseInfos.sort((a, b) => a.licenseName.compareTo(b.licenseName));
      licenseInfoDatastore.publish(licenseInfos);

      completer.complete();
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }
}
