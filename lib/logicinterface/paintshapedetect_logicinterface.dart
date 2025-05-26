import 'package:flutter/material.dart';
import 'package:mtracersdkexample/appdto/paintshapeinfo_appdto.dart';

abstract class PaintShapeDetectLogicInterface {
  PaintShapeInfoAppDto detect(final List<PaintShapeInfoAppDto> shapeInfo, final Offset position);
}
