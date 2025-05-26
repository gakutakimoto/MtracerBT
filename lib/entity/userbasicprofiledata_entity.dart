class UserBasicProfileDataEntity {
  late String userId;
  late String? avatarPath;
  late String nickName;
  late String? firstName;
  late String? lastName;
  late String? firstNameKana;
  late String? lastNameKana;
  late String? birthday;
  late int genderType;
  late double height;
  late double weight;

  UserBasicProfileDataEntity() {
    userId = "";
    avatarPath = null;
    nickName = "";
    firstName = null;
    lastName = null;
    firstNameKana = null;
    lastNameKana = null;
    birthday = null;
    genderType = 9;
    height = 0.0;
    weight = 0.0;
  }

  UserBasicProfileDataEntity.fromMap(final Map<String, dynamic> map) {
    userId = map.containsKey("userId") ? map["userId"] : "";
    avatarPath = map.containsKey("avatarPath") ? map["avatarPath"] : null;
    nickName = map.containsKey("nickName") ? map["nickName"] : "";
    firstName = map.containsKey("firstName") ? map["firstName"] : null;
    lastName = map.containsKey("lastName") ? map["lastName"] : null;
    firstNameKana = map.containsKey("firstNameKana") ? map["firstNameKana"] : null;
    lastNameKana = map.containsKey("lastNameKana") ? map["lastNameKana"] : null;
    birthday = map.containsKey("birthday") ? map["birthday"] : null;
    genderType = map.containsKey("genderType") ? map["genderType"] : 9;
    height = map.containsKey("height") ? ((map["height"] as num) as double) * 1.0 : 0.0;
    weight = map.containsKey("weight") ? ((map["weight"] as num) as double) * 1.0 : 0.0;
  }
}
