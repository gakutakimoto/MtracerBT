import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mtracersdkexample/appdto/paintshapecircleinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/paintshapeinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/paintshapelineinfo_appdto.dart';
import 'package:mtracersdkexample/logicinterface/paintshapedetect_logicinterface.dart';
import 'package:vector_math/vector_math.dart';

class PaintShapeDetectLogic extends PaintShapeDetectLogicInterface {
  @override
  PaintShapeInfoAppDto detect(final List<PaintShapeInfoAppDto> shapeInfo, final Offset position) {
    final shape = shapeInfo.lastWhere((shapeInfo) {
      if (shapeInfo.isValid) {
        if (shapeInfo is PaintShapeCircleInfoAppDto) {
          return isDetectCircle(shapeInfo, position);
        } else if (shapeInfo is PaintShapeLineInfoAppDto) {
          return isDetectLine(shapeInfo, position);
        } else {
          return false;
        }
      } else {
        return false;
      }
    }, orElse: () {
      return PaintShapeInfoAppDto()..isValid = false;
    });

    return shape;
  }

  bool isDetectCircle(final PaintShapeCircleInfoAppDto shapeInfo, final Offset position) {
    final x = position.dx;
    final y = position.dy;
    final a = shapeInfo.center.dx;
    final b = shapeInfo.center.dy;
    final r = shapeInfo.radius * 1;

    return ((x - a) * (x - a) + (y - b) * (y - b) <= (r * r));
  }

  ///
  /// https://yttm-work.jp/collision/collision_0006.html
  ///
  bool isDetectLine(final PaintShapeLineInfoAppDto shapeInfo, final Offset position) {
    // タップした地点からの半径を設定
    // 当たり判定の範囲は半径で調節する
    double radius = 60;

    double pointX = position.dx;
    double pointY = position.dy;
    double startX = shapeInfo.start.dx;
    double startY = shapeInfo.start.dy;
    double endX = shapeInfo.end.dx;
    double endY = shapeInfo.end.dy;

    // ①．必要なベクトルを用意する
    // 線分の始点から円の中心
    Vector2 start2Center = Vector2(pointX - startX, pointY - startY);
    // 線分の終点から円の中心
    Vector2 end2Center = Vector2(pointX - endX, pointY - endY);
    // 線分の始点から終点
    Vector2 start2End = Vector2(endX - startX, endY - startY);
    // ②．線分と円の中心の最短の長さを求める
    // 線分の始点から終点のベクトルを単位化する
    Vector2 normalStart2End = _convertToNormalizeVector(start2End);
    double distanceProjection = start2Center.x * normalStart2End.y - normalStart2End.x * start2Center.y;

    // ③．②の長さと円の長さの比較をする
    // 射影の長さが半径よりも小さい場合
    if (distanceProjection.abs() < radius) {
      // ④．線分内に円があるかを調べる
      // 始点 => 終点と始点 => 円の中心の内積を計算する
      double dot01 = start2Center.x * start2End.x + start2Center.y * start2End.y;
      // 始点 => 終点と終点 => 円の中心の内積を計算する
      double dot02 = end2Center.x * start2End.x + end2Center.y * start2End.y;

      // 二つの内積の掛け算結果が0以下なら当たり
      if (dot01 * dot02 <= 0.0) {
        return true;

        // ⑤．線分の末端が円の範囲内かを調べる
      } else if (calculationVectorLength(start2Center) < radius || calculationVectorLength(end2Center) < radius) {
        // 上の条件から漏れた場合、円は線分上にはないので、
        // 始点 => 円の中心の長さか、終点 => 円の中心の長さが
        // 円の半径よりも短かったら当たり
        return true;
      }
    }
    return false;
  }

  ///
  /// 単位ベクトル化
  ///
  Vector2 _convertToNormalizeVector(final Vector2 inVal) {
    Vector2 outVal = Vector2(0, 0);
    double distance = sqrt((inVal.x * inVal.x) + (inVal.y * inVal.y));
    if (distance > 0.0) {
      outVal.x = inVal.x / distance;
      outVal.y = inVal.y / distance;
    } else {
      outVal = Vector2(0.0, 0.0);
    }
    return outVal;
  }

  double calculationVectorLength(final Vector2 vec01) {
    return sqrt((vec01.x * vec01.x) + (vec01.y * vec01.y));
  }
}
