import 'dart:async';
import 'dart:convert';

import 'package:mtracersdkexample/appdto/clubinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/clubshafthardness_type.dart';
import 'package:mtracersdkexample/appdto/fwinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/gender_type.dart';
import 'package:mtracersdkexample/appdto/hwinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/productinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/profileinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingeventinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingheaderinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swinginfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userswinginfo_appdto.dart';
import 'package:mtracersdkexample/driver/eventchannel_driver.dart';
import 'package:mtracersdkexample/driver/methodchannel_driver.dart';
import 'package:mtracersdkexample/driverinterface/eventchannel_driverinterface.dart';
import 'package:mtracersdkexample/driverinterface/methodchannel_driverinterface.dart';
import 'package:mtracersdkexample/entity/mtfwdata_entity.dart';
import 'package:mtracersdkexample/entity/mthwdata_entity.dart';
import 'package:mtracersdkexample/entity/mtproductdata_entity.dart';
import 'package:mtracersdkexample/entity/mtswingeventdata_entity.dart';
import 'package:mtracersdkexample/gatewayinterface/mtracer_gatewayinterface.dart';
import 'package:mtracersdkexample/logic/club_logic.dart';
import 'package:mtracersdkexample/logic/swing_logic.dart';
import 'package:mtracersdkexample/logicinterface/club_logicinterface.dart';
import 'package:mtracersdkexample/logicinterface/swing_logicinterface.dart';
import 'package:uuid/uuid.dart';

class MTracerGateway extends MTracerGatewayInterface {
  late MethodChannelDriverInterface methodChannelDriver;
  late EventChannelDriverInterface eventChannelDriver;
  late ClubLogicInterface clubLogic;
  late SwingLogicInterface swingLogic;

  MTracerGateway() {
    methodChannelDriver = MethodChannelDriver("M-TracerSDK.API/io");
    eventChannelDriver = EventChannelDriver();
    clubLogic = ClubLogic();
    swingLogic = SwingLogic();
  }

  @override
  Future<bool> bookConnection(final String uuid) {
    final completer = Completer<bool>();

    methodChannelDriver.invokeMethod<String>("bookConnection", {"uuid": uuid}).then((final String response) {
      if (response.isEmpty) {
        completer.completeError("UNKOWN");
        return;
      }

      if (response.contains("ERR.")) {
        completer.completeError(response.toString());
        return;
      }

      completer.complete(true);
    });

    return completer.future;
  }

  @override
  Future<String> connect(final String localName, final String userId) {
    final completer = Completer<String>();

    methodChannelDriver.invokeMethod<String>("connect", {"localName": localName, "userId": userId}).then((final String response) {
      if (response.isEmpty) {
        completer.completeError("ERR.UNKOWNDEVICE");
        return;
      }

      if (response.contains("ERR.")) {
        completer.completeError(response.toString());
        return;
      }

      completer.complete(response);
    });

    return completer.future;
  }

  @override
  Future<void> disconnect() {
    final completer = Completer<void>();

    methodChannelDriver.invokeMethod<String>("disconnect").then((final String response) {
      if (response.isEmpty) {
        completer.completeError("ERR.UNKOWNDEVICE");
        return;
      }

      if (response.contains("ERR.")) {
        completer.completeError(response.toString());
        return;
      }

      completer.complete();
    });

    return completer.future;
  }

  @override
  Future<int> readBatteryLevel(final String userId) {
    final completer = Completer<int>();

    methodChannelDriver.invokeMethod<String>("readBatteryLevel", {"userId": userId}).then((final String response) {
      if (response.isEmpty) {
        completer.completeError("UNKOWN");
        return;
      }

      if (response.contains("ERR.")) {
        completer.completeError(response.toString());
        return;
      }

      completer.complete(int.parse(response));
    });

    return completer.future;
  }

  @override
  Future<FWInfoAppDto> readFWInfo(final String userId) {
    final completer = Completer<FWInfoAppDto>();

    methodChannelDriver.invokeMethod<String>("readFWInfo", {"userId": userId}).then((final String response) {
      if (response.isEmpty) {
        completer.completeError("UNKOWN");
        return;
      }

      if (response.contains("ERR.")) {
        completer.completeError(response.toString());
        return;
      }

      final entity = MTFWDataEntity.fromMap(json.decode(response));
      final dto = FWInfoAppDto();
      dto.versionNo = entity.versionNo;

      completer.complete(dto);
    });

    return completer.future;
  }

