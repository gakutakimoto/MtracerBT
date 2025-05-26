import 'package:mtracersdkexample/appdto/roleinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userbasicprofileinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/usergolferprofileinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userstatus_type.dart';

class UserInfoAppDto {
  late String userId;
  late UserStatusType userStatus;
  late UserBasicProfileInfoAppDto userBasicProfileInfo;
  late UserGolferProfileInfoAppDto userGolferProfileInfo;
  late List<RoleInfoAppDto> userRoleInfos;

  UserInfoAppDto() {
    userId = "";
    userStatus = UserStatusType.unKnown;
    userBasicProfileInfo = UserBasicProfileInfoAppDto();
    userGolferProfileInfo = UserGolferProfileInfoAppDto();
    userRoleInfos = [];
  }
}
