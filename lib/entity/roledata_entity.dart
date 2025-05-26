class RoleDataEntity {
  late String roleId;
  late String roleName;

  RoleDataEntity() {
    roleId = "";
    roleName = "";
  }

  RoleDataEntity.fromMap(final Map<String, dynamic> map) {
    roleId = map.containsKey("roleId") ? map["roleId"] : "";
    roleName = map.containsKey("roleName") ? map["roleName"] : "";
  }
}
