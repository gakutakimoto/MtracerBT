import 'dart:async';
import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lzstring/lzstring.dart';
import 'package:mtracersdkexample/appdto/appinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/attachswingvideocondition_appdto.dart';
import 'package:mtracersdkexample/appdto/clubcategorytype.dart';
import 'package:mtracersdkexample/appdto/deletepaintcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/deleteswingcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/dominanthand_type.dart';
import 'package:mtracersdkexample/appdto/gender_type.dart';
import 'package:mtracersdkexample/appdto/getappcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/getswingcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/getswingheadercondition_appdto.dart';
import 'package:mtracersdkexample/appdto/getswingnextcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/getswingprevcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/getusercondition_appdto.dart';
import 'package:mtracersdkexample/appdto/getuserlessoncondition_appdto.dart';
import 'package:mtracersdkexample/appdto/getuserpointcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/impactattackangle_type.dart';
import 'package:mtracersdkexample/appdto/impactclubpathtype_type.dart';
import 'package:mtracersdkexample/appdto/impactfaceangle_type.dart';
import 'package:mtracersdkexample/appdto/lessoninfo_appdto.dart';
import 'package:mtracersdkexample/appdto/newsinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/paintshapecircleinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/paintshapelineinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/point_type.dart';
import 'package:mtracersdkexample/appdto/registerpaintcircleinput_appdto.dart';
import 'package:mtracersdkexample/appdto/registerpaintlineinput_appdto.dart';
import 'package:mtracersdkexample/appdto/registerswinginput_appdto.dart';
import 'package:mtracersdkexample/appdto/registeruseractivateinput_appdto.dart';
import 'package:mtracersdkexample/appdto/roleinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/shopiteminfo_appdto.dart';
import 'package:mtracersdkexample/appdto/shoppinginfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swinginfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swinglistheaderindexesinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swinglistheaderinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingstatus_type.dart';
import 'package:mtracersdkexample/appdto/updatepaintcirclecondition_appdto.dart';
import 'package:mtracersdkexample/appdto/updatepaintcircleinput_appdto.dart';
import 'package:mtracersdkexample/appdto/updatepaintlinecondition_appdto.dart';
import 'package:mtracersdkexample/appdto/updatepaintlineinput_appdto.dart';
import 'package:mtracersdkexample/appdto/updateswingcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/updateswinginput_appdto.dart';
import 'package:mtracersdkexample/appdto/useractivateinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userbasicprofileinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/usergolferprofileinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userlessoninfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userpointinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userpointloginfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userstatus_type.dart';
import 'package:mtracersdkexample/appdto/userswinginfo_appdto.dart';
import 'package:mtracersdkexample/appdto/withdrawalreason_type.dart';
import 'package:mtracersdkexample/appdto/withdrawusercondition_appdto.dart';
import 'package:mtracersdkexample/appdto/withdrawuserinput_appdto.dart';
import 'package:mtracersdkexample/driver/awsappsync_driver.dart';
import 'package:mtracersdkexample/driverinterface/cloudapi_driverinterface.dart';
import 'package:mtracersdkexample/entity/appdata_entity.dart';
import 'package:mtracersdkexample/entity/swingdata_entity.dart';
import 'package:mtracersdkexample/entity/swingheaderdata_entity.dart';
import 'package:mtracersdkexample/entity/useractivatedata_entity.dart';
import 'package:mtracersdkexample/entity/userdata_entity.dart';
import 'package:mtracersdkexample/entity/userpointdata_entity.dart';
import 'package:mtracersdkexample/entity/userpointlogdata_entity.dart';
import 'package:mtracersdkexample/gateway/parameter_gateway.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudapi_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/parameter_gatewayinterface.dart';
import 'package:mtracersdkexample/logic/club_logic.dart';
import 'package:mtracersdkexample/logic/stringcodec_logic.dart';
import 'package:mtracersdkexample/logic/swing_logic.dart';
import 'package:mtracersdkexample/logicinterface/club_logicinterface.dart';
import 'package:mtracersdkexample/logicinterface/stringcodec_logicinterface.dart';
import 'package:mtracersdkexample/logicinterface/swing_logicinterface.dart';

class AWSAppSyncGateway extends CloudAPIGatewayInterface {
  late CloudAPIDriverInterface cloudAPIDriver;
  late SwingLogicInterface swingLogic;
  late ParameterGatewayInterface parameterGateway;
  late StringCodecLogicInterface stringCodecLogic;
  late ClubLogicInterface clubLogic;

  AWSAppSyncGateway() {
    cloudAPIDriver = AWSAppSyncDriver();
    swingLogic = SwingLogic();
    parameterGateway = ParameterGateway();
    stringCodecLogic = StringCodecLogic();
    clubLogic = ClubLogic();
  }

  @override
  void configure() {}

