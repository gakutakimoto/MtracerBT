import 'package:mtracersdkexample/entity/userswingdata_entity.dart';

class SwingDataEntity {
  late String swingId;
  late String swingStatusId;
  late String swingStatusName;
  late int isExistVideo;
  late int isFavorite;
  late String? memo;
  late String rawData;
  late String? swingVideoUrl;

  late List<UserSwingDataEntity> userSwingDatas;

  SwingDataEntity() {
    swingId = "";
    swingStatusId = "";
    swingStatusName = "";
    isExistVideo = 0;
    isFavorite = 0;
    memo = null;
    rawData = "";
    swingVideoUrl = null;

    userSwingDatas = [];
  }

  SwingDataEntity.fromMap(final Map<String, dynamic> map) {
    swingId = map.containsKey("swingId") ? map["swingId"] : "";
    swingStatusId = map.containsKey("swingStatusId") ? map["swingStatusId"] : "";
    swingStatusName = map.containsKey("swingStatusName") ? map["swingStatusName"] : "";
    isExistVideo = map.containsKey("isExistVideo") ? int.parse(map["isExistVideo"].toString()) : 0;
    isFavorite = map.containsKey("isFavorite") ? int.parse(map["isFavorite"].toString()) : 0;
    memo = (map.containsKey("memo") && map["memo"] != null) ? map["memo"] : null;
    rawData = (map.containsKey("rawData") && map["rawData"] != null) ? map["rawData"] : "";
    swingVideoUrl = (map.containsKey("swingVideoUrl") && map["swingVideoUrl"] != null) ? map["swingVideoUrl"] : null;

    if (map.containsKey("users")) {
      userSwingDatas = [];
      for (final Map<String, dynamic> rawEntity in map["users"]) {
        final entity = UserSwingDataEntity.fromMap(rawEntity);
        final userSwingData = UserSwingDataEntity();
        userSwingData.userId = entity.userId;
        userSwingData.swingId = entity.swingId;
        userSwingData.ownerId = entity.ownerId;
        userSwingData.userSwingPaintDatas = entity.userSwingPaintDatas;
        userSwingDatas.add(userSwingData);
      }
    }
  }
}
