import 'package:flutter/material.dart';

import 'paintshapehandle_type.dart';

class PaintShapeHandleInfoAppDto {
  late Offset position;
  late PaintShapeHandleType handleType;

  PaintShapeHandleInfoAppDto() {
    position = const Offset(0, 0);
    handleType = PaintShapeHandleType.none;
  }
}
