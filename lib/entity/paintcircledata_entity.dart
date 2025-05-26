class PaintCircleDataEntity {
  late double centerX;
  late double centerY;
  late double radius;
  late String color;

  PaintCircleDataEntity() {
    centerX = 0.0;
    centerY = 0.0;
    radius = 0.0;
    color = "";
  }

  PaintCircleDataEntity.fromMap(final Map<String, dynamic> map) {
    centerX = map.containsKey("circleCenterX") ? double.parse(map["circleCenterX"].toString()) : 0.0;
    centerY = map.containsKey("circleCenterY") ? double.parse(map["circleCenterY"].toString()) : 0.0;
    radius = map.containsKey("circleRadius") ? double.parse(map["circleRadius"].toString()) : 0.0;
    color = map.containsKey("circleColor") ? map["circleColor"] : "";
  }
}
