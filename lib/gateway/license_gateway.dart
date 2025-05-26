import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mtracersdkexample/appdto/license_type.dart';
import 'package:mtracersdkexample/appdto/licenseinfo_appdto.dart';
import 'package:mtracersdkexample/driver/stringassets_driver.dart';
import 'package:mtracersdkexample/driverinterface/stringassets_driverinterface.dart';
import 'package:mtracersdkexample/entity/fixedlicensedata_entity.dart';
import 'package:mtracersdkexample/entity/weblicensedata_entity.dart';
import 'package:mtracersdkexample/gatewayinterface/license_gatewayinterface.dart';

class LicenseGateway implements LicenseGatewayInterface {
  late StringAssetsDriverInterface stringAssetsDriver;

  LicenseGateway() {
    stringAssetsDriver = StringAssetsDriver();
  }

  @override
  Future<List<LicenseInfoAppDto>> readPackageLicenseInfos() {
    final completer = Completer<List<LicenseInfoAppDto>>();

    LicenseRegistry.licenses.toList().then((licenses) {
      final licenseInfos = <LicenseInfoAppDto>[];

      for (var license in licenses) {
        final packages = license.packages.toList();
        final paragraphs = license.paragraphs.toList();
        final packageName = packages.map((e) => e).join('');
        final paragraphText = paragraphs.map((e) => e.text).join('\n');

        // 同じライセンス情報が流れてくる場合があるため、追加済の情報はリストに加えない。
        var isExist = false;
        for (LicenseInfoAppDto licenseInfo in licenseInfos) {
          if (licenseInfo.licenseName.compareTo(packageName) == 0) {
            isExist = true;
            break;
          }
        }
        if (!isExist) {
          final LicenseInfoAppDto dto = LicenseInfoAppDto();
          dto.licenseName = packageName;
          dto.licenseInfo = paragraphText;
          dto.licenseType = LicenseType.package;
          licenseInfos.add(dto);
        }
      }

      completer.complete(licenseInfos);
    }).onError((error, stackTrace) {
      completer.completeError(stackTrace);
    });

    return completer.future;
  }

  @override
  Future<List<LicenseInfoAppDto>> readWebLicenseInfos() {
    final completer = Completer<List<LicenseInfoAppDto>>();

    stringAssetsDriver.read("assets/license/license.json").then((final String params) {
      late String jsonKey;
      if (Platform.isAndroid) {
        jsonKey = "androidWebLicenseInfos";
      } else {
        jsonKey = "iosWebLicenseInfos";
      }

      final rawEntities = json.decode(params);
      if (rawEntities[jsonKey] == null) {
        completer.completeError("ERR.PARAMS.NOTFOUND");
      } else {
        final List<LicenseInfoAppDto> dtoList = [];
        for (final Map<String, dynamic> rawEntity in rawEntities[jsonKey]) {
          final entity = WebLicenseDataEntity.fromMap(rawEntity);
          final LicenseInfoAppDto dto = LicenseInfoAppDto();
          dto.licenseName = entity.licenseName;
          dto.licenseInfo = entity.licenseUrl;
          dto.licenseType = LicenseType.web;
          dtoList.add(dto);
        }

        completer.complete(dtoList);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<List<LicenseInfoAppDto>> readFixedLicenseInfos() {
    final completer = Completer<List<LicenseInfoAppDto>>();

    stringAssetsDriver.read("assets/license/license.json").then((final String params) {
      final rawEntities = json.decode(params);
      if (rawEntities["fixedLicenseInfos"] == null) {
        completer.completeError("ERR.PARAMS.NOTFOUND");
      } else {
        final List<LicenseInfoAppDto> dtoList = [];
        for (final Map<String, dynamic> rawEntity in rawEntities["fixedLicenseInfos"]) {
          final entity = FixedLicenseDataEntity.fromMap(rawEntity);
          final LicenseInfoAppDto dto = LicenseInfoAppDto();
          dto.licenseName = entity.licenseName;
          dto.licenseInfo = entity.licenseText;
          dto.licenseType = LicenseType.fixed;
          dtoList.add(dto);
        }

        completer.complete(dtoList);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }
}
