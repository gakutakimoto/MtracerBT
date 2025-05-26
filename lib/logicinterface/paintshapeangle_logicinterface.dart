import 'package:mtracersdkexample/appdto/paintshapeangleinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/paintshapeinfo_appdto.dart';

abstract class PaintShapeAngleLogicInterface {
  List<PaintShapeAngleInfoAppDto> detectCrossLine(final List<PaintShapeInfoAppDto> shapeInfo);
}
