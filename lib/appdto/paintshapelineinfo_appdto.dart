import 'package:flutter/material.dart';
import 'package:mtracersdkexample/appdto/paintshapeinfo_appdto.dart';

class PaintShapeLineInfoAppDto extends PaintShapeInfoAppDto {
  late Offset start;
  late Offset end;
  late int color;

  PaintShapeLineInfoAppDto() {
    start = const Offset(0, 0);
    end = const Offset(0, 0);
    color = 0xFF9E9E9E;
  }
}
