import 'package:flutter/material.dart';

import 'paintshapeangle_type.dart';

class PaintShapeAngleInfoAppDto {
  late Offset startHorizontal;
  late Offset endHorizontal;
  late Offset startCross;
  late Offset endCross;
  late Offset intersection;
  late double radian;
  late PaintShapeAngleType angleType;

  PaintShapeAngleInfoAppDto() {
    startHorizontal = const Offset(0, 0);
    endHorizontal = const Offset(0, 0);
    startCross = const Offset(0, 0);
    endCross = const Offset(0, 0);
    intersection = const Offset(0, 0);
    radian = 0;
    angleType = PaintShapeAngleType.left;
  }
}
