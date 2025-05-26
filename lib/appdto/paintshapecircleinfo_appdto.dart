import 'package:flutter/material.dart';

import 'paintshapeinfo_appdto.dart';

class PaintShapeCircleInfoAppDto extends PaintShapeInfoAppDto {
  late Offset center;
  late double radius;
  late int color;

  PaintShapeCircleInfoAppDto() {
    center = const Offset(0, 0);
    radius = 0;
    color = 0xFF9E9E9E;
  }
}
