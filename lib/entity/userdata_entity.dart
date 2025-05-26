import 'package:mtracersdkexample/entity/roledata_entity.dart';
import 'package:mtracersdkexample/entity/userbasicprofiledata_entity.dart';
import 'package:mtracersdkexample/entity/usergolferprofiledata_entity.dart';

class UserDataEntity {
  late String userId;
  late String userStatusId;
  late String userStatusName;
  late UserBasicProfileDataEntity userBasicProfile;
  late UserGolferProfileDataEntity userGolferProfile;
  late List<RoleDataEntity> userRoleDatas;

  UserDataEntity() {
    userId = "";
    userStatusId = "";
    userStatusName = "";
    userRoleDatas = [];
  }

  UserDataEntity.fromMap(final Map<String, dynamic> map) {
    userId = map.containsKey("userId") ? map["userId"] : "";
    userStatusId = map.containsKey("userStatusId") ? map["userStatusId"] : "";
    userStatusName = map.containsKey("userStatusName") ? map["userStatusName"] : "";

    if (map.containsKey("userBasicProfile") && map["userBasicProfile"] != null) {
      userBasicProfile = UserBasicProfileDataEntity.fromMap(map["userBasicProfile"]);
    } else {
      userBasicProfile = UserBasicProfileDataEntity();
    }

    if (map.containsKey("userGolferProfile") && map["userGolferProfile"] != null) {
      userGolferProfile = UserGolferProfileDataEntity.fromMap(map["userGolferProfile"]);
    } else {
      userGolferProfile = UserGolferProfileDataEntity();
    }

    userRoleDatas = [];
    if (map.containsKey("userRoles") && map["userRoles"] != null) {
      for (final Map<String, dynamic> rawEntity in map["userRoles"]) {
        final entity = RoleDataEntity.fromMap(rawEntity);
        final userRole = RoleDataEntity();
        userRole.roleId = entity.roleId;
        userRole.roleName = entity.roleName;
        userRoleDatas.add(userRole);
      }
    }
  }
}
