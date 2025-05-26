// import 'paintcircledata_entity.dart';
// import 'paintlinedata_entity.dart';

// class SwingPaintShapeDataEntity {
//   late String paintId;
//   late int shapeType;
//   late int displayOrder;

//   late PaintCircleDataEntity? paintCircleData;
//   late PaintLineDataEntity? paintLineData;

//   SwingPaintShapeDataEntity() {
//     paintId = "";
//     shapeType = 0;
//     displayOrder = 0;

//     paintCircleData = PaintCircleDataEntity();
//     paintLineData = PaintLineDataEntity();
//   }

//   SwingPaintShapeDataEntity.fromMap(final Map<String, dynamic> map) {
//     paintId = map.containsKey("paintId") ? map["paintId"] : "";
//     shapeType = map.containsKey("shapeType") ? int.parse(map["shapeType"].toString()) : 0;
//     displayOrder = map.containsKey("displayOrder") ? int.parse(map["displayOrder"].toString()) : 0;

//     paintCircleData = PaintCircleDataEntity();
//     paintLineData = PaintLineDataEntity();

//     switch (shapeType) {
//       case 0:
//         paintCircleData = PaintCircleDataEntity.fromMap(map);
//         break;
//       case 1:
//         paintLineData = PaintLineDataEntity.fromMap(map);
//         break;
//       default:
//         break;
//     }
//   }
// }
