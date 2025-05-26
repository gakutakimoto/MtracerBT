import 'package:mtracersdkexample/logicinterface/equation_logicinterface.dart';
import 'dart:math';

class EquationLogic extends EquationLogicInterface {
  @override
  double rotateAngleLineX(final double lineLength, final double angle, final double originX) {
    //回転の公式
    //x=線の長さ*cos((角度) x (π) ÷ 180)+原点x
    return lineLength * cos(angle * pi / 180) + originX;
  }

  @override
  double rotateAngleLineY(final double lineLength, final double angle, final double originY) {
    //回転の公式
    //y=線の長さ*sin(角度) x (π) ÷ 180)+原点y
    return lineLength * sin(angle * pi / 180) + originY;
  }
}