  @override
  Future<HWInfoAppDto> readHWInfo(final String userId) {
    final completer = Completer<HWInfoAppDto>();

    methodChannelDriver.invokeMethod<String>("readHWInfo", {"userId": userId}).then((final String response) {
      if (response.isEmpty) {
        completer.completeError("UNKOWN");
        return;
      }

      if (response.contains("ERR.")) {
        completer.completeError(response.toString());
        return;
      }

      final entity = MTHWDataEntity.fromMap(json.decode(response));
      final dto = HWInfoAppDto();
      dto.serialNo = entity.serialNo;

      completer.complete(dto);
    });

    return completer.future;
  }

  @override
  Future<ProductInfoAppDto> readProductInfo(final String userId) {
    final completer = Completer<ProductInfoAppDto>();

    methodChannelDriver.invokeMethod<String>("readProductInfo", {"userId": userId}).then((final String response) {
      if (response.isEmpty) {
        completer.completeError("UNKOWN");
        return;
      }

      if (response.contains("ERR.")) {
        completer.completeError(response.toString());
        return;
      }

      final entity = MTProductDataEntity.fromMap(json.decode(response));
      final dto = ProductInfoAppDto();
      dto.modelName = entity.modelName;
      dto.modelCode = entity.modelCode;
      dto.destinationCode = entity.destinationCode;
      dto.productGrade = entity.productGrade;

      completer.complete(dto);
    });

    return completer.future;
  }

  @override
  Future<SwingInfoAppDto> readSwingInfo(final String userId, final int index, final double weight, final int averageScore, final int addressFaceAngleAdjustType) {
    final completer = Completer<SwingInfoAppDto>();

    methodChannelDriver.invokeMethod<String>("readSwingInfo", {"userId": userId, "index": index, "weight": weight, "averageScore": averageScore, "addressFaceAngleAdjustType": addressFaceAngleAdjustType}).then((final String response) {
      if (response.isEmpty) {
        completer.completeError("UNKOWN");
        return;
      }

      if (response.contains("ERR.")) {
        completer.completeError(response.toString());
        return;
      }

      final dto = swingLogic.convertFromJson(response);
      dto.swingId = const Uuid().v5(Uuid.NAMESPACE_OID, dto.swingHeaderInfo.swingInfoId);
      dto.isExistVideo = false;
      dto.memo = null;
      dto.isFavorite = false;
      dto.swingVideoUrl = null;
      dto.userSwingInfos = <UserSwingInfoAppDto>[];

      completer.complete(dto);
    });

    return completer.future;
  }

  @override
  StreamSubscription readSwingHeaderInfoList(
    final String userId,
    final Function onStart,
    final void Function(SwingHeaderInfoAppDto) onData,
    final Function onFinish,
    final Function onError,
    final bool? cancelOnError,
  ) {
    return eventChannelDriver.receiveBroadcastStream(
      "M-TracerSDK.API/stream_readSwingHeaderInfoList",
      ["readSwingHeaderInfoList", userId],
      (final dynamic response) {
        if (response.toString().contains("ERR.")) {
          onError(response);
        } else if (response == "start") {
          onStart();
        } else if (response == "finish") {
          onFinish();
        } else {
          final dto = swingLogic.convertHeaderFromJson(response);
          onData(dto);
        }
      },
      onError: onError,
      cancelOnError: true,
    );
  }

  @override
  StreamSubscription receiveImpactEvent(
    final String userId,
    final Function onStart,
    final void Function(SwingEventInfoAppDto) onData,
    final Function onError,
    final bool cancelOnError,
  ) {
    return eventChannelDriver.receiveBroadcastStream(
      "M-TracerSDK.API/stream_receiveImpactEvent",
      ["receiveImpactEvent", userId],
      (final dynamic response) {
        if (response.contains("ERR.")) {
          onError(response);
        } else if (response == "start") {
          onStart();
        } else {
          final dto = SwingEventInfoAppDto();
          dto.impactId = response as String;

          onData(dto);
        }
      },
      onError: onError,
      cancelOnError: true,
    );
  }

  @override
  StreamSubscription receiveSwingInfoEvent(
    final String userId,
    final Function onStart,
    final void Function(SwingEventInfoAppDto) onData,
    final Function onError,
    final bool cancelOnError,
  ) {
    return eventChannelDriver.receiveBroadcastStream(
      "M-TracerSDK.API/stream_receiveSwingInfoEvent",
      ["receiveSwingInfoEvent", userId],
      (final dynamic response) {
        if (response.contains("ERR.")) {
          onError(response);
        } else if (response == "start") {
          onStart();
        } else {
          final entity = MTSwingEventDataEntity.fromMap(json.decode(response));
          final dto = SwingEventInfoAppDto();
          dto.impactId = entity.impactId;
          dto.isExist = entity.isExist;
          dto.index = entity.index;

          onData(dto);
        }
      },
      onError: onError,
      cancelOnError: true,
    );
  }

