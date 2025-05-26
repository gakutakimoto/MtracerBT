import 'package:mtracersdkexample/entity/swingheaderindexesdata_entity.dart';

class SwingHeaderDataEntity {
  late String swingId;
  late String swingStatusId;
  late String swingStatusName;
  late int isExistVideo;
  late int isFavorite;
  late String? memo;
  late SwingHeaderIndexesDataEntity swingHeaderIndexesData;

  SwingHeaderDataEntity() {
    swingId = "";
    swingStatusId = "";
    swingStatusName = "";
    isExistVideo = 0;
    isFavorite = 0;
    memo = null;
    swingHeaderIndexesData = SwingHeaderIndexesDataEntity();
  }

  SwingHeaderDataEntity.fromMap(final Map<String, dynamic> map) {
    swingId = map.containsKey("swingId") ? map["swingId"] : "";
    swingStatusId = map.containsKey("swingStatusId") ? map["swingStatusId"] : "";
    swingStatusName = map.containsKey("swingStatusName") ? map["swingStatusName"] : "";
    isExistVideo = map.containsKey("isExistVideo") ? int.parse(map["isExistVideo"].toString()) : 0;
    isFavorite = map.containsKey("isFavorite") ? int.parse(map["isFavorite"].toString()) : 0;
    memo = (map.containsKey("memo") && map["memo"] != null) ? map["memo"] : null;

    if (map.containsKey("indexes")) {
      swingHeaderIndexesData = SwingHeaderIndexesDataEntity.fromMap(map["indexes"]);
    }
  }
}
