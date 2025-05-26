class AuthUserDataEntity {
  late String userSub;
  late String userId;

  AuthUserDataEntity() {
    userSub = "";
    userId = "";
  }

  AuthUserDataEntity.fromMap(final Map<String, dynamic> map) {
    userSub = map.containsKey("userSub") ? map["userSub"] : "";
    userId = map.containsKey("userId") ? map["userId"] : "";
  }
}