  @override
  StreamSubscription startScan(
    final Function onStart,
    final void Function(String) onData,
    final Function onError,
    final bool cancelOnError,
  ) {
    return eventChannelDriver.receiveBroadcastStream(
      "M-TracerSDK.API/stream_startScan",
      ["startScan"],
      (final dynamic response) {
        if (response.contains("ERR.")) {
          onError(response);
        } else if (response == "start") {
          onStart();
        } else {
          onData(response as String);
        }
      },
      onError: onError,
      cancelOnError: true,
    );
  }

  @override
  Future<bool> writeClubInfo(final String userId, final ClubInfoAppDto clubInfo) {
    final completer = Completer<bool>();

    List<String> json = [];
    json.add("{");

    json.add("\"clubId\": ");
    json.add("\"${clubInfo.clubId}\", ");

    json.add("\"clubLength\": ");
    json.add("${clubInfo.clubLength}, ");

    json.add("\"faceAngle\": ");
    json.add("${clubInfo.faceAngle}, ");

    json.add("\"lieAngle\": ");
    json.add("${clubInfo.lieAngle}, ");

    json.add("\"loftAngle\": ");
    json.add("${clubInfo.loftAngle}, ");

    json.add("\"head_maker_name\": \"\", ");

    json.add("\"head_model\": ");
    json.add("\"${clubInfo.headModel}\", ");

    json.add("\"shaftHardness\": ");
    switch (clubInfo.shaftHardness) {
      case ClubShaftHardnessType.l:
        json.add("0");
        break;
      case ClubShaftHardnessType.a:
        json.add("1");
        break;
      case ClubShaftHardnessType.r:
        json.add("2");
        break;
      case ClubShaftHardnessType.sr:
        json.add("3");
        break;
      case ClubShaftHardnessType.s:
        json.add("4");
        break;
      case ClubShaftHardnessType.x:
        json.add("5");
        break;
      case ClubShaftHardnessType.xx:
        json.add("6");
        break;
      default:
        json.add("2");
    }

    json.add("}");

    methodChannelDriver.invokeMethod<String>("writeClubInfo", {"userId": userId, "JSON": json.join()}).then((final String response) {
      if (response.isEmpty) {
        completer.completeError("UNKOWN");
        return;
      }

      if (response.contains("ERR.")) {
        completer.completeError(response.toString());
        return;
      }

      completer.complete(true);
    });
    return completer.future;
  }

  @override
  Future<bool> writeProfileInfo(final String userId, final ProfileInfoAppDto profileInfo) {
    final completer = Completer<bool>();

    List<String> json = [];
    json.add("{");

    //height
    json.add("\"height\":");
    json.add((profileInfo.height * 10).toInt().toString());
    json.add(",");

    //genderType
    json.add("\"genderType\":");
    switch (profileInfo.genderType) {
      case GenderType.other:
        json.add("9,");
        break;
      case GenderType.male:
        json.add("0,");
        break;
      case GenderType.female:
        json.add("1,");
        break;
      default:
        json.add("9,");
    }

    // birthYMD
    json.add("\"birthYear\":");
    json.add((profileInfo.birthdayYMD.year).toString());
    json.add(",");
    json.add("\"birthMonth\":");
    json.add((profileInfo.birthdayYMD.month).toString());
    json.add(",");
    json.add("\"birthDay\":");
    json.add((profileInfo.birthdayYMD.day).toString());

    json.add("}");

    methodChannelDriver.invokeMethod<String>("writeProfileInfo", {"userId": userId, "JSON": json.join()}).then((final String response) {
      if (response.isEmpty) {
        completer.completeError("UNKOWN");
        return;
      }

      if (response.contains("ERR.")) {
        completer.completeError(response.toString());
        return;
      }

      completer.complete(true);
    });

    return completer.future;
  }

  @override
  Future<void> writeUploadFlag(final String userId, final int index) {
    final completer = Completer<void>();

    methodChannelDriver.invokeMethod<String>("writeUploadFlag", {"userId": userId, "index": index}).then((final String response) {
      if (response.isEmpty) {
        completer.completeError("UNKOWN");
        return;
      }

      if (response.contains("ERR.")) {
        completer.completeError(response.toString());
        return;
      }

      completer.complete();
    });

    return completer.future;
  }
}
