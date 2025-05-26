import 'package:mtracersdkexample/entity/userswingpaintdata_entity.dart';

class UserSwingDataEntity {
  late String userId;
  late String swingId;
  late String ownerId;

  late List<UserSwingPaintDataEntity> userSwingPaintDatas;

  UserSwingDataEntity() {
    userId = "";
    swingId = "";
    ownerId = "";

    userSwingPaintDatas = [];
  }

  UserSwingDataEntity.fromMap(final Map<String, dynamic> map) {
    userId = map.containsKey("userId") ? map["userId"] : "";
    swingId = map.containsKey("swingId") ? map["swingId"] : "";
    ownerId = map.containsKey("ownerId") ? map["ownerId"] : "";

    userSwingPaintDatas = [];
    if (map.containsKey("paints") && map["paints"] != null) {
      for (final Map<String, dynamic> entity in map["paints"]) {
        final UserSwingPaintDataEntity swingPaintDataEntity = UserSwingPaintDataEntity.fromMap(entity);
        userSwingPaintDatas.add(swingPaintDataEntity);
      }
    }
  }
}