  @override
  Future<SwingInfoAppDto?> attachSwingVideo(final String endpoint, final String accessToken, final AttachSwingVideoConditionAppDto condition) {
    final completer = Completer<SwingInfoAppDto?>();

    const operationName = "attachSwingVideo";

    final query = <String>[];
    query.add("mutation $operationName { ");
    query.add("$operationName(condition: { ");
    query.add("swingInfoId: \"${condition.swingInfoId}\", ");
    query.add("}, ){ ");
    query.add("swingId, ");
    query.add("rawData, ");
    query.add("}, ");
    query.add("}");

    cloudAPIDriver.request(Uri.parse(endpoint), operationName, query.join(), accessToken).then((final http.Response response) {
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        if (body.containsKey("errors")) {
          completer.completeError(Exception([
            {"statusCode": response.statusCode},
            {"errors": body["errors"]},
          ]));
        } else {
          final Map<String, dynamic> data = json.decode(response.body)["data"] as Map<String, dynamic>;
          if (data[operationName].toString().compareTo("null") == 0) {
            completer.complete(null);
          } else {
            try {
              //RawEntity to Entity
              final Map<String, dynamic> rawEntity = json.decode(response.body)["data"][operationName];
              final entity = SwingDataEntity.fromMap(rawEntity);

              //Entity to Dto
              final swingInfo = SwingInfoAppDto();
              //tbd
              swingInfo.swingId = entity.swingId;
              swingInfo.raw = entity.rawData;

              completer.complete(swingInfo);
            } catch (e) {
              completer.completeError(e);
            }
          }
        }
      } else {
        completer.completeError(response.statusCode);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<List<SwingListHeaderInfoAppDto>?> deleteSwing(final String endpoint, final String accessToken, final DeleteSwingConditionAppDto condition) {
    final completer = Completer<List<SwingListHeaderInfoAppDto>?>();

    const operationName = "deleteSwing";

    final query = <String>[];
    query.add("mutation $operationName { ");
    query.add("$operationName(condition: { ");
    query.add("swingId: [");
    for (final swingId in condition.swingIds) {
      query.add("\"$swingId\", ");
    }
    query.add("], ");
    query.add("}, ) { ");
    query.add("swingId,");
    query.add("swingStatusId,");
    query.add("swingStatusName,");
    query.add("isExistVideo,");
    query.add("isFavorite,");
    query.add("memo,");
    query.add("},");
    query.add("}");

    cloudAPIDriver.request(Uri.parse(endpoint), operationName, query.join(), accessToken).then((final http.Response response) {
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        if (body.containsKey("errors")) {
          completer.completeError(Exception([
            {"statusCode": response.statusCode},
            {"errors": body["errors"]},
          ]));
        } else {
          final Map<String, dynamic> data = json.decode(response.body)["data"] as Map<String, dynamic>;
          if (data[operationName].toString().compareTo("null") == 0) {
            completer.complete(null);
          } else {
            try {
              //RawEntity to Entity
              final List<dynamic> rawEntities = json.decode(response.body)["data"][operationName];

              //Entity to Dto
              final swingListHeaderInfos = <SwingListHeaderInfoAppDto>[];
              for (final rawEntity in rawEntities) {
                final entity = SwingHeaderDataEntity.fromMap(rawEntity);
                final swingListHeaderInfo = SwingListHeaderInfoAppDto();

                swingListHeaderInfo.swingId = entity.swingId;
                switch (entity.swingStatusId) {
                  case "06fc1731-6d10-bbaf-cf1d-617f49a75b10":
                    swingListHeaderInfo.swingStatusType = SwingStatusType.enable;
                    break;
                  case "0e51a1cc-c47c-55db-e6d0-288fb7c3d197":
                    swingListHeaderInfo.swingStatusType = SwingStatusType.disable;
                    break;
                  default:
                    swingListHeaderInfo.swingStatusType = SwingStatusType.disable;
                }
                swingListHeaderInfo.isExistVideo = (entity.isExistVideo == 1) ? true : false;
                swingListHeaderInfo.isFavorite = (entity.isFavorite == 1) ? true : false;
                swingListHeaderInfo.memo = entity.memo;

                swingListHeaderInfos.add(swingListHeaderInfo);
              }

              completer.complete(swingListHeaderInfos);
            } catch (e) {
              completer.completeError(e);
            }
          }
        }
      } else {
        completer.completeError(response.statusCode);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<AppInfoAppDto?> getApp(final String endpoint, final String accessToken, final GetAppConditionAppDto condition) {
    final completer = Completer<AppInfoAppDto?>();

    const operationName = "getApp";

    final query = <String>[];
    query.add("query $operationName { ");
    query.add("$operationName(condition: { ");
    query.add("version: \"${condition.version}\", ");
    query.add("}, ) { ");
    query.add("version, ");
    query.add("isAccepted, ");
    query.add("}, ");
    query.add("}");

    cloudAPIDriver.request(Uri.parse(endpoint), operationName, query.join(), accessToken).then((final http.Response response) {
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        if (body.containsKey("errors")) {
          completer.completeError(Exception([
            {"statusCode": response.statusCode},
            {"errors": body["errors"]},
          ]));
        } else {
          final Map<String, dynamic> data = json.decode(response.body)["data"] as Map<String, dynamic>;
          if (data[operationName].toString().compareTo("null") == 0) {
            completer.complete(null);
          } else {
            try {
              //RawEntity to Entity
              final Map<String, dynamic> rawEntity = json.decode(response.body)["data"][operationName];
              final entity = AppDataEntity.fromMap(rawEntity);

              //Entity to Dto
              final dto = AppInfoAppDto();
              dto.version = entity.version;
              dto.isAccept = (entity.isAccepted == 1) ? true : false;

              completer.complete(dto);
            } catch (e) {
              completer.completeError(e);
            }
          }
        }
      } else {
        completer.completeError(response.statusCode);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<List<NewsInfoAppDto>> getNews(final String endpoint, final String accessToken, final String userId) {
    final completer = Completer<List<NewsInfoAppDto>>();

    //tbd :テストデータ
    List<NewsInfoAppDto> test = [];
    NewsInfoAppDto newsInfo = NewsInfoAppDto();
    newsInfo.title = "〇〇キャンペーン開始";
    newsInfo.news = "第1回エムトレキャンペーンが始まります。お申し込みの方は〇〇までどうぞ。";
    newsInfo.isRead = false;
    newsInfo.category = "キャンペーン";
    test.add(newsInfo);

    NewsInfoAppDto newsInfo2 = NewsInfoAppDto();
    newsInfo2.title = "〇〇キャンペーン開始";
    newsInfo2.news = "第2回エムトレキャンペーンが始まります。お申し込みの方は〇〇までどうぞ。";
    newsInfo2.isRead = true;
    newsInfo2.category = "キャンペーン";
    test.add(newsInfo2);

    completer.complete(test);
    return completer.future;
  }

  @override
  Future<List<SwingListHeaderInfoAppDto>?> getSwingHeader(final String endpoint, final String accessToken, final GetSwingHeaderConditionAppDto condition) {
    final completer = Completer<List<SwingListHeaderInfoAppDto>?>();

    const operationName = "getSwingHeader";

    final query = <String>[];
    query.add("query $operationName { ");
    query.add("$operationName(condition: { ");
    query.add("userId: \"${condition.userId}\", ");
    query.add("swingDateFrom: \"${condition.swingDateFrom}\", ");
    query.add("swingDateTo: \"${condition.swingDateTo}\", ");
    query.add("}, ) { ");
    query.add("swingId, ");
    query.add("swingStatusId, ");
    query.add("swingStatusName, ");
    query.add("isExistVideo, ");
    query.add("isFavorite, ");
    query.add("memo, ");
    query.add("indexes { ");
    query.add("swingInfoId, ");
    query.add("swingDate, ");
    query.add("golfClubSubId, ");
    query.add("impactHeadSpeed, ");
    query.add("estimateCarry, ");
    query.add("impactFaceAngle, ");
    query.add("impactAttackAngle, ");
    query.add("impactAttackAngleType, ");
    query.add("impactFaceAngleType, ");
    query.add("impactClubPath, ");
    query.add("impactClubPathType, ");
    query.add("}, ");
    query.add("}, ");
    query.add("}");

    cloudAPIDriver.request(Uri.parse(endpoint), operationName, query.join(), accessToken).then((final http.Response response) {
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        if (body.containsKey("errors")) {
          completer.completeError(Exception([
            {"statusCode": response.statusCode},
            {"errors": body["errors"]},
          ]));
        } else {
          final Map<String, dynamic> data = json.decode(response.body)["data"] as Map<String, dynamic>;
          if (data[operationName].toString().compareTo("null") == 0) {
            completer.complete(null);
          } else {
            try {
              //RawEntity to Entity
              final List<dynamic> rawEntities = json.decode(response.body)["data"][operationName];

              //Entity to Dto
              final swingListHeaderInfos = <SwingListHeaderInfoAppDto>[];
              for (final rawEntity in rawEntities) {
                final entity = SwingHeaderDataEntity.fromMap(rawEntity);
                final swingListHeaderInfo = SwingListHeaderInfoAppDto();

                swingListHeaderInfo.swingId = entity.swingId;
                switch (entity.swingStatusId) {
                  case "06fc1731-6d10-bbaf-cf1d-617f49a75b10":
                    swingListHeaderInfo.swingStatusType = SwingStatusType.enable;
                    break;
                  case "0e51a1cc-c47c-55db-e6d0-288fb7c3d197":
                    swingListHeaderInfo.swingStatusType = SwingStatusType.disable;
                    break;
                  default:
                    swingListHeaderInfo.swingStatusType = SwingStatusType.disable;
                }
                swingListHeaderInfo.isExistVideo = (entity.isExistVideo == 1) ? true : false;
                swingListHeaderInfo.isFavorite = (entity.isFavorite == 1) ? true : false;
                swingListHeaderInfo.memo = entity.memo;

                //
                swingListHeaderInfo.swingListHeaderIndexesInfo = SwingListHeaderIndexesInfoAppDto();
                swingListHeaderInfo.swingListHeaderIndexesInfo.swingInfoId = entity.swingHeaderIndexesData.swingInfoId;
                final swingDateLocal = DateTime.parse(entity.swingHeaderIndexesData.swingDate);
                final swingDateUtc = DateTime.utc(swingDateLocal.year, swingDateLocal.month, swingDateLocal.day, swingDateLocal.hour, swingDateLocal.minute, swingDateLocal.second);
                swingListHeaderInfo.swingListHeaderIndexesInfo.swingDate = swingDateUtc;
                swingListHeaderInfo.swingListHeaderIndexesInfo.golfClubSubId = entity.swingHeaderIndexesData.golfClubSubId;
                swingListHeaderInfo.swingListHeaderIndexesInfo.clubNoType = clubLogic.getClubNoType(entity.swingHeaderIndexesData.golfClubSubId);
                swingListHeaderInfo.swingListHeaderIndexesInfo.clubCategoryType = clubLogic.getClubCategoryType(entity.swingHeaderIndexesData.golfClubSubId);
                swingListHeaderInfo.swingListHeaderIndexesInfo.impactHeadSpeed = entity.swingHeaderIndexesData.impactHeadSpeed;
                swingListHeaderInfo.swingListHeaderIndexesInfo.estimateCarry = entity.swingHeaderIndexesData.estimateCarry;
                swingListHeaderInfo.swingListHeaderIndexesInfo.impactAttackAngle = entity.swingHeaderIndexesData.impactAttackAngle;
                switch (entity.swingHeaderIndexesData.impactAttackAngleType) {
                  case 0:
                    swingListHeaderInfo.swingListHeaderIndexesInfo.impactAttackAngleType = ImpactAttackAngleType.upper;
                    break;
                  case 1:
                    swingListHeaderInfo.swingListHeaderIndexesInfo.impactAttackAngleType = ImpactAttackAngleType.level;
                    break;
                  case 2:
                    swingListHeaderInfo.swingListHeaderIndexesInfo.impactAttackAngleType = ImpactAttackAngleType.down;
                    break;
                  default:
                    swingListHeaderInfo.swingListHeaderIndexesInfo.impactAttackAngleType = ImpactAttackAngleType.other;
                }
                swingListHeaderInfo.swingListHeaderIndexesInfo.impactClubPath = entity.swingHeaderIndexesData.impactClubPath;
                switch (entity.swingHeaderIndexesData.impactClubPathType) {
                  case 0:
                    swingListHeaderInfo.swingListHeaderIndexesInfo.impactClubPathType = ImpactClubPathType.inout;
                    break;
                  case 1:
                    swingListHeaderInfo.swingListHeaderIndexesInfo.impactClubPathType = ImpactClubPathType.inin;
                    break;
                  case 2:
                    swingListHeaderInfo.swingListHeaderIndexesInfo.impactClubPathType = ImpactClubPathType.outin;
                    break;
                  default:
                    swingListHeaderInfo.swingListHeaderIndexesInfo.impactClubPathType = ImpactClubPathType.other;
                }
                swingListHeaderInfo.swingListHeaderIndexesInfo.impactFaceAngle = entity.swingHeaderIndexesData.impactFaceAngle;
                switch (entity.swingHeaderIndexesData.impactFaceAngleType) {
                  case 0:
                    swingListHeaderInfo.swingListHeaderIndexesInfo.impactFaceAngleType = ImpactFaceAngleType.open;
                    break;
                  case 1:
                    swingListHeaderInfo.swingListHeaderIndexesInfo.impactFaceAngleType = ImpactFaceAngleType.square;
                    break;
                  case 2:
                    swingListHeaderInfo.swingListHeaderIndexesInfo.impactFaceAngleType = ImpactFaceAngleType.close;
                    break;
                  default:
                    swingListHeaderInfo.swingListHeaderIndexesInfo.impactFaceAngleType = ImpactFaceAngleType.other;
                }

                swingListHeaderInfos.add(swingListHeaderInfo);
              }

              completer.complete(swingListHeaderInfos);
            } catch (e) {
              completer.completeError(e);
            }
          }
        }
      } else {
        completer.completeError(response.statusCode);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<SwingInfoAppDto?> getSwing(final String endpoint, final String accessToken, final GetSwingConditionAppDto condition) {
    final completer = Completer<SwingInfoAppDto?>();

    const operationName = "getSwing";

    final query = <String>[];
    query.add("query $operationName {");
    query.add("$operationName(condition: {, ");
    query.add("userId: \"${condition.userId}\", ");
    query.add("swingId: \"${condition.swingId}\", ");
    query.add("}, ) { ");
    query.add("swingId,");
    query.add("swingStatusId,");
    query.add("swingStatusName,");
    query.add("isExistVideo,");
    query.add("isFavorite,");
    query.add("memo,");
    query.add("swingVideoUrl,");
    query.add("rawData,");
    query.add("users {");
    query.add("userId,");
    query.add("swingId,");
    query.add("ownerId,");
    query.add("paints {");
    query.add("userId,");
    query.add("swingId,");
    query.add("paintId,");
    query.add("displayOrder,");
    query.add("paintStatusId,");
    query.add("paintStatusName,");
    query.add("shapeType,");
    query.add("lineStartX,");
    query.add("lineStartY,");
    query.add("lineEndX,");
    query.add("lineEndY,");
    query.add("lineColor,");
    query.add("circleCenterX,");
    query.add("circleCenterY,");
    query.add("circleColor,");
    query.add("circleRadius,");
    query.add("},");
    query.add("},");
    query.add("},");
    query.add("}");

    cloudAPIDriver.request(Uri.parse(endpoint), operationName, query.join(), accessToken).then((final http.Response response) async {
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        if (body.containsKey("errors")) {
          completer.completeError(Exception([
            {"statusCode": response.statusCode},
            {"errors": body["errors"]},
          ]));
        } else {
          final Map<String, dynamic> data = json.decode(response.body)["data"] as Map<String, dynamic>;
          if (data[operationName].toString().compareTo("null") == 0) {
            completer.complete(null);
          } else {
            try {
              //RawEntity to Entity
              final Map<String, dynamic> rawEntity = json.decode(response.body)["data"][operationName];
              final entity = SwingDataEntity.fromMap(rawEntity);

              try {
                //Entity to Dto
                final encryptValue = LZString.decompressFromBase64Sync(entity.rawData);
                if (encryptValue == null) {
                  throw Exception();
                }
                final systemParameterInfo = await parameterGateway.readSystemParameterInfo();
                final decryptKey = stringCodecLogic.decode(systemParameterInfo.decryptCBCKey);
                final decryptIv = stringCodecLogic.decode(systemParameterInfo.decryptCBCIv);
                final rawJson = stringCodecLogic.decrypt(decryptKey, decryptIv, encryptValue, mode: AESMode.cbc);
                final swingInfo = swingLogic.convertFromJson(rawJson);

                swingInfo.swingId = entity.swingId;
                swingInfo.isExistVideo = (entity.isExistVideo == 1) ? true : false;
                swingInfo.memo = entity.memo;
                swingInfo.isFavorite = (entity.isFavorite == 1) ? true : false;
                swingInfo.swingVideoUrl = entity.swingVideoUrl;

                swingInfo.userSwingInfos = <UserSwingInfoAppDto>[];
                for (final entity in entity.userSwingDatas) {
                  final userSwingInfo = UserSwingInfoAppDto();
                  userSwingInfo.userId = entity.userId;
                  userSwingInfo.swingId = entity.swingId;
                  userSwingInfo.ownerId = entity.ownerId;
                  late var shapeDto;
                  for (final paintEntity in entity.userSwingPaintDatas) {
                    switch (paintEntity.shapeType) {
                      case 0:
                        shapeDto = PaintShapeCircleInfoAppDto();
                        shapeDto.userId = paintEntity.userId;
                        shapeDto.ownerId = entity.ownerId;
                        shapeDto.swingId = paintEntity.swingId;
                        shapeDto.paintId = paintEntity.paintId;
                        shapeDto.displayOrder = paintEntity.displayOrder;

                        shapeDto.isValid = true;
                        shapeDto.isDeleted = false;
                        shapeDto.isRegistered = false;
                        shapeDto.isUpdated = false;
                        shapeDto.center = Offset(paintEntity.paintCircleData!.centerX, paintEntity.paintCircleData!.centerY);
                        shapeDto.radius = paintEntity.paintCircleData!.radius;
                        shapeDto.color = int.parse(paintEntity.paintCircleData!.color, radix: 16);
                        break;

                      case 1:
                        shapeDto = PaintShapeLineInfoAppDto();
                        shapeDto.userId = paintEntity.userId;
                        shapeDto.ownerId = entity.ownerId;
                        shapeDto.swingId = paintEntity.swingId;
                        shapeDto.paintId = paintEntity.paintId;
                        shapeDto.displayOrder = paintEntity.displayOrder;

                        shapeDto.isValid = true;
                        shapeDto.isDeleted = false;
                        shapeDto.isRegistered = false;
                        shapeDto.isUpdated = false;
                        shapeDto.start = Offset(paintEntity.paintLineData!.startX, paintEntity.paintLineData!.startY);
                        shapeDto.end = Offset(paintEntity.paintLineData!.endX, paintEntity.paintLineData!.endY);
                        shapeDto.color = int.parse(paintEntity.paintLineData!.color, radix: 16);
                        break;
                      default:
                        break;
                    }

                    userSwingInfo.paintShapeInfos.add(shapeDto);
                  }
                  swingInfo.userSwingInfos.add(userSwingInfo);
                }

                completer.complete(swingInfo);
              } catch (e) {
                completer.complete(null);
              }
            } catch (e) {
              completer.completeError(e);
            }
          }
        }
      } else {
        completer.completeError(response.statusCode);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<SwingInfoAppDto?> getSwingNext(final String endpoint, final String accessToken, final GetSwingNextConditionAppDto condition) {
    final completer = Completer<SwingInfoAppDto?>();

    const operationName = "getSwingNext";

    final query = <String>[];
    query.add("query $operationName { ");
    query.add("$operationName(condition: {, ");
    query.add("userId: \"${condition.userId}\", ");
    query.add("swingDate: \"${condition.swingDate}\", ");
    query.add("}, ) { ");
    query.add("swingId,");
    query.add("swingStatusId,");
    query.add("swingStatusName,");
    query.add("isExistVideo,");
    query.add("isFavorite,");
    query.add("memo,");
    query.add("swingVideoUrl,");
    query.add("rawData,");
    query.add("users {");
    query.add("userId,");
    query.add("swingId,");
    query.add("ownerId,");
    query.add("paints {");
    query.add("userId,");
    query.add("swingId,");
    query.add("paintId,");
    query.add("displayOrder,");
    query.add("paintStatusId,");
    query.add("paintStatusName,");
    query.add("shapeType,");
    query.add("lineStartX,");
    query.add("lineStartY,");
    query.add("lineEndX,");
    query.add("lineEndY,");
    query.add("lineColor,");
    query.add("circleCenterX,");
    query.add("circleCenterY,");
    query.add("circleColor,");
    query.add("circleRadius,");
    query.add("},");
    query.add("},");
    query.add("},");
    query.add("}");

    cloudAPIDriver.request(Uri.parse(endpoint), operationName, query.join(), accessToken).then((final http.Response response) async {
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        if (body.containsKey("errors")) {
          completer.completeError(Exception([
            {"statusCode": response.statusCode},
            {"errors": body["errors"]},
          ]));
        } else {
          final Map<String, dynamic> data = json.decode(response.body)["data"] as Map<String, dynamic>;
          if (data[operationName].toString().compareTo("null") == 0) {
            completer.complete(null);
          } else {
            try {
              //RawEntity to Entity
              final Map<String, dynamic> rawEntity = json.decode(response.body)["data"][operationName];
              final entity = SwingDataEntity.fromMap(rawEntity);

              try {
                //Entity to Dto
                final encryptValue = LZString.decompressFromBase64Sync(entity.rawData);
                if (encryptValue == null) {
                  throw Exception();
                }
                final systemParameterInfo = await parameterGateway.readSystemParameterInfo();
                final decryptKey = stringCodecLogic.decode(systemParameterInfo.decryptCBCKey);
                final decryptIv = stringCodecLogic.decode(systemParameterInfo.decryptCBCIv);
                final rawJson = stringCodecLogic.decrypt(decryptKey, decryptIv, encryptValue, mode: AESMode.cbc);
                final swingInfo = swingLogic.convertFromJson(rawJson);

                swingInfo.swingId = entity.swingId;
                swingInfo.isExistVideo = (entity.isExistVideo == 1) ? true : false;
                swingInfo.memo = entity.memo;
                swingInfo.isFavorite = (entity.isFavorite == 1) ? true : false;
                swingInfo.swingVideoUrl = entity.swingVideoUrl;

                swingInfo.userSwingInfos = <UserSwingInfoAppDto>[];
                for (final entity in entity.userSwingDatas) {
                  final userSwingInfo = UserSwingInfoAppDto();
                  userSwingInfo.userId = entity.userId;
                  userSwingInfo.swingId = entity.swingId;
                  userSwingInfo.ownerId = entity.ownerId;

                  late var shapeDto;
                  for (final paintEntity in entity.userSwingPaintDatas) {
                    switch (paintEntity.shapeType) {
                      case 0:
                        shapeDto = PaintShapeCircleInfoAppDto();
                        shapeDto.userId = paintEntity.userId;
                        shapeDto.ownerId = entity.ownerId;
                        shapeDto.swingId = paintEntity.swingId;
                        shapeDto.paintId = paintEntity.paintId;
                        shapeDto.displayOrder = paintEntity.displayOrder;

                        shapeDto.isValid = true;
                        shapeDto.isDeleted = false;
                        shapeDto.isRegistered = false;
                        shapeDto.isUpdated = false;
                        shapeDto.center = Offset(paintEntity.paintCircleData!.centerX, paintEntity.paintCircleData!.centerY);
                        shapeDto.radius = paintEntity.paintCircleData!.radius;
                        shapeDto.color = int.parse(paintEntity.paintCircleData!.color, radix: 16);
                        break;

                      case 1:
                        shapeDto = PaintShapeLineInfoAppDto();
                        shapeDto.userId = paintEntity.userId;
                        shapeDto.ownerId = entity.ownerId;
                        shapeDto.swingId = paintEntity.swingId;
                        shapeDto.paintId = paintEntity.paintId;
                        shapeDto.displayOrder = paintEntity.displayOrder;

                        shapeDto.isValid = true;
                        shapeDto.isDeleted = false;
                        shapeDto.isRegistered = false;
                        shapeDto.isUpdated = false;
                        shapeDto.start = Offset(paintEntity.paintLineData!.startX, paintEntity.paintLineData!.startY);
                        shapeDto.end = Offset(paintEntity.paintLineData!.endX, paintEntity.paintLineData!.endY);
                        shapeDto.color = int.parse(paintEntity.paintLineData!.color, radix: 16);
                        break;
                      default:
                        break;
                    }

                    userSwingInfo.paintShapeInfos.add(shapeDto);
                  }

                  swingInfo.userSwingInfos.add(userSwingInfo);
                }

                completer.complete(swingInfo);
              } catch (e) {
                completer.complete(null);
              }
            } catch (e) {
              completer.completeError(e);
            }
          }
        }
      } else {
        completer.completeError(response.statusCode);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<SwingInfoAppDto?> getSwingPrev(final String endpoint, final String accessToken, final GetSwingPrevConditionAppDto condition) {
    final completer = Completer<SwingInfoAppDto?>();

    const operationName = "getSwingPrev";

    final query = <String>[];
    query.add("query $operationName {");
    query.add("$operationName(condition: { ");
    query.add("userId: \"${condition.userId}\", ");
    query.add("swingDate: \"${condition.swingDate}\", ");
    query.add("}, ) { ");
    query.add("swingId,");
    query.add("swingStatusId,");
    query.add("swingStatusName,");
    query.add("isExistVideo,");
    query.add("isFavorite,");
    query.add("memo,");
    query.add("rawData,");
    query.add("swingVideoUrl,");
    query.add("users {");
    query.add("userId,");
    query.add("swingId,");
    query.add("ownerId,");
    query.add("paints {");
    query.add("userId,");
    query.add("swingId,");
    query.add("paintId,");
    query.add("displayOrder,");
    query.add("paintStatusId,");
    query.add("paintStatusName,");
    query.add("shapeType,");
    query.add("lineStartX,");
    query.add("lineStartY,");
    query.add("lineEndX,");
    query.add("lineEndY,");
    query.add("lineColor,");
    query.add("circleCenterX,");
    query.add("circleCenterY,");
    query.add("circleColor,");
    query.add("circleRadius,");
    query.add("},");
    query.add("},");
    query.add("},");
    query.add("}");

    cloudAPIDriver.request(Uri.parse(endpoint), operationName, query.join(), accessToken).then((final http.Response response) async {
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        if (body.containsKey("errors")) {
          completer.completeError(Exception([
            {"statusCode": response.statusCode},
            {"errors": body["errors"]},
          ]));
        } else {
          final Map<String, dynamic> data = json.decode(response.body)["data"] as Map<String, dynamic>;
          if (data[operationName].toString().compareTo("null") == 0) {
            completer.complete(null);
          } else {
            try {
              //RawEntity to Entity
              final Map<String, dynamic> rawEntity = json.decode(response.body)["data"][operationName];
              final entity = SwingDataEntity.fromMap(rawEntity);

              try {
                //Entity to Dto
                final encryptValue = LZString.decompressFromBase64Sync(entity.rawData);
                if (encryptValue == null) {
                  throw Exception();
                }
                final systemParameterInfo = await parameterGateway.readSystemParameterInfo();
                final decryptKey = stringCodecLogic.decode(systemParameterInfo.decryptCBCKey);
                final decryptIv = stringCodecLogic.decode(systemParameterInfo.decryptCBCIv);
                final rawJson = stringCodecLogic.decrypt(decryptKey, decryptIv, encryptValue, mode: AESMode.cbc);
                final swingInfo = swingLogic.convertFromJson(rawJson);

                swingInfo.swingId = entity.swingId;
                swingInfo.isExistVideo = (entity.isExistVideo == 1) ? true : false;
                swingInfo.memo = entity.memo;
                swingInfo.isFavorite = (entity.isFavorite == 1) ? true : false;
                swingInfo.swingVideoUrl = entity.swingVideoUrl;

                swingInfo.userSwingInfos = <UserSwingInfoAppDto>[];
                for (final entity in entity.userSwingDatas) {
                  final userSwingInfo = UserSwingInfoAppDto();
                  userSwingInfo.userId = entity.userId;
                  userSwingInfo.swingId = entity.swingId;
                  userSwingInfo.ownerId = entity.ownerId;

                  late var shapeDto;
                  for (final paintEntity in entity.userSwingPaintDatas) {
                    switch (paintEntity.shapeType) {
                      case 0:
                        shapeDto = PaintShapeCircleInfoAppDto();
                        shapeDto.userId = paintEntity.userId;
                        shapeDto.ownerId = entity.ownerId;
                        shapeDto.swingId = paintEntity.swingId;
                        shapeDto.paintId = paintEntity.paintId;
                        shapeDto.displayOrder = paintEntity.displayOrder;

                        shapeDto.isValid = true;
                        shapeDto.isDeleted = false;
                        shapeDto.isRegistered = false;
                        shapeDto.isUpdated = false;
                        shapeDto.center = Offset(paintEntity.paintCircleData!.centerX, paintEntity.paintCircleData!.centerY);
                        shapeDto.radius = paintEntity.paintCircleData!.radius;
                        shapeDto.color = int.parse(paintEntity.paintCircleData!.color, radix: 16);
                        break;

                      case 1:
                        shapeDto = PaintShapeLineInfoAppDto();
                        shapeDto.userId = paintEntity.userId;
                        shapeDto.ownerId = entity.ownerId;
                        shapeDto.swingId = paintEntity.swingId;
                        shapeDto.paintId = paintEntity.paintId;
                        shapeDto.displayOrder = paintEntity.displayOrder;

                        shapeDto.isValid = true;
                        shapeDto.isDeleted = false;
                        shapeDto.isRegistered = false;
                        shapeDto.isUpdated = false;
                        shapeDto.start = Offset(paintEntity.paintLineData!.startX, paintEntity.paintLineData!.startY);
                        shapeDto.end = Offset(paintEntity.paintLineData!.endX, paintEntity.paintLineData!.endY);
                        shapeDto.color = int.parse(paintEntity.paintLineData!.color, radix: 16);
                        break;
                      default:
                        break;
                    }

                    userSwingInfo.paintShapeInfos.add(shapeDto);
                  }

                  swingInfo.userSwingInfos.add(userSwingInfo);
                }

                completer.complete(swingInfo);
              } catch (e) {
                completer.complete(null);
              }
            } catch (e) {
              completer.completeError(e);
            }
          }
        }
      } else {
        completer.completeError(response.statusCode);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<UserInfoAppDto?> getUser(final String endpoint, final String accessToken, final GetUserConditionAppDto condition) {
    final completer = Completer<UserInfoAppDto?>();

    const operationName = "getUser";

    final query = <String>[];
    query.add("query $operationName { ");
    query.add("$operationName(condition: { ");
    query.add("userSub: \"${condition.userSub}\", ");
    query.add("}, ) { ");
    query.add("userId, ");
    query.add("userStatusId, ");
    query.add("userStatusName, ");
    query.add("userRoles { ");
    query.add("roleId, ");
    query.add("roleName, ");
    query.add("}, ");
    query.add("userBasicProfile { ");
    query.add("avatarPath, ");
    query.add("nickName, ");
    query.add("firstName, ");
    query.add("lastName, ");
    query.add("firstNameKana, ");
    query.add("lastNameKana, ");
    query.add("birthday, ");
    query.add("genderType, ");
    query.add("height, ");
    query.add("weight, ");
    query.add("}, ");
    query.add("userGolferProfile { ");
    query.add("startAt, ");
    query.add("dominantHand, ");
    query.add("scoreAVG, ");
    query.add("gloveSize, ");
    query.add("roundPlayFrequency, ");
    query.add("exerciseFrequency, ");
    query.add("worry, ");
    query.add("worryMemo, ");
    query.add("}, ");
    query.add("}, ");
    query.add("}");

    cloudAPIDriver.request(Uri.parse(endpoint), operationName, query.join(), accessToken).then((final http.Response response) {
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        if (body.containsKey("errors")) {
          completer.completeError(Exception([
            {"statusCode": response.statusCode},
            {"errors": body["errors"]},
          ]));
        } else {
          final Map<String, dynamic> data = json.decode(response.body)["data"] as Map<String, dynamic>;
          if (data[operationName].toString().compareTo("null") == 0) {
            completer.complete(null);
          } else {
            try {
              //RawEntity to Entity
              final Map<String, dynamic> rawEntity = json.decode(response.body)["data"][operationName];
              final entity = UserDataEntity.fromMap(rawEntity);

              //Entity to Dto
              final userInfo = UserInfoAppDto();
              userInfo.userId = entity.userId;
              switch (entity.userStatusId) {
                case "30b5cbfb-356d-c7c4-f5a2-67cc816415be":
                  userInfo.userStatus = UserStatusType.active;
                  break;
                case "eabfe49b-1426-aaf9-9a3c-0a0dc0d35302":
                  userInfo.userStatus = UserStatusType.withdrawal;
                  break;
                default:
                  userInfo.userStatus = UserStatusType.unKnown;
              }

              //userBasicProfile
              userInfo.userBasicProfileInfo = UserBasicProfileInfoAppDto();
              userInfo.userBasicProfileInfo.avatarPath = entity.userBasicProfile.avatarPath;
              userInfo.userBasicProfileInfo.nickName = entity.userBasicProfile.nickName;
              userInfo.userBasicProfileInfo.firstName = entity.userBasicProfile.firstName;
              userInfo.userBasicProfileInfo.lastName = entity.userBasicProfile.lastName;
              userInfo.userBasicProfileInfo.firstNameKana = entity.userBasicProfile.firstNameKana;
              userInfo.userBasicProfileInfo.lastNameKana = entity.userBasicProfile.lastNameKana;
              if (entity.userBasicProfile.birthday != null) {
                final birthdayLocal = DateTime.parse(entity.userBasicProfile.birthday!);
                final birthdayUtc = DateTime.utc(birthdayLocal.year, birthdayLocal.month, birthdayLocal.day, 0, 0, 0);
                userInfo.userBasicProfileInfo.birthday = birthdayUtc;
              }
              switch (entity.userBasicProfile.genderType) {
                case 0:
                  userInfo.userBasicProfileInfo.genderType = GenderType.male;
                  break;
                case 1:
                  userInfo.userBasicProfileInfo.genderType = GenderType.female;
                  break;
                case 9:
                  userInfo.userBasicProfileInfo.genderType = GenderType.other;
                  break;
                default:
                  userInfo.userBasicProfileInfo.genderType = GenderType.other;
              }
              userInfo.userBasicProfileInfo.height = entity.userBasicProfile.height;
              userInfo.userBasicProfileInfo.weight = entity.userBasicProfile.weight;

              //userGolferProfile
              userInfo.userGolferProfileInfo = UserGolferProfileInfoAppDto();
              userInfo.userGolferProfileInfo.startAt = entity.userGolferProfile.startAt;
              switch (entity.userGolferProfile.dominantHandType) {
                case 0:
                  userInfo.userGolferProfileInfo.dominantHandType = DominantHandType.right;
                  break;
                case 1:
                  userInfo.userGolferProfileInfo.dominantHandType = DominantHandType.left;
                  break;
                default:
                  userInfo.userGolferProfileInfo.dominantHandType = DominantHandType.right;
              }
              userInfo.userGolferProfileInfo.scoreAVG = entity.userGolferProfile.scoreAVG;
              userInfo.userGolferProfileInfo.gloveSize = entity.userGolferProfile.gloveSize;
              userInfo.userGolferProfileInfo.roundPlayFrequency = entity.userGolferProfile.roundPlayFrequency;
              userInfo.userGolferProfileInfo.exerciseFrequency = entity.userGolferProfile.exerciseFrequency;
              userInfo.userGolferProfileInfo.worry = entity.userGolferProfile.worry;
              userInfo.userGolferProfileInfo.worryMemo = entity.userGolferProfile.worryMemo;

              //userRoles
              userInfo.userRoleInfos = <RoleInfoAppDto>[];
              for (final entity in entity.userRoleDatas) {
                final roleInfo = RoleInfoAppDto();
                roleInfo.roleId = entity.roleId;
                roleInfo.roleName = entity.roleName;
                userInfo.userRoleInfos.add(roleInfo);
              }

              completer.complete(userInfo);
            } catch (e) {
              completer.completeError(e);
            }
          }
        }
      } else {
        completer.completeError(response.statusCode);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<UserPointInfoAppDto?> getUserPoint(final String endpoint, final String accessToken, final GetUserPointConditionAppDto condition) {
    final completer = Completer<UserPointInfoAppDto?>();

    const operationName = "getUserPoint";

    final query = <String>[];
    query.add("query $operationName { ");
    query.add("$operationName(condition: { ");
    query.add("userId: \"${condition.userId}\", ");
    query.add("offset: ${condition.offset}, ");
    query.add("limit: ${condition.limit}, ");
    query.add("}, ) { ");
    query.add("userId, ");
    query.add("point, ");
    query.add("expiration, ");
    query.add("logCount, ");
    query.add("logs { ");
    query.add("userId, ");
    query.add("logId, ");
    query.add("point, ");
    query.add("at, ");
    query.add("pointRuleId, ");
    query.add("pointRuleName, ");
    query.add("pointTypeId, ");
    query.add("pointTypeName, ");
    query.add("}, ");
    query.add("}, ");
    query.add("}");

    cloudAPIDriver.request(Uri.parse(endpoint), operationName, query.join(), accessToken).then((final http.Response response) {
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        if (body.containsKey("errors")) {
          completer.completeError(Exception([
            {"statusCode": response.statusCode},
            {"errors": body["errors"]},
          ]));
        } else {
          final Map<String, dynamic> data = json.decode(response.body)["data"] as Map<String, dynamic>;
          if (data[operationName].toString().compareTo("null") == 0) {
            completer.complete(null);
          } else {
            try {
              //RawEntity to Entity
              final Map<String, dynamic> rawEntity = json.decode(response.body)["data"][operationName];
              final entity = UserPointDataEntity.fromMap(rawEntity);

              //Entity to Dto
              UserPointInfoAppDto dto = UserPointInfoAppDto();
              dto.userId = entity.userId;
              dto.totalPoint = entity.totalPoint;
              dto.expiration = DateTime.parse(entity.expiration);
              dto.logCount = entity.logCount;

              final userPointLogInfos = <UserPointLogInfoAppDto>[];
              for (final UserPointLogDataEntity pointData in entity.userPointLogDatas) {
                UserPointLogInfoAppDto pointLogInfo = UserPointLogInfoAppDto();
                pointLogInfo.userId = pointData.userId;

                pointLogInfo.point = pointData.point;
                pointLogInfo.logId = pointData.logId;

                final acquiredDateLocal = DateTime.parse(pointData.at);
                final acquiredDateUtc = DateTime.utc(acquiredDateLocal.year, acquiredDateLocal.month, acquiredDateLocal.day, acquiredDateLocal.hour, acquiredDateLocal.minute, acquiredDateLocal.second);
                pointLogInfo.acquiredDate = acquiredDateUtc;

                pointLogInfo.pointTypeId = pointData.pointTypeId;

                switch (pointData.pointTypeId) {
                  case "e2546501-d6fd-3df4-fc4b-2e3d72c546e9":
                    pointLogInfo.pointTypeName = "スイング計測";
                    pointLogInfo.pointType = PointType.swing;
                    break;
                  case "43f6b041-4bb7-6c6c-598b-21d4b07e1c15":
                    pointLogInfo.pointTypeName = "旧サービス移行";
                    pointLogInfo.pointType = PointType.migration;
                    break;
                  default:
                    pointLogInfo.pointTypeName = "その他";
                    pointLogInfo.pointType = PointType.etc;
                    break;
                }

                userPointLogInfos.add(pointLogInfo);
              }
              dto.userPointLogInfos = userPointLogInfos;
              completer.complete(dto);
            } catch (e) {
              completer.completeError(e);
            }
          }
        }
      } else {
        completer.completeError(response.statusCode);
      }
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  @override
  Future<SwingInfoAppDto?> registerSwing(final String endpoint, final String accessToken, final RegisterSwingInputAppDto input) {
    final completer = Completer<SwingInfoAppDto?>();

    const operationName = "registerSwing";

    final query = <String>[];
    query.add("mutation $operationName { ");
    query.add("$operationName(input: { ");
    query.add("userId: \"${input.userId}\", ");
    query.add("swingId: \"${input.swingId}\", ");
    query.add("isExistVideo: ${input.isExistVideo}, ");
    query.add("isFavorite: ${input.isFavorite}, ");
    query.add("memo: \"${input.memo}\", ");
    query.add("swingInfoId: \"${input.swingInfoId}\", ");
    query.add("swingDate: \"${input.swingDate}\", ");
    query.add("golfClubSubId: \"${input.golfClubSubId}\", ");
    query.add("impactHeadSpeed: ${input.impactHeadSpeed}, ");
    query.add("estimateCarry: ${input.estimateCarry}, ");
    query.add("impactAttackAngle: ${input.impactAttackAngle}, ");
    query.add("impactAttackAngleType: ${input.impactAttackAngleType}, ");
    query.add("impactClubPath: ${input.impactClubPath}, ");
    query.add("impactClubPathType: ${input.impactClubPathType}, ");
    query.add("impactFaceAngle: ${input.impactFaceAngle}, ");
    query.add("impactFaceAngleType: ${input.impactFaceAngleType}, ");
    query.add("rawData: \"${input.rawData}\", ");
    query.add("}, ) { ");
    query.add("swingId, ");
    query.add("}, ");
    query.add("}");

    cloudAPIDriver.request(Uri.parse(endpoint), operationName, query.join(), accessToken).then((final http.Response response) {
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        if (body.containsKey("errors")) {
          completer.completeError(Exception([
            {"statusCode": response.statusCode},
            {"errors": body["errors"]},
          ]));
        } else {
          final Map<String, dynamic> data = json.decode(response.body)["data"] as Map<String, dynamic>;
          if (data[operationName].toString().compareTo("null") == 0) {
            completer.complete(null);
          } else {
            try {
              //RawEntity to Entity
              final Map<String, dynamic> rawEntity = json.decode(response.body)["data"][operationName];
              final entity = SwingDataEntity.fromMap(rawEntity);

              //Entity to Dto
              final dto = SwingInfoAppDto();
              dto.swingId = entity.swingId;
              // dto.userId = entity.userId;
              // dto.swingInfoId = entity.swingInfoId;
              // dto.swingDate = entity.swingDate;
              // dto.isFavorite = (entity.isFavorite == 1) ? true : false;

              completer.complete(dto);
            } catch (e) {
              completer.completeError(e);
            }
          }
        }
      } else {
        completer.completeError(response.statusCode);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<UserActivateInfoAppDto?> registerUserActivate(final String endpoint, final String accessToken, final RegisterUserActivateInputAppDto input) {
    final completer = Completer<UserActivateInfoAppDto?>();

    const operationName = "registerUserActivate";

    final query = <String>[];
    query.add("mutation $operationName { ");
    query.add("$operationName(input: { ");
    query.add("userId: \"${input.userId}\", ");
    query.add("modelName: \"${input.modelName}\", ");
    query.add("serialNo: \"${input.serialNo}\", ");
    query.add("fwVersion: \"${input.fwVersion}\", ");
    query.add("}, ) { ");
    query.add("logId, ");
    query.add("at, ");
    query.add("userId, ");
    query.add("modelName, ");
    query.add("serialNo, ");
    query.add("fwVersion, ");
    query.add("}, ");
    query.add("}");

    cloudAPIDriver.request(Uri.parse(endpoint), operationName, query.join(), accessToken).then((final http.Response response) {
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        if (body.containsKey("errors")) {
          completer.completeError(Exception([
            {"statusCode": response.statusCode},
            {"errors": body["errors"]},
          ]));
        } else {
          final Map<String, dynamic> data = json.decode(response.body)["data"] as Map<String, dynamic>;
          if (data[operationName].toString().compareTo("null") == 0) {
            completer.complete(null);
          } else {
            try {
              //RawEntity to Entity
              final Map<String, dynamic> rawEntity = json.decode(response.body)["data"][operationName];
              final entity = UserActivateDataEntity.fromMap(rawEntity);

              //Entity to Dto
              final dto = UserActivateInfoAppDto();
              dto.logId = entity.logId;
              dto.at = DateFormat("yyyy-MM-dd HH:mm:ss").parse(entity.at, true);
              dto.userId = entity.userId;
              dto.modelName = entity.modelName;
              dto.serialNo = entity.serialNo;
              dto.fwVersion = entity.fwVersion;

              completer.complete(dto);
            } catch (e) {
              completer.completeError(e);
            }
          }
        }
      } else {
        completer.completeError(response.statusCode);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<UserLessonInfoAppDto?> getUserLesson(final String endpoint, final String accessToken, final GetUserLessonConditionAppDto condition) {
    final completer = Completer<UserLessonInfoAppDto?>();

    //tbd :テストデータ
    UserLessonInfoAppDto test = UserLessonInfoAppDto();
    LessonInfoAppDto lessonInfo1 = LessonInfoAppDto();
    lessonInfo1.title = "アドレスのルーティンを身につけよう";
    lessonInfo1.imgUrl = "No1-アドレス①.jpg";
    test.lessonInfoList.add(lessonInfo1);

    LessonInfoAppDto lessonInfo2 = LessonInfoAppDto();
    lessonInfo2.title = "ヘッドの位置、フェースの向きに注意しよう";
    lessonInfo2.imgUrl = "No8-HWB③.jpg";
    test.lessonInfoList.add(lessonInfo2);

    LessonInfoAppDto lessonInfo3 = LessonInfoAppDto();
    lessonInfo3.title = "テールバックを見直してみよう";
    lessonInfo3.imgUrl = "No92-曲がり・左ミス②.jpg";
    test.lessonInfoList.add(lessonInfo3);

    LessonInfoAppDto lessonInfo4 = LessonInfoAppDto();
    lessonInfo4.categoryType = ClubCategoryType.iron;
    lessonInfo4.title = "体とクラブの距離をキープしよう";
    lessonInfo4.imgUrl = "No66-アイアン①.jpg";
    test.lessonInfoList.add(lessonInfo4);

    LessonInfoAppDto lessonInfo5 = LessonInfoAppDto();
    lessonInfo5.categoryType = ClubCategoryType.iron;
    lessonInfo5.title = "右に傾く動きを抑えて打点を安定させよう";
    lessonInfo5.imgUrl = "No107-打点・右ミス③.jpg";
    test.lessonInfoList.add(lessonInfo5);

    LessonInfoAppDto lessonInfo6 = LessonInfoAppDto();
    lessonInfo6.categoryType = ClubCategoryType.iron;
    lessonInfo6.title = "ボール位置でスイング軌道を変えよう";
    lessonInfo6.imgUrl = "No48-インパクト③.jpg";
    test.lessonInfoList.add(lessonInfo6);

    completer.complete(test);
    return completer.future;
  }

  @override
  Future<SwingInfoAppDto?> updateSwing(final String endpoint, final String accessToken, final UpdateSwingConditionAppDto condition, final UpdateSwingInputAppDto input) {
    final completer = Completer<SwingInfoAppDto?>();

    const operationName = "updateSwing";

    List<String> query = [];
    query.add("mutation $operationName { ");
    query.add("$operationName(condition: { ");
    query.add("swingId: \"${condition.swingId}\", ");
    query.add("}, ");
    query.add("input: { ");
    if (input.memo != null) {
      query.add("memo: \"${input.memo}\", ");
    }
    if (input.isFavorite != null) {
      query.add("isFavorite: " + ((input.isFavorite!) ? "1, " : "0, "));
    }
    query.add("}, ) { ");
    query.add("swingId, ");
    query.add("swingStatusId, ");
    query.add("swingStatusName, ");
    query.add("isExistVideo, ");
    query.add("isFavorite, ");
    query.add("memo, ");
    query.add("swingVideoUrl, ");
    // query.add("rawData,");
    // query.add("users {");
    // query.add("userId,");
    // query.add("swingId,");
    // query.add("ownerId,");
    // query.add("paints {");
    // query.add("userId,");
    // query.add("swingId,");
    // query.add("paintId,");
    // query.add("displayOrder,");
    // query.add("paintStatusId,");
    // query.add("paintStatusName,");
    // query.add("shapeType,");
    // query.add("lineStartX,");
    // query.add("lineStartY,");
    // query.add("lineEndX,");
    // query.add("lineEndY,");
    // query.add("lineColor,");
    // query.add("circleCenterX,");
    // query.add("circleCenterY,");
    // query.add("circleColor,");
    // query.add("circleRadius,");
    // query.add("},");
    // query.add("}, ");
    query.add("}, ");
    query.add("}");

    cloudAPIDriver.request(Uri.parse(endpoint), operationName, query.join(), accessToken).then((final http.Response response) async {
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        if (body.containsKey("errors")) {
          completer.completeError(Exception([
            {"statusCode": response.statusCode},
            {"errors": body["errors"]},
          ]));
        } else {
          final Map<String, dynamic> data = json.decode(response.body)["data"] as Map<String, dynamic>;
          if (data[operationName].toString().compareTo("null") == 0) {
            completer.complete(null);
          } else {
            try {
              //RawEntity to Entity
              final Map<String, dynamic> rawEntity = json.decode(response.body)["data"][operationName];
              final entity = SwingDataEntity.fromMap(rawEntity);

              try {
                //Entity to Dto
                // final encryptValue = LZString.decompressFromBase64Sync(entity.rawData);
                // if (encryptValue == null) {
                //   throw Exception();
                // }
                // final systemParameterInfo = await parameterGateway.readSystemParameterInfo();
                // final decryptKey = stringCodecLogic.decode(systemParameterInfo.decryptCBCKey);
                // final decryptIv = stringCodecLogic.decode(systemParameterInfo.decryptCBCIv);
                // final rawJson = stringCodecLogic.decrypt(decryptKey, decryptIv, encryptValue, mode: AESMode.cbc);
                // final swingInfo = swingLogic.convertFromJson(rawJson);
                final swingInfo = SwingInfoAppDto();

                swingInfo.swingId = entity.swingId;
                swingInfo.isExistVideo = (entity.isExistVideo == 1) ? true : false;
                swingInfo.memo = entity.memo;
                swingInfo.isFavorite = (entity.isFavorite == 1) ? true : false;
                swingInfo.swingVideoUrl = entity.swingVideoUrl;

                // swingInfo.userSwingInfos = <UserSwingInfoAppDto>[];
                // for (final entity in entity.userSwingDatas) {
                //   final userSwingInfo = UserSwingInfoAppDto();
                //   userSwingInfo.userId = entity.userId;
                //   userSwingInfo.swingId = entity.swingId;
                //   userSwingInfo.ownerId = entity.ownerId;
                //   late var shapeDto;
                //   for (final paintEntity in entity.userSwingPaintDatas) {
                //     switch (paintEntity.shapeType) {
                //       case 0:
                //         shapeDto = PaintShapeCircleInfoAppDto();
                //         shapeDto.userId = paintEntity.userId;
                //         shapeDto.ownerId = entity.ownerId;
                //         shapeDto.swingId = paintEntity.swingId;
                //         shapeDto.paintId = paintEntity.paintId;
                //         shapeDto.displayOrder = paintEntity.displayOrder;

                //         shapeDto.isValid = true;
                //         shapeDto.isDeleted = false;
                //         shapeDto.isRegistered = false;
                //         shapeDto.isUpdated = false;
                //         shapeDto.center = Offset(paintEntity.paintCircleData!.centerX, paintEntity.paintCircleData!.centerY);
                //         shapeDto.radius = paintEntity.paintCircleData!.radius;
                //         shapeDto.color = int.parse(paintEntity.paintCircleData!.color, radix: 16);
                //         break;

                //       case 1:
                //         shapeDto = PaintShapeLineInfoAppDto();
                //         shapeDto.userId = paintEntity.userId;
                //         shapeDto.ownerId = entity.ownerId;
                //         shapeDto.swingId = paintEntity.swingId;
                //         shapeDto.paintId = paintEntity.paintId;
                //         shapeDto.displayOrder = paintEntity.displayOrder;

                //         shapeDto.isValid = true;
                //         shapeDto.isDeleted = false;
                //         shapeDto.isRegistered = false;
                //         shapeDto.isUpdated = false;
                //         shapeDto.start = Offset(paintEntity.paintLineData!.startX, paintEntity.paintLineData!.startY);
                //         shapeDto.end = Offset(paintEntity.paintLineData!.endX, paintEntity.paintLineData!.endY);
                //         shapeDto.color = int.parse(paintEntity.paintLineData!.color, radix: 16);
                //         break;
                //       default:
                //         break;
                //     }

                //     userSwingInfo.paintShapeInfos.add(shapeDto);
                //   }
                //   swingInfo.userSwingInfos.add(userSwingInfo);
                // }

                completer.complete(swingInfo);
              } catch (e) {
                completer.complete(null);
              }
            } catch (e) {
              completer.completeError(e);
            }
          }
        }
      } else {
        completer.completeError(response.statusCode);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<UserInfoAppDto?> withdrawUser(final String endpoint, final String accessToken, final WithdrawUserConditionAppDto condition, final WithdrawUserInputAppDto input) {
    final completer = Completer<UserInfoAppDto?>();

    String withdrawalTypeId = "a024cdbe-c3d3-eac2-ea84-07071bdd7e6d";
    switch (input.withdrawalReasonType) {
      case WithdrawalReasonType.hardToUse:
        withdrawalTypeId = "12cdba63-84e3-f223-3fc6-b0a7b5e6b7e2";
        break;
      case WithdrawalReasonType.hardToReadTheData:
        withdrawalTypeId = "2f6c2b2e-cc92-4511-659d-bfad831a9641";
        break;
      case WithdrawalReasonType.hardToGrowth:
        withdrawalTypeId = "5698a402-ec8a-018b-2626-2b537ee97c77";
        break;
      case WithdrawalReasonType.cost:
        withdrawalTypeId = "f8d25664-3e97-4cd1-18f1-1b79d6904928";
        break;
      case WithdrawalReasonType.retireFromGolf:
        withdrawalTypeId = "43fd3834-f0e8-aacb-21f4-d355e017e947";
        break;
      case WithdrawalReasonType.other:
        withdrawalTypeId = "a024cdbe-c3d3-eac2-ea84-07071bdd7e6d";
        break;
    }

    const operationName = "withdrawUser";

    List<String> query = [];
    query.add("mutation $operationName {");
    query.add("$operationName(condition: {");
    query.add("userId: \"${condition.userId}\"}, ");
    query.add("input: {");
    query.add("withdrawalTypeId: \"$withdrawalTypeId\", ");
    query.add("comment: \"${input.comment}\", ");
    query.add("}){");
    query.add("userId,");
    query.add("userStatusId,");
    query.add("userStatusName,");
    query.add("userRoles {");
    query.add("roleId,");
    query.add("roleName,");
    query.add("},");
    query.add("userBasicProfile {");
    query.add("avatarPath,");
    query.add("nickName,");
    query.add("firstName,");
    query.add("lastName,");
    query.add("firstNameKana,");
    query.add("lastNameKana,");
    query.add("birthday,");
    query.add("genderType,");
    query.add("height,");
    query.add("weight,");
    query.add("},");
    query.add("userGolferProfile {");
    query.add("startAt,");
    query.add("dominantHand,");
    query.add("scoreAVG,");
    query.add("gloveSize,");
    query.add("roundPlayFrequency,");
    query.add("exerciseFrequency,");
    query.add("worry,");
    query.add("worryMemo,");
    query.add("},");
    query.add("},");
    query.add("}");

    cloudAPIDriver.request(Uri.parse(endpoint), operationName, query.join(), accessToken).then((final http.Response response) {
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        if (body.containsKey("errors")) {
          completer.completeError(Exception([
            {"statusCode": response.statusCode},
            {"errors": body["errors"]},
          ]));
        } else {
          final Map<String, dynamic> data = json.decode(response.body)["data"] as Map<String, dynamic>;
          if (data[operationName].toString().compareTo("null") == 0) {
            completer.complete(null);
          } else {
            try {
              //RawEntity to Entity
              final Map<String, dynamic> rawEntity = json.decode(response.body)["data"][operationName];
              final entity = UserDataEntity.fromMap(rawEntity);

              //Entity to Dto
              final userInfo = UserInfoAppDto();
              userInfo.userId = entity.userId;
              switch (entity.userStatusId) {
                case "30b5cbfb-356d-c7c4-f5a2-67cc816415be":
                  userInfo.userStatus = UserStatusType.active;
                  break;
                case "eabfe49b-1426-aaf9-9a3c-0a0dc0d35302":
                  userInfo.userStatus = UserStatusType.withdrawal;
                  break;
                default:
                  userInfo.userStatus = UserStatusType.unKnown;
              }

              //userBasicProfile
              userInfo.userBasicProfileInfo = UserBasicProfileInfoAppDto();
              userInfo.userBasicProfileInfo.avatarPath = entity.userBasicProfile.avatarPath;
              userInfo.userBasicProfileInfo.nickName = entity.userBasicProfile.nickName;
              userInfo.userBasicProfileInfo.firstName = entity.userBasicProfile.firstName;
              userInfo.userBasicProfileInfo.lastName = entity.userBasicProfile.lastName;
              userInfo.userBasicProfileInfo.firstNameKana = entity.userBasicProfile.firstNameKana;
              userInfo.userBasicProfileInfo.lastNameKana = entity.userBasicProfile.lastNameKana;
              if (entity.userBasicProfile.birthday != null) {
                final birthdayLocal = DateTime.parse(entity.userBasicProfile.birthday!);
                final birthdayUtc = DateTime.utc(birthdayLocal.year, birthdayLocal.month, birthdayLocal.day, 0, 0, 0);
                userInfo.userBasicProfileInfo.birthday = birthdayUtc;
              }
              switch (entity.userBasicProfile.genderType) {
                case 0:
                  userInfo.userBasicProfileInfo.genderType = GenderType.male;
                  break;
                case 1:
                  userInfo.userBasicProfileInfo.genderType = GenderType.female;
                  break;
                case 9:
                  userInfo.userBasicProfileInfo.genderType = GenderType.other;
                  break;
                default:
                  userInfo.userBasicProfileInfo.genderType = GenderType.other;
              }
              userInfo.userBasicProfileInfo.height = entity.userBasicProfile.height;
              userInfo.userBasicProfileInfo.weight = entity.userBasicProfile.weight;

              //userGolferProfile
              userInfo.userGolferProfileInfo = UserGolferProfileInfoAppDto();
              userInfo.userGolferProfileInfo.startAt = entity.userGolferProfile.startAt;
              switch (entity.userGolferProfile.dominantHandType) {
                case 0:
                  userInfo.userGolferProfileInfo.dominantHandType = DominantHandType.right;
                  break;
                case 1:
                  userInfo.userGolferProfileInfo.dominantHandType = DominantHandType.left;
                  break;
                default:
                  userInfo.userGolferProfileInfo.dominantHandType = DominantHandType.right;
              }
              userInfo.userGolferProfileInfo.scoreAVG = entity.userGolferProfile.scoreAVG;
              userInfo.userGolferProfileInfo.gloveSize = entity.userGolferProfile.gloveSize;
              userInfo.userGolferProfileInfo.roundPlayFrequency = entity.userGolferProfile.roundPlayFrequency;
              userInfo.userGolferProfileInfo.exerciseFrequency = entity.userGolferProfile.exerciseFrequency;
              userInfo.userGolferProfileInfo.worry = entity.userGolferProfile.worry;
              userInfo.userGolferProfileInfo.worryMemo = entity.userGolferProfile.worryMemo;

              //userRoles
              userInfo.userRoleInfos = [];
              for (final entity in entity.userRoleDatas) {
                final roleInfo = RoleInfoAppDto();
                roleInfo.roleId = entity.roleId;
                roleInfo.roleName = entity.roleName;
                userInfo.userRoleInfos.add(roleInfo);
              }

              completer.complete(userInfo);
            } catch (e) {
              completer.completeError(e);
            }
          }
        }
      } else {
        completer.completeError(response.statusCode);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<void> deletePaint(final String endpoint, final String accessToken, final DeletePaintConditionAppDto condition) {
    final completer = Completer<void>();

    const operationName = "deletePaint";
    List<String> query = [];
    query.add("mutation $operationName {");
    query.add("$operationName(condition: {");
    query.add("userId: \"${condition.userId}\", ");
    query.add("swingId: \"${condition.swingId}\", ");
    query.add("paintId: \"${condition.paintId}\", ");
    query.add("}){");
    query.add("paintId,");
    query.add("shapeType,");
    query.add("paintStatusId,");
    query.add("paintStatusName,");
    query.add("displayOrder,");
    query.add("circleCenterX,");
    query.add("circleCenterY,");
    query.add("circleRadius,");
    query.add("circleColor,");
    query.add("lineStartX,");
    query.add("lineStartY,");
    query.add("lineEndX,");
    query.add("lineEndY,");
    query.add("lineColor,");
    query.add("}");
    query.add("}");

    cloudAPIDriver.request(Uri.parse(endpoint), operationName, query.join(), accessToken).then((final http.Response response) {
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        if (body.containsKey("errors")) {
          completer.completeError(Exception([
            {"statusCode": response.statusCode},
            {"errors": body["errors"]},
          ]));
        } else {
          final Map<String, dynamic> data = json.decode(response.body)["data"] as Map<String, dynamic>;
          if (data[operationName].toString().compareTo("null") == 0) {
            completer.complete(null);
          } else {
            //各情報を更新後、一括でスイング情報を取得するため値を返却しない
            completer.complete();
          }
        }
      } else {
        completer.completeError(response.statusCode);
      }
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  @override
  Future<void> updatePaintCircle(final String endpoint, final String accessToken, final UpdatePaintCircleConditionAppDto condition, final UpdatePaintCircleInputAppDto input) {
    final completer = Completer<void>();

    const operationName = "updatePaintCircle";

    List<String> query = [];
    query.add("mutation $operationName {");
    query.add("$operationName(condition: {");
    query.add("userId: \"${condition.userId}\", ");
    query.add("swingId: \"${condition.swingId}\", ");
    query.add("paintId: \"${condition.paintId}\", ");
    query.add("},");
    query.add("input: {");
    query.add("centerX: ${input.centerX.round()}, ");
    query.add("centerY: ${input.centerY.round()}, ");
    query.add("displayOrder: ${input.displayOrder}, ");
    query.add("radius: ${input.radius.round()}, ");
    query.add("color: \"${Color(input.color).value.toRadixString(16)}\", ");
    query.add("}){");
    query.add("paintId,");
    query.add("shapeType,");
    query.add("paintStatusId,");
    query.add("paintStatusName,");
    query.add("displayOrder,");
    query.add("circleCenterX,");
    query.add("circleCenterY,");
    query.add("circleRadius,");
    query.add("circleColor,");
    query.add("lineStartX,");
    query.add("lineStartY,");
    query.add("lineEndX,");
    query.add("lineEndY,");
    query.add("lineColor,");
    query.add("}");
    query.add("}");

    cloudAPIDriver.request(Uri.parse(endpoint), operationName, query.join(), accessToken).then((final http.Response response) {
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        if (body.containsKey("errors")) {
          completer.completeError(Exception([
            {"statusCode": response.statusCode},
            {"errors": body["errors"]},
          ]));
        } else {
          final Map<String, dynamic> data = json.decode(response.body)["data"] as Map<String, dynamic>;
          if (data[operationName].toString().compareTo("null") == 0) {
            completer.complete(null);
          } else {
            //各情報を更新後、一括でスイング情報を取得するため値を返却しない
            completer.complete();
          }
        }
      } else {
        completer.completeError(response.statusCode);
      }
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  @override
  Future<void> updatePaintLine(final String endpoint, final String accessToken, final UpdatePaintLineConditionAppDto condition, final UpdatePaintLineInputAppDto input) {
    final completer = Completer<void>();

    const operationName = "updatePaintLine";

    List<String> query = [];
    query.add("mutation $operationName {");
    query.add("$operationName(condition: {");
    query.add("userId: \"${condition.userId}\", ");
    query.add("swingId: \"${condition.swingId}\", ");
    query.add("paintId: \"${condition.paintId}\", ");
    query.add("},");
    query.add("input: {");
    query.add("startX: ${input.startX.round()}, ");
    query.add("startY: ${input.startY.round()}, ");
    query.add("endX: ${input.endX.round()}, ");
    query.add("endY: ${input.endY.round()}, ");
    query.add("displayOrder: ${input.displayOrder}, ");
    query.add("color: \"${Color(input.color).value.toRadixString(16)}\", ");
    query.add("}){");
    query.add("paintId,");
    query.add("shapeType,");
    query.add("paintStatusId,");
    query.add("paintStatusName,");
    query.add("displayOrder,");
    query.add("circleCenterX,");
    query.add("circleCenterY,");
    query.add("circleRadius,");
    query.add("circleColor,");
    query.add("lineStartX,");
    query.add("lineStartY,");
    query.add("lineEndX,");
    query.add("lineEndY,");
    query.add("lineColor,");
    query.add("}");
    query.add("}");

    cloudAPIDriver.request(Uri.parse(endpoint), operationName, query.join(), accessToken).then((final http.Response response) {
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        if (body.containsKey("errors")) {
          completer.completeError(Exception([
            {"statusCode": response.statusCode},
            {"errors": body["errors"]},
          ]));
        } else {
          final Map<String, dynamic> data = json.decode(response.body)["data"] as Map<String, dynamic>;
          if (data[operationName].toString().compareTo("null") == 0) {
            completer.complete(null);
          } else {
            //各情報を更新後、一括でスイング情報を取得するため値を返却しない
            completer.complete();
          }
        }
      } else {
        completer.completeError(response.statusCode);
      }
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  @override
  Future<void> registerPaintCircle(final String endpoint, final String accessToken, final RegisterPaintCircleInputAppDto input) {
    final completer = Completer<void>();

    const operationName = "registerPaintCircle";
    List<String> query = [];
    query.add("mutation $operationName {");
    query.add("$operationName(input: {");
    query.add("userId: \"${input.userId}\", ");
    query.add("ownerId: \"${input.ownerId}\", ");
    query.add("swingId: \"${input.swingId}\", ");
    query.add("paintId: \"${input.paintId}\", ");
    query.add("centerX: ${input.centerX.round()}, ");
    query.add("centerY: ${input.centerY.round()}, ");
    query.add("displayOrder: ${input.displayOrder}, ");
    query.add("radius: ${input.radius.round()}, ");
    query.add("color: \"${Color(input.color).value.toRadixString(16)}\", ");
    query.add("}){");
    query.add("paintId,");
    query.add("shapeType,");
    query.add("paintStatusId,");
    query.add("paintStatusName,");
    query.add("displayOrder,");
    query.add("circleCenterX,");
    query.add("circleCenterY,");
    query.add("circleRadius,");
    query.add("circleColor,");
    query.add("lineStartX,");
    query.add("lineStartY,");
    query.add("lineEndX,");
    query.add("lineEndY,");
    query.add("lineColor,");
    query.add("}");
    query.add("}");

    cloudAPIDriver.request(Uri.parse(endpoint), operationName, query.join(), accessToken).then((final http.Response response) {
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        if (body.containsKey("errors")) {
          completer.completeError(Exception([
            {"statusCode": response.statusCode},
            {"errors": body["errors"]},
          ]));
        } else {
          final Map<String, dynamic> data = json.decode(response.body)["data"] as Map<String, dynamic>;
          if (data[operationName].toString().compareTo("null") == 0) {
            completer.complete(null);
          } else {
            //各情報を更新後、一括でスイング情報を取得するため値を返却しない
            completer.complete();
          }
        }
      } else {
        completer.completeError(response.statusCode);
      }
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  @override
  Future<void> registerPaintLine(final String endpoint, final String accessToken, final RegisterPaintLineInputAppDto input) {
    final completer = Completer<void>();

    const operationName = "registerPaintLine";

    List<String> query = [];
    query.add("mutation $operationName {");
    query.add("$operationName(input: {");
    query.add("userId: \"${input.userId}\", ");
    query.add("ownerId: \"${input.ownerId}\", ");
    query.add("swingId: \"${input.swingId}\", ");
    query.add("paintId: \"${input.paintId}\", ");
    query.add("startX: ${input.startX.round()}, ");
    query.add("startY: ${input.startY.round()}, ");
    query.add("endX: ${input.endX.round()}, ");
    query.add("endY: ${input.endY.round()}, ");
    query.add("displayOrder: ${input.displayOrder}, ");
    query.add("color: \"${Color(input.color).value.toRadixString(16)}\", ");
    query.add("}){");
    query.add("paintId,");
    query.add("shapeType,");
    query.add("paintStatusId,");
    query.add("paintStatusName,");
    query.add("displayOrder,");
    query.add("circleCenterX,");
    query.add("circleCenterY,");
    query.add("circleRadius,");
    query.add("circleColor,");
    query.add("lineStartX,");
    query.add("lineStartY,");
    query.add("lineEndX,");
    query.add("lineEndY,");
    query.add("lineColor,");
    query.add("}");
    query.add("}");

    cloudAPIDriver.request(Uri.parse(endpoint), operationName, query.join(), accessToken).then((final http.Response response) {
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        if (body.containsKey("errors")) {
          completer.completeError(Exception([
            {"statusCode": response.statusCode},
            {"errors": body["errors"]},
          ]));
        } else {
          final Map<String, dynamic> data = json.decode(response.body)["data"] as Map<String, dynamic>;
          if (data[operationName].toString().compareTo("null") == 0) {
            completer.complete(null);
          } else {
            //各情報を更新後、一括でスイング情報を取得するため値を返却しない
            completer.complete();
          }
        }
      } else {
        completer.completeError(response.statusCode);
      }
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  @override
  Future<ShoppingInfoAppDto> getShopping(final String endpoint, final String accessToken) {
    final completer = Completer<ShoppingInfoAppDto>();

    ShoppingInfoAppDto shoppingInfo = ShoppingInfoAppDto();
    shoppingInfo.categorys = ["全て", "ギフト券"];

    ShopItemInfoAppDto shopItem2 = ShopItemInfoAppDto();
    shopItem2.id = 1;
    shopItem2.category = "ギフト券";
    shopItem2.name = "3,000円分Amazonギフト券";
    shopItem2.description = "Amazonでご利用いただけるギフト券です。";
    shopItem2.itemImage = "https://unsplash.it/630/400";
    shopItem2.price = 3000;
    shoppingInfo.shopItemInfos.add(shopItem2);

    ShopItemInfoAppDto shopItem1 = ShopItemInfoAppDto();
    shopItem2.id = 2;
    shopItem1.category = "ギフト券";
    shopItem1.name = "5,000円分Amazonギフト券";
    shopItem1.description = "Amazonでご利用いただけるギフト券です。";
    shopItem1.itemImage = "https://unsplash.it/630/400";
    shopItem1.price = 5000;
    shoppingInfo.shopItemInfos.add(shopItem1);

    ShopItemInfoAppDto shopItem3 = ShopItemInfoAppDto();
    shopItem3.id = 3;
    shopItem3.category = "ギフト券";
    shopItem3.name = "10,000円分Amazonギフト券";
    shopItem3.description = "Amazonでご利用いただけるギフト券です。";
    shopItem3.itemImage = "https://unsplash.it/630/400";
    shopItem3.price = 10000;
    shoppingInfo.shopItemInfos.add(shopItem3);

    completer.complete(shoppingInfo);
    return completer.future;
  }
}
