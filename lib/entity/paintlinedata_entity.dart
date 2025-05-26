class PaintLineDataEntity {
  late double startX;
  late double startY;
  late double endX;
  late double endY;
  late String color;

  PaintLineDataEntity() {
    startX = 0.0;
    startY = 0.0;
    endX = 0.0;
    endY = 0.0;
    color = "";
  }

  PaintLineDataEntity.fromMap(final Map<String, dynamic> map) {
    startX = map.containsKey("lineStartX") ? double.parse(map["lineStartX"].toString()) : 0.0;
    startY = map.containsKey("lineStartY") ? double.parse(map["lineStartY"].toString()) : 0.0;
    endX = map.containsKey("lineEndX") ? double.parse(map["lineEndX"].toString()) : 0.0;
    endY = map.containsKey("lineEndY") ? double.parse(map["lineEndY"].toString()) : 0.0;
    color = map.containsKey("lineColor") ? map["lineColor"] : "";
  }
}
