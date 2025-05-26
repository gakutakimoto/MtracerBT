import 'package:flutter/material.dart';
import 'package:mtracersdkexample/appdto/paintshapeangle_type.dart';
import 'package:mtracersdkexample/appdto/paintshapeangleinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/paintshapeinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/paintshapelineinfo_appdto.dart';

import 'Dart:math' as math;
import 'package:mtracersdkexample/logicinterface/paintshapeangle_logicinterface.dart';

class PaintShapeAngleLogic extends PaintShapeAngleLogicInterface {
  @override
  List<PaintShapeAngleInfoAppDto> detectCrossLine(final List<PaintShapeInfoAppDto> shapeInfo) {
    // 直線だけ抽出
    final lineShapeList = shapeInfo.where((shapeInfo) {
      return (shapeInfo is PaintShapeLineInfoAppDto && !shapeInfo.isDeleted);
    }).toList();

    // 直線のなかから水平の線だけ抽出
    final horizontalLineList = lineShapeList.where((shapeInfo) {
      return (shapeInfo as PaintShapeLineInfoAppDto).start.dy == (shapeInfo).end.dy;
    }).toList();

    List<PaintShapeAngleInfoAppDto> shapeAngleInfoAppDtoList = [];
    for (var horizontalLine in horizontalLineList) {
      final dtoList = getCrossOverLine(horizontalLine, lineShapeList);
      if (dtoList.isNotEmpty) {
        for (var list in dtoList) {
          shapeAngleInfoAppDtoList.add(list);
        }
      }
    }

    return shapeAngleInfoAppDtoList;
  }

  List<PaintShapeAngleInfoAppDto> getCrossOverLine(final PaintShapeInfoAppDto horizontalLine, final List<PaintShapeInfoAppDto> lineShapeList) {
    final ax = (horizontalLine as PaintShapeLineInfoAppDto).start.dx;
    final ay = (horizontalLine).start.dy;
    final bx = (horizontalLine).end.dx;
    final by = (horizontalLine).end.dy;

    List<PaintShapeAngleInfoAppDto> dtoList = [];

    for (var shapeInfo in lineShapeList) {
      final cx = (shapeInfo as PaintShapeLineInfoAppDto).start.dx;
      final cy = (shapeInfo).start.dy;
      final dx = (shapeInfo).end.dx;
      final dy = (shapeInfo).end.dy;

      final ta = (cx - dx) * (ay - cy) + (cy - dy) * (cx - ax);
      final tb = (cx - dx) * (by - cy) + (cy - dy) * (cx - bx);
      final tc = (ax - bx) * (cy - ay) + (ay - by) * (ax - cx);
      final td = (ax - bx) * (dy - ay) + (ay - by) * (ax - dx);

      if (tc * td < 0 && ta * tb < 0) {
        var shapeAngleInfo = PaintShapeAngleInfoAppDto();
        shapeAngleInfo.startHorizontal = Offset(ax, ay);
        shapeAngleInfo.endHorizontal = Offset(bx, by);
        shapeAngleInfo.startCross = Offset(cx, cy);
        shapeAngleInfo.endCross = Offset(dx, dy);
        shapeAngleInfo.intersection = _getIntersection(shapeAngleInfo);
        shapeAngleInfo.radian = _getRadianAngle(shapeAngleInfo);
        shapeAngleInfo.angleType = _getAngleDirection(shapeAngleInfo);

        dtoList.add(shapeAngleInfo);
      }
    }

    return dtoList;
  }

  Offset _getIntersection(final PaintShapeAngleInfoAppDto shapeAngleInfo) {
    final ax = shapeAngleInfo.startHorizontal.dx;
    final ay = shapeAngleInfo.startHorizontal.dy;
    final bx = shapeAngleInfo.endHorizontal.dx;
    final by = shapeAngleInfo.endHorizontal.dy;
    final cx = shapeAngleInfo.startCross.dx;
    final cy = shapeAngleInfo.startCross.dy;
    final dx = shapeAngleInfo.endCross.dx;
    final dy = shapeAngleInfo.endCross.dy;

    final d = (bx - ax) * (dy - cy) - (by - ay) * (dx - cx);
    final u = ((cx - ax) * (dy - cy) - (cy - ay) * (dx - cx)) / d;

    return Offset((ax + u * (bx - ax)), (ay + u * (by - ay)));
  }

  double _getRadianAngle(final PaintShapeAngleInfoAppDto shapeAngleInfo) {
    final ax = shapeAngleInfo.endHorizontal.dx - shapeAngleInfo.startHorizontal.dx;
    final ay = shapeAngleInfo.endHorizontal.dy - shapeAngleInfo.startHorizontal.dy;
    final bx = shapeAngleInfo.endCross.dx - shapeAngleInfo.startCross.dx;
    final by = shapeAngleInfo.endCross.dy - shapeAngleInfo.startCross.dy;

    return math.acos((ax * bx + ay * by) / (math.sqrt(ax * ax + ay * ay) * math.sqrt(bx * bx + by * by)));
  }

  PaintShapeAngleType _getAngleDirection(final PaintShapeAngleInfoAppDto shapeAngleInfo) {
    PaintShapeAngleType angleType = PaintShapeAngleType.left;

    // 水平線を左から右に描いた場合
    if (shapeAngleInfo.startHorizontal.dx < shapeAngleInfo.endHorizontal.dx) {
      if (shapeAngleInfo.startCross.dy > shapeAngleInfo.endCross.dy) {
        angleType = PaintShapeAngleType.right;
      } else {
        angleType = PaintShapeAngleType.left;
      }
    } else {
      if (shapeAngleInfo.startCross.dy > shapeAngleInfo.endCross.dy) {
        angleType = PaintShapeAngleType.left;
      } else {
        angleType = PaintShapeAngleType.right;
      }
    }

    return angleType;
  }
}
