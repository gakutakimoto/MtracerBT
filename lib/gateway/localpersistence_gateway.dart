import 'dart:async';
import 'dart:convert';

import 'package:mtracersdkexample/appdto/deviceinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/dominanthand_type.dart';
import 'package:mtracersdkexample/appdto/gender_type.dart';
import 'package:mtracersdkexample/appdto/roleinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userstatus_type.dart';
import 'package:mtracersdkexample/driver/preference_driver.dart';
import 'package:mtracersdkexample/driverinterface/preference_driverinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/localpersistence_gatewayinterface.dart';

enum Keys {
  userInfo,
  uuid,
  serialNo,
  swingInfo,
}

class LocalPersistenceGateway extends LocalPersistenceGatewayInterface {
  late PreferenceDriverInterface preferenceDriver;

  LocalPersistenceGateway() {
    preferenceDriver = PreferenceDriver();
  }

  @override
  Future<UserInfoAppDto?> readUserInfo(final String userSub) {
    final completer = Completer<UserInfoAppDto?>();

    preferenceDriver.readString(userSub + "." + Keys.userInfo.name).then((final String? rawEntity) {
      if (rawEntity == null) {
        completer.complete(null);
      } else {
        final Map<String, dynamic> entity = json.decode(rawEntity);

        final userInfo = UserInfoAppDto();
        userInfo.userId = (entity.containsKey("userId")) ? entity["userId"] : "";
        if (entity.containsKey("userStatusName")) {
          if (entity["userStatusName"].toString().compareTo(UserStatusType.active.name) == 0) {
            userInfo.userStatus = UserStatusType.active;
          } else if (entity["userStatusName"].toString().compareTo(UserStatusType.withdrawal.name) == 0) {
            userInfo.userStatus = UserStatusType.withdrawal;
          } else {
            userInfo.userStatus = UserStatusType.unKnown;
          }
        }

        //UserBasicProfile
        if (entity.containsKey("userBasicProfile")) {
          userInfo.userBasicProfileInfo.avatarPath = entity["userBasicProfile"].containsKey("avatarPath") ? entity["userBasicProfile"]["avatarPath"] : null;
          userInfo.userBasicProfileInfo.nickName = entity["userBasicProfile"].containsKey("nickName") ? entity["userBasicProfile"]["nickName"] : "";
          userInfo.userBasicProfileInfo.firstName = entity["userBasicProfile"].containsKey("firstName") ? entity["userBasicProfile"]["firstName"] : null;
          userInfo.userBasicProfileInfo.lastName = entity["userBasicProfile"].containsKey("lastName") ? entity["userBasicProfile"]["lastName"] : null;
          userInfo.userBasicProfileInfo.firstNameKana = entity["userBasicProfile"].containsKey("firstNameKana") ? entity["userBasicProfile"]["firstNameKana"] : null;
          userInfo.userBasicProfileInfo.lastNameKana = entity["userBasicProfile"].containsKey("lastNameKana") ? entity["userBasicProfile"]["lastNameKana"] : null;

          if (entity["userBasicProfile"].containsKey("birthday")) {
            final birthdayLocal = DateTime.parse(entity["userBasicProfile"]["birthday"]);
            final birthdayUtc = DateTime.utc(birthdayLocal.year, birthdayLocal.month, birthdayLocal.day, 0, 0, 0);
            userInfo.userBasicProfileInfo.birthday = birthdayUtc;
          }
          if (entity["userBasicProfile"].containsKey("genderType")) {
            switch (entity["userBasicProfile"]["genderType"]) {
              case "male":
                userInfo.userBasicProfileInfo.genderType = GenderType.male;
                break;
              case "female":
                userInfo.userBasicProfileInfo.genderType = GenderType.female;
                break;
              case "other":
                userInfo.userBasicProfileInfo.genderType = GenderType.other;
                break;
              default:
                userInfo.userBasicProfileInfo.genderType = GenderType.other;
            }
          }
          userInfo.userBasicProfileInfo.height = entity["userBasicProfile"].containsKey("height") ? entity["userBasicProfile"]["height"] : 0.0;
          userInfo.userBasicProfileInfo.weight = entity["userBasicProfile"].containsKey("weight") ? entity["userBasicProfile"]["weight"] : 0.0;
        }

        //UserGolferProfile
        if (entity.containsKey("userGolferProfile")) {
          if (entity["userGolferProfile"].containsKey("startAt")) {
            final startAtLocal = DateTime.parse(entity["userGolferProfile"]["startAt"]);
            final startAtUtc = DateTime.utc(startAtLocal.year, startAtLocal.month, startAtLocal.day, 0, 0, 0);
            userInfo.userGolferProfileInfo.startAt = startAtUtc;
          } else {
            userInfo.userGolferProfileInfo.startAt = null;
          }
          if (entity["userGolferProfile"].containsKey("dominantHandType")) {
            switch (entity["userGolferProfile"]["dominantHandType"]) {
              case "left":
                userInfo.userGolferProfileInfo.dominantHandType = DominantHandType.left;
                break;
              case "right":
                userInfo.userGolferProfileInfo.dominantHandType = DominantHandType.right;
                break;
              default:
                userInfo.userGolferProfileInfo.dominantHandType = DominantHandType.right;
            }
          }
          userInfo.userGolferProfileInfo.scoreAVG = entity["userGolferProfile"].containsKey("scoreAVG") ? entity["userGolferProfile"]["scoreAVG"] : 0;
          userInfo.userGolferProfileInfo.gloveSize = entity["userGolferProfile"].containsKey("gloveSize") ? entity["userGolferProfile"]["gloveSize"] : 0;
          userInfo.userGolferProfileInfo.roundPlayFrequency = entity["userGolferProfile"].containsKey("roundPlayFrequency") ? entity["userGolferProfile"]["roundPlayFrequency"] : null;
          userInfo.userGolferProfileInfo.exerciseFrequency = entity["userGolferProfile"].containsKey("exerciseFrequency") ? entity["userGolferProfile"]["exerciseFrequency"] : null;
          userInfo.userGolferProfileInfo.worry = entity["userGolferProfile"].containsKey("worry") ? entity["userGolferProfile"]["worry"] : null;
          userInfo.userGolferProfileInfo.worryMemo = entity["userGolferProfile"].containsKey("worryMemo") ? entity["userGolferProfile"]["worryMemo"] : null;
        }

        //UserRoles
        if (entity.containsKey("userRoles")) {
          for (final entity in entity["userRoles"]) {
            final roleInfo = RoleInfoAppDto();
            roleInfo.roleId = entity.containsKey("roleId") ? entity["roleId"] : "";
            roleInfo.roleName = entity.containsKey("roleName") ? entity["roleName"] : "";
            userInfo.userRoleInfos.add(roleInfo);
          }
        }

        completer.complete(userInfo);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<bool> persistUserInfo(final String userSub, final UserInfoAppDto value) {
    final completer = Completer<bool>();

    //UserBasicProfile
    final Map<String, dynamic> userBasicProfileEntity = {
      "nickName": value.userBasicProfileInfo.nickName,
      "genderType": value.userBasicProfileInfo.genderType.name,
      "height": value.userBasicProfileInfo.height,
      "weight": value.userBasicProfileInfo.weight,
    };
    if (value.userBasicProfileInfo.avatarPath != null) {
      userBasicProfileEntity.addEntries({"avatarPath": value.userBasicProfileInfo.avatarPath}.entries);
    }
    if (value.userBasicProfileInfo.firstName != null) {
      userBasicProfileEntity.addEntries({"firstName": value.userBasicProfileInfo.firstName}.entries);
    }
    if (value.userBasicProfileInfo.lastName != null) {
      userBasicProfileEntity.addEntries({"lastName": value.userBasicProfileInfo.lastName}.entries);
    }
    if (value.userBasicProfileInfo.firstNameKana != null) {
      userBasicProfileEntity.addEntries({"firstNameKana": value.userBasicProfileInfo.firstNameKana}.entries);
    }
    if (value.userBasicProfileInfo.lastNameKana != null) {
      userBasicProfileEntity.addEntries({"lastNameKana": value.userBasicProfileInfo.lastNameKana}.entries);
    }
    if (value.userBasicProfileInfo.birthday != null) {
      userBasicProfileEntity.addEntries({"birthday": value.userBasicProfileInfo.birthday!.toUtc().toString()}.entries);
    }

    //UserGolferProfile
    final Map<String, dynamic> userGolferProfileEntity = {
      "dominantHandType": value.userGolferProfileInfo.dominantHandType.name,
      "scoreAVG": value.userGolferProfileInfo.scoreAVG,
      "gloveSize": value.userGolferProfileInfo.gloveSize,
    };
    if (value.userGolferProfileInfo.startAt != null) {
      userGolferProfileEntity.addEntries({"startAt": value.userGolferProfileInfo.startAt.toString()}.entries);
    }
    if (value.userGolferProfileInfo.roundPlayFrequency != null) {
      userGolferProfileEntity.addEntries({"roundPlayFrequency": value.userGolferProfileInfo.roundPlayFrequency}.entries);
    }
    if (value.userGolferProfileInfo.worry != null) {
      userGolferProfileEntity.addEntries({"worry": value.userGolferProfileInfo.worry}.entries);
    }
    if (value.userGolferProfileInfo.worryMemo != null) {
      userGolferProfileEntity.addEntries({"worryMemo": value.userGolferProfileInfo.worryMemo}.entries);
    }

    //UserRoles
    final List<Map> userRoleEntities = [];
    for (final userRoleInfo in value.userRoleInfos) {
      final Map<String, dynamic> entity = {
        "roleId": userRoleInfo.roleId,
        "roleName": userRoleInfo.roleName,
      };
      userRoleEntities.add(entity);
    }

    //User
    final Map<String, dynamic> entity = {
      "userId": value.userId,
      "userStatusName": value.userStatus.name,
      "userBasicProfile": userBasicProfileEntity,
      "userGolferProfile": userGolferProfileEntity,
      "userRoles": userRoleEntities,
    };
    final rawEntity = json.encode(entity);

    preferenceDriver.persistString(userSub + "." + Keys.userInfo.name, rawEntity).then((final bool isSuccess) {
      completer.complete(isSuccess);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<bool> removeUserInfo(final String userSub) {
    final completer = Completer<bool>();

    preferenceDriver.removeBy(userSub + "." + Keys.userInfo.name).then((final bool isSuccess) {
      completer.complete(isSuccess);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<String?> readDeviceUUIDInfo(final String userId) {
    final completer = Completer<String?>();

    preferenceDriver.readString(userId + "." + Keys.uuid.name).then((final String? rawEntity) {
      completer.complete(rawEntity);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<bool> persistDeviceUUIDInfo(final String userId, final String value) {
    final completer = Completer<bool>();

    preferenceDriver.persistString(userId + "." + Keys.uuid.name, value).then((final bool isSuccess) {
      completer.complete(isSuccess);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<bool> removeDeviceUUIDInfo(final String userId) {
    final completer = Completer<bool>();

    preferenceDriver.removeBy(userId + "." + Keys.uuid.name).then((final bool isSuccess) {
      completer.complete(isSuccess);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<DeviceInfoAppDto?> readDeviceInfo(final String userId) {
    final completer = Completer<DeviceInfoAppDto?>();

    preferenceDriver.readString(userId + "." + Keys.serialNo.name).then((final String? rawEntity) {
      if (rawEntity == null) {
        completer.complete(null);
      } else {
        final Map<String, dynamic> entity = json.decode(rawEntity);

        final deviceInfo = DeviceInfoAppDto();
        deviceInfo.modelName = (entity.containsKey("modelName")) ? entity["modelName"] : "";
        deviceInfo.serialNo = (entity.containsKey("serialNo")) ? entity["serialNo"] : "";
        deviceInfo.fwVersion = (entity.containsKey("fwVersion")) ? entity["fwVersion"] : "";

        completer.complete(deviceInfo);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<bool> persistDeviceInfo(final String userId, final DeviceInfoAppDto value) {
    final completer = Completer<bool>();

    final Map<String, dynamic> entity = {
      "modelName": value.modelName,
      "serialNo": value.serialNo,
      "fwVersion": value.fwVersion,
    };
    final rawEntity = json.encode(entity);

    preferenceDriver.persistString(userId + "." + Keys.serialNo.name, rawEntity).then((final bool isSuccess) {
      completer.complete(isSuccess);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<bool> removeDeviceInfo(final String userId) {
    final completer = Completer<bool>();

    preferenceDriver.removeBy(userId + "." + Keys.serialNo.name).then((final bool isSuccess) {
      completer.complete(isSuccess);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<String?> readSwingInfo(final String userId) {
    final completer = Completer<String?>();

    preferenceDriver.readString(userId + "." + Keys.swingInfo.name).then((final String? rawEntity) {
      completer.complete(rawEntity);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<bool> persistSwingInfo(final String userId, final String value) {
    final completer = Completer<bool>();

    preferenceDriver.persistString(userId + "." + Keys.swingInfo.name, value).then((final bool isSuccess) {
      completer.complete(isSuccess);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<bool> removeSwingInfo(final String userId) {
    final completer = Completer<bool>();

    preferenceDriver.removeBy(userId + "." + Keys.swingInfo.name).then((final bool isSuccess) {
      completer.complete(isSuccess);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }
}
