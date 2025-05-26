import 'paintcircledata_entity.dart';
import 'paintlinedata_entity.dart';

class UserSwingPaintDataEntity {
  late String userId;
  late String swingId;
  late String paintId;
  late int shapeType;
  late String paintStatusId;
  late String paintStatusName;
  late int displayOrder;

  late PaintCircleDataEntity? paintCircleData;
  late PaintLineDataEntity? paintLineData;

  UserSwingPaintDataEntity() {
    userId = "";
    swingId = "";
    paintId = "";
    shapeType = 0;
    paintStatusId = "";
    paintStatusName = "";
    displayOrder = 0;

    paintCircleData = PaintCircleDataEntity();
    paintLineData = PaintLineDataEntity();
  }

  UserSwingPaintDataEntity.fromMap(final Map<String, dynamic> map) {
    userId = map.containsKey("userId") ? map["userId"] : "";
    swingId = map.containsKey("swingId") ? map["swingId"] : "";
    paintId = map.containsKey("paintId") ? map["paintId"] : "";
    shapeType = map.containsKey("shapeType") ? int.parse(map["shapeType"].toString()) : 0;
    paintStatusId = map.containsKey("paintStatusId") ? map["paintStatusId"] : "";
    paintStatusName = map.containsKey("paintStatusName") ? map["paintStatusName"] : "";
    displayOrder = map.containsKey("displayOrder") ? int.parse(map["displayOrder"].toString()) : 0;

    paintCircleData = PaintCircleDataEntity();
    paintLineData = PaintLineDataEntity();

    switch (shapeType) {
      case 0:
        paintCircleData = PaintCircleDataEntity.fromMap(map);
        break;
      case 1:
        paintLineData = PaintLineDataEntity.fromMap(map);
        break;
      default:
        break;
    }
  }
}
