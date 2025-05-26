import 'dart:math';

import 'package:angles/angles.dart';
import 'package:flutter/material.dart';
import 'package:mtracersdkexample/appdto/paintshapehandle_type.dart';
import 'package:mtracersdkexample/appdto/paintshapehandleinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/paintshapeinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/paintshapelineinfo_appdto.dart';
import 'package:mtracersdkexample/logicinterface/paintshape_logicinterface.dart';
import 'package:tuple_dart/tuple_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:vector_math/vector_math.dart';

import 'Dart:math' as math;

class PaintShapeLineLogic extends PaintShapeLogicInterface {
  @override
  PaintShapeInfoAppDto onDrawStart(final Offset position, final String ownerId) {
    //Updateが発生するまで図形描画を制限するためにfalseをセットする
    //onUpdate側でtrueに変更している
    PaintShapeLineInfoAppDto previewShapeInfo = PaintShapeLineInfoAppDto();
    previewShapeInfo.isValid = false;
    previewShapeInfo.color = previewShapeInfo.colors[1];
    previewShapeInfo.start = position;
    previewShapeInfo.ownerId = ownerId;

    return previewShapeInfo;
  }

  @override
  PaintShapeInfoAppDto onDrawUpdate(final PaintShapeInfoAppDto previewShapeInfo, final Offset position, final Size widgetSize) {
    if ((previewShapeInfo as PaintShapeLineInfoAppDto).start == const Offset(0, 0)) {
      return PaintShapeLineInfoAppDto();
    }

    PaintShapeLineInfoAppDto newPreviewShapeInfo = PaintShapeLineInfoAppDto();
    newPreviewShapeInfo.isValid = true;
    newPreviewShapeInfo.ownerId = previewShapeInfo.ownerId;
    newPreviewShapeInfo.color = previewShapeInfo.color;
    if (isInsideVideoSize(previewShapeInfo.start, widgetSize)) {
      newPreviewShapeInfo.start = position;
    } else {
      newPreviewShapeInfo.start = previewShapeInfo.start;
    }

    //最小の長さ制限
    //ハンドルが同士が重ならない値として最短の長さを160に設定
    final x = position.dx;
    final y = position.dy;
    final a = newPreviewShapeInfo.start.dx;
    final b = newPreviewShapeInfo.start.dy;
    const r = 160;

    if ((x - a) * (x - a) + (y - b) * (y - b) <= (r * r)) {
      var angle = ((math.atan2(y - b, x - a)) * 180 / math.pi) + 90;
      final minX = a + r * Angle.degrees(angle.toDouble()).sin;
      final minY = b - r * Angle.degrees(angle.toDouble()).cos;

      if (isInsideVideoSize(Offset(minX, minY), widgetSize)) {
        if (previewShapeInfo.end == const Offset(0, 0)) {
          newPreviewShapeInfo.isValid = false;
        } else {
          newPreviewShapeInfo.end = previewShapeInfo.end;
        }
      } else {
        newPreviewShapeInfo.end = Offset(minX, minY);
      }
    } else {
      newPreviewShapeInfo.end = position;
    }

    return newPreviewShapeInfo;
  }

  @override
  Tuple2<List<PaintShapeInfoAppDto>, PaintShapeInfoAppDto> onDrawEnd(final List<PaintShapeInfoAppDto> paintShapeInfo, final PaintShapeInfoAppDto previewShapeInfo, final Offset position) {
    List<PaintShapeInfoAppDto> newPaintShapeList = [];
    newPaintShapeList.addAll(paintShapeInfo);

    // 画面を連打した際にonPanUpdateを経由せず終点が0の場合のケア
    if ((previewShapeInfo as PaintShapeLineInfoAppDto).end == const Offset(0, 0)) {
      final previewShapeNewInfo = PaintShapeInfoAppDto()..isValid = false;

      return Tuple2(newPaintShapeList, previewShapeNewInfo);
    }

    // 始点と終点の誤差が小さい場合、直線を水平にする
    final difference = previewShapeInfo.start.dy - previewShapeInfo.end.dy;
    var end = previewShapeInfo.end;
    if (difference.abs() < 20) {
      end = Offset(previewShapeInfo.end.dx, previewShapeInfo.start.dy);
    }

    var newPaintShapeInfo = PaintShapeLineInfoAppDto();
    newPaintShapeInfo.isValid = true;
    newPaintShapeInfo.ownerId = previewShapeInfo.ownerId;
    newPaintShapeInfo.color = previewShapeInfo.color;
    newPaintShapeInfo.paintId = const Uuid().v4();
    newPaintShapeInfo.isRegistered = true;
    newPaintShapeInfo.isUpdated = false;
    newPaintShapeInfo.isDeleted = false;
    newPaintShapeInfo.start = previewShapeInfo.start;
    newPaintShapeInfo.end = end;

    int displayOrder = 0;
    if (newPaintShapeList.isNotEmpty) {
      displayOrder = newPaintShapeList.first.displayOrder;
      for (var element in newPaintShapeList) {
        if (element.displayOrder > displayOrder) {
          displayOrder = element.displayOrder;
        }
      }
    }
    newPaintShapeInfo.displayOrder = displayOrder + 1;

    newPaintShapeList.add(newPaintShapeInfo);

    var newPreviewShapeInfo = PaintShapeLineInfoAppDto();
    newPreviewShapeInfo.isValid = false;

    return Tuple2(newPaintShapeList, newPreviewShapeInfo);
  }

  @override
  List<PaintShapeHandleInfoAppDto> getHandlePositionInfo(final PaintShapeInfoAppDto targetShapeInfo) {
    List<PaintShapeHandleInfoAppDto> handleInfo = [];

    //支点用ハンドルの座標
    var startHandleInfo = PaintShapeHandleInfoAppDto();
    startHandleInfo.position = Offset((targetShapeInfo as PaintShapeLineInfoAppDto).start.dx, targetShapeInfo.start.dy);
    startHandleInfo.handleType = PaintShapeHandleType.resizeFirst;
    handleInfo.add(startHandleInfo);

    //終点用ハンドルの座標
    var endHandleInfo = PaintShapeHandleInfoAppDto();
    endHandleInfo.position = Offset(targetShapeInfo.end.dx, targetShapeInfo.end.dy);
    endHandleInfo.handleType = PaintShapeHandleType.resizeEnd;
    handleInfo.add(endHandleInfo);

    return handleInfo;
  }

  @override
  Tuple2<PaintShapeHandleType, List<PaintShapeInfoAppDto>> onEditStart(final Offset position, final PaintShapeInfoAppDto targetShapeInfo) {
    final x = position.dx;
    final y = position.dy;
    // ハンドルサイズ(半径36)の倍の数値に設定する（倍が違和感なく操作できる値）
    var r = 72;

    //始点操作の場合は移動＋サイズ変更を開始する
    {
      final a = (targetShapeInfo as PaintShapeLineInfoAppDto).start.dx;
      final b = targetShapeInfo.start.dy;
      if ((x - a) * (x - a) + (y - b) * (y - b) <= (r * r)) {
        var newTargetShapeInfo = PaintShapeLineInfoAppDto();
        newTargetShapeInfo.isValid = true;
        newTargetShapeInfo.color = newTargetShapeInfo.colors[0];
        newTargetShapeInfo.paintId = targetShapeInfo.paintId;
        newTargetShapeInfo.ownerId = targetShapeInfo.ownerId;
        newTargetShapeInfo.swingId = targetShapeInfo.swingId;
        newTargetShapeInfo.displayOrder = targetShapeInfo.displayOrder;
        newTargetShapeInfo.isRegistered = targetShapeInfo.isRegistered;
        newTargetShapeInfo.isUpdated = targetShapeInfo.isUpdated;
        newTargetShapeInfo.isDeleted = targetShapeInfo.isDeleted;
        newTargetShapeInfo.start = targetShapeInfo.start;
        newTargetShapeInfo.end = targetShapeInfo.end;

        var newPreviewShapeInfo = PaintShapeLineInfoAppDto();
        newPreviewShapeInfo.isValid = true;
        newPreviewShapeInfo.color = targetShapeInfo.color;
        newPreviewShapeInfo.start = targetShapeInfo.start;
        newPreviewShapeInfo.end = targetShapeInfo.end;

        return Tuple2(PaintShapeHandleType.resizeFirst, [newTargetShapeInfo, newPreviewShapeInfo]);
      }
    }

    //終点操作の場合は移動＋サイズ変更を開始する
    {
      final a = targetShapeInfo.end.dx;
      final b = targetShapeInfo.end.dy;
      if ((x - a) * (x - a) + (y - b) * (y - b) <= (r * r)) {
        var newTargetShapeInfo = PaintShapeLineInfoAppDto();
        newTargetShapeInfo.isValid = true;
        newTargetShapeInfo.color = newTargetShapeInfo.colors[0];
        newTargetShapeInfo.paintId = targetShapeInfo.paintId;
        newTargetShapeInfo.ownerId = targetShapeInfo.ownerId;
        newTargetShapeInfo.swingId = targetShapeInfo.swingId;
        newTargetShapeInfo.displayOrder = targetShapeInfo.displayOrder;
        newTargetShapeInfo.isRegistered = targetShapeInfo.isRegistered;
        newTargetShapeInfo.isUpdated = targetShapeInfo.isUpdated;
        newTargetShapeInfo.isDeleted = targetShapeInfo.isDeleted;
        newTargetShapeInfo.start = targetShapeInfo.start;
        newTargetShapeInfo.end = targetShapeInfo.end;

        var newPreviewShapeInfo = PaintShapeLineInfoAppDto();
        newPreviewShapeInfo.isValid = true;
        newPreviewShapeInfo.color = targetShapeInfo.color;
        newPreviewShapeInfo.start = targetShapeInfo.start;
        newPreviewShapeInfo.end = targetShapeInfo.end;

        return Tuple2(PaintShapeHandleType.resizeEnd, [newTargetShapeInfo, newPreviewShapeInfo]);
      }
    }

    {
      // タップした地点からの半径を設定
      // 当たり判定の範囲は半径で調節する
      double radius = 60;

      double pointX = position.dx;
      double pointY = position.dy;
      double startX = targetShapeInfo.start.dx;
      double startY = targetShapeInfo.start.dy;
      double endX = targetShapeInfo.end.dx;
      double endY = targetShapeInfo.end.dy;

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
      // 射影の長さが半径よりも小さい
      if (distanceProjection.abs() < radius) {
        // ④．線分内に円があるかを調べる
        // 始点 => 終点と始点 => 円の中心の内積を計算する
        double dot01 = start2Center.x * start2End.x + start2Center.y * start2End.y;
        // 始点 => 終点と終点 => 円の中心の内積を計算する
        double dot02 = end2Center.x * start2End.x + end2Center.y * start2End.y;

        // 二つの内積の掛け算結果が0以下なら当たり
        if (dot01 * dot02 <= 0.0) {
          var newTargetShapeInfo = PaintShapeLineInfoAppDto();
          newTargetShapeInfo.isValid = true;
          newTargetShapeInfo.color = newTargetShapeInfo.colors[0];
          newTargetShapeInfo.paintId = targetShapeInfo.paintId;
          newTargetShapeInfo.ownerId = targetShapeInfo.ownerId;
          newTargetShapeInfo.swingId = targetShapeInfo.swingId;
          newTargetShapeInfo.displayOrder = targetShapeInfo.displayOrder;
          newTargetShapeInfo.isRegistered = targetShapeInfo.isRegistered;
          newTargetShapeInfo.isUpdated = targetShapeInfo.isUpdated;
          newTargetShapeInfo.isDeleted = targetShapeInfo.isDeleted;
          newTargetShapeInfo.start = targetShapeInfo.start;
          newTargetShapeInfo.end = targetShapeInfo.end;

          var newPreviewShapeInfo = PaintShapeLineInfoAppDto();
          newPreviewShapeInfo.isValid = true;
          newPreviewShapeInfo.color = targetShapeInfo.color;
          newPreviewShapeInfo.start = targetShapeInfo.start;
          newPreviewShapeInfo.end = targetShapeInfo.end;

          return Tuple2(PaintShapeHandleType.move, [newTargetShapeInfo, newPreviewShapeInfo]);
          // ⑤．線分の末端が円の範囲内かを調べる
        } else if (_calculationVectorLength(start2Center) < radius || _calculationVectorLength(end2Center) < radius) {
          // 上の条件から漏れた場合、円は線分上にはないので、
          // 始点 => 円の中心の長さか、終点 => 円の中心の長さが
          // 円の半径よりも短かったら当たり
          var newTargetShapeInfo = PaintShapeLineInfoAppDto();
          newTargetShapeInfo.isValid = true;
          newTargetShapeInfo.color = newTargetShapeInfo.colors[0];
          newTargetShapeInfo.paintId = targetShapeInfo.paintId;
          newTargetShapeInfo.ownerId = targetShapeInfo.ownerId;
          newTargetShapeInfo.swingId = targetShapeInfo.swingId;
          newTargetShapeInfo.displayOrder = targetShapeInfo.displayOrder;
          newTargetShapeInfo.isRegistered = targetShapeInfo.isRegistered;
          newTargetShapeInfo.isUpdated = targetShapeInfo.isUpdated;
          newTargetShapeInfo.isDeleted = targetShapeInfo.isDeleted;
          newTargetShapeInfo.start = targetShapeInfo.start;
          newTargetShapeInfo.end = targetShapeInfo.end;

          var newPreviewShapeInfo = PaintShapeLineInfoAppDto();
          newPreviewShapeInfo.isValid = true;
          newPreviewShapeInfo.color = targetShapeInfo.color;
          newPreviewShapeInfo.start = targetShapeInfo.start;
          newPreviewShapeInfo.end = targetShapeInfo.end;

          return Tuple2(PaintShapeHandleType.move, [newTargetShapeInfo, newPreviewShapeInfo]);
        }
      }
    }

    return Tuple2(PaintShapeHandleType.none, [PaintShapeInfoAppDto()..isValid = false, PaintShapeInfoAppDto()..isValid = false]);
  }

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

  double _calculationVectorLength(final Vector2 vec01) {
    return sqrt((vec01.x * vec01.x) + (vec01.y * vec01.y));
  }

  @override
  PaintShapeInfoAppDto onEditMoveUpdate(final Offset position, final PaintShapeInfoAppDto previewShapeInfo, final Size widgetSize) {
    final Offset center = Offset(((previewShapeInfo as PaintShapeLineInfoAppDto).start.dx + previewShapeInfo.end.dx) / 2, (previewShapeInfo.start.dy + previewShapeInfo.end.dy) / 2);
    final double centerX = position.dx - center.dx;
    final double centerY = position.dy - center.dy;

    final Offset startPosition = Offset(centerX + previewShapeInfo.start.dx, centerY + previewShapeInfo.start.dy);
    final Offset endPosition = Offset(centerX + previewShapeInfo.end.dx, centerY + previewShapeInfo.end.dy);

    // 図形の移動ハンドルがお絵かき画面外に移動するのを制限
    PaintShapeLineInfoAppDto newPreviewShapeInfo = PaintShapeLineInfoAppDto();
    final dto = getBorderPositions(widgetSize, startPosition, endPosition, previewShapeInfo.start, previewShapeInfo.end);
    newPreviewShapeInfo.start = dto.start;
    newPreviewShapeInfo.end = dto.end;
    newPreviewShapeInfo.ownerId = previewShapeInfo.ownerId;
    newPreviewShapeInfo.isValid = true;
    newPreviewShapeInfo.color = previewShapeInfo.color;

    return newPreviewShapeInfo;
  }

  PaintShapeLineInfoAppDto getBorderPositions(final Size widgetSize, final Offset startPosition, final Offset endPosition, final Offset previewStartPosition, final Offset previewEndPosition) {
    final double startX = startPosition.dx;
    final double startY = startPosition.dy;
    final double endX = endPosition.dx;
    final double endY = endPosition.dy;
    //図形を移動出来るサイズをビデオ動画より一回り小さいサイズに設定する
    const double startWidth = 15; //X軸始点
    const double startHeight = 15; //Y軸始点
    final double endWidth = widgetSize.width - 15; //X軸終点
    final double endHeight = widgetSize.height - 15; //Y軸終点
    final dto = PaintShapeLineInfoAppDto();
    dto.start = startPosition;
    dto.end = endPosition;

    //始点終点共に領域外に出た場合
    if (isInsideVideoSize(startPosition, widgetSize) && isInsideVideoSize(endPosition, widgetSize)) {
      dto.start = Offset(previewStartPosition.dx, previewStartPosition.dy);
      dto.end = Offset(previewEndPosition.dx, previewEndPosition.dy);

      return dto;

      // 始点が領域外に出た場合
    } else if (isInsideVideoSize(startPosition, widgetSize)) {
      //左
      if (startWidth >= startX && startHeight <= startY && endHeight >= startY) {
        dto.start = Offset(startWidth, startPosition.dy);
        dto.end = Offset(previewEndPosition.dx, endPosition.dy);

        return dto;
      }

      //右
      if (endWidth <= startX && startHeight <= startY && endHeight >= startY) {
        dto.start = Offset(endWidth, startPosition.dy);
        dto.end = Offset(previewEndPosition.dx, endPosition.dy);

        return dto;
      }

      //上
      if (startHeight >= startY && startWidth <= startX && endWidth >= startX) {
        dto.start = Offset(startPosition.dx, startHeight);
        dto.end = Offset(endPosition.dx, previewEndPosition.dy);

        return dto;
      }

      //下
      if (endHeight <= startY && startWidth <= startX && endWidth >= startX) {
        dto.start = Offset(startPosition.dx, endHeight);
        dto.end = Offset(endPosition.dx, previewEndPosition.dy);

        return dto;
      }
      dto.start = Offset(previewStartPosition.dx, previewStartPosition.dy);
      dto.end = Offset(previewEndPosition.dx, previewEndPosition.dy);

      return dto;
      // 終点が領域外に出た場合
    } else if (isInsideVideoSize(endPosition, widgetSize)) {
      //左
      if (endWidth >= endX && startHeight <= endY && endHeight >= endY) {
        dto.start = Offset(previewStartPosition.dx, startPosition.dy);
        dto.end = Offset(startWidth, endPosition.dy);

        return dto;
      }

      //右
      if (endWidth <= endX && startHeight <= endY && endHeight >= endY) {
        dto.start = Offset(previewStartPosition.dx, startPosition.dy);
        dto.end = Offset(endWidth, endPosition.dy);

        return dto;
      }

      //上
      if (startHeight >= endY && startWidth <= endX && endWidth >= endX) {
        dto.start = Offset(startPosition.dx, previewStartPosition.dy);
        dto.end = Offset(endPosition.dx, startHeight);

        return dto;
      }

      //下
      if (endHeight <= endY && startWidth <= endX && endWidth >= endX) {
        dto.start = Offset(startPosition.dx, previewStartPosition.dy);
        dto.end = Offset(endPosition.dx, endHeight);

        return dto;
      }
      dto.start = Offset(previewStartPosition.dx, previewStartPosition.dy);
      dto.end = Offset(previewEndPosition.dx, previewEndPosition.dy);

      return dto;
    } else {
      return dto;
    }
  }

  @override
  bool isInsideVideoSize(final Offset position, final Size widgetSize) {
    double x = position.dx;
    double y = position.dy;
    //図形を移動出来るサイズをビデオ動画より一回り小さいサイズに設定する
    double startX = 15;
    double startY = 15;
    double width = widgetSize.width - 15;
    double height = widgetSize.height - 15;

    if (x >= startX && x <= width && y >= startY && y <= height) {
      return false;
    } else {
      return true;
    }
  }

  @override
  PaintShapeInfoAppDto onEditResizeUpdate(final Offset position, final PaintShapeInfoAppDto previewShapeInfo, final Size widgetSize) {
    return PaintShapeInfoAppDto()..isValid = false;
  }

  @override
  PaintShapeInfoAppDto onEditResizeStartUpdate(final Offset position, final PaintShapeInfoAppDto previewShapeInfo, final Size widgetSize) {
    PaintShapeLineInfoAppDto newPreviewShapeInfo = PaintShapeLineInfoAppDto();
    newPreviewShapeInfo.isValid = true;
    newPreviewShapeInfo.ownerId = previewShapeInfo.ownerId;
    newPreviewShapeInfo.color = (previewShapeInfo as PaintShapeLineInfoAppDto).color;
    newPreviewShapeInfo.end = previewShapeInfo.end;

    // 図形の移動ハンドルがお絵かき画面外に移動するのを制限
    if (isInsideVideoSize(position, widgetSize)) {
      final Offset startPosition = getBorderPosition(widgetSize, position, previewShapeInfo.start);
      newPreviewShapeInfo.start = startPosition;
    } else {
      newPreviewShapeInfo.start = position;
    }

    //最小の長さ制限
    //ハンドルが同士が重ならない値として最短の長さを160に設定
    final x = newPreviewShapeInfo.start.dx;
    final y = newPreviewShapeInfo.start.dy;
    final a = newPreviewShapeInfo.end.dx;
    final b = newPreviewShapeInfo.end.dy;
    const r = 160;

    if ((x - a) * (x - a) + (y - b) * (y - b) <= (r * r)) {
      final double angle = ((math.atan2(y - b, x - a)) * 180 / math.pi) + 90;
      final minX = a + r * Angle.degrees(angle.toDouble()).sin;
      final minY = b - r * Angle.degrees(angle.toDouble()).cos;

      if (isInsideVideoSize(Offset(minX, minY), widgetSize)) {
        newPreviewShapeInfo.start = previewShapeInfo.start;
      } else {
        newPreviewShapeInfo.start = Offset(minX, minY);
      }
    }

    return newPreviewShapeInfo;
  }

  @override
  PaintShapeInfoAppDto onEditResizeEndUpdate(final Offset position, final PaintShapeInfoAppDto previewShapeInfo, final Size widgetSize) {
    PaintShapeLineInfoAppDto newPreviewShapeInfo = PaintShapeLineInfoAppDto();
    newPreviewShapeInfo.isValid = true;
    newPreviewShapeInfo.ownerId = previewShapeInfo.ownerId;
    newPreviewShapeInfo.color = (previewShapeInfo as PaintShapeLineInfoAppDto).color;
    newPreviewShapeInfo.start = previewShapeInfo.start;

    // 図形の移動ハンドルがお絵かき画面外に移動するのを制限
    if (isInsideVideoSize(position, widgetSize)) {
      final Offset endPosition = getBorderPosition(widgetSize, position, previewShapeInfo.end);
      newPreviewShapeInfo.end = endPosition;
    } else {
      newPreviewShapeInfo.end = position;
    }

    //最小の長さ制限
    //ハンドルが同士が重ならない値として最短の長さを160に設定
    final x = newPreviewShapeInfo.end.dx;
    final y = newPreviewShapeInfo.end.dy;
    final a = newPreviewShapeInfo.start.dx;
    final b = newPreviewShapeInfo.start.dy;
    const r = 160;

    if ((x - a) * (x - a) + (y - b) * (y - b) <= (r * r)) {
      final double angle = ((math.atan2(y - b, x - a)) * 180 / math.pi) + 90;
      final minX = a + r * Angle.degrees(angle.toDouble()).sin;
      final minY = b - r * Angle.degrees(angle.toDouble()).cos;

      if (isInsideVideoSize(Offset(minX, minY), widgetSize)) {
        newPreviewShapeInfo.end = previewShapeInfo.end;
      } else {
        newPreviewShapeInfo.end = Offset(minX, minY);
      }
    }

    return newPreviewShapeInfo;
  }

  Offset getBorderPosition(final Size widgetSize, final Offset position, final Offset previewPosition) {
    final double x = position.dx;
    final double y = position.dy;
    //図形を移動出来るサイズをビデオ動画より一回り小さいサイズに設定する
    const double startWidth = 15; //X軸始点
    const double startHeight = 15; //Y軸始点
    final double endWidth = widgetSize.width - 15; //X軸終点
    final double endHeight = widgetSize.height - 15; //Y軸終点

    Offset newPosition = Offset(previewPosition.dx, previewPosition.dy);

    //左
    if (startWidth >= x && startHeight <= y && endHeight >= y) {
      newPosition = Offset(startWidth, position.dy);

      return newPosition;
    }

    //右
    if (endWidth <= x && startHeight <= y && endHeight >= y) {
      newPosition = Offset(endWidth, position.dy);

      return newPosition;
    }

    //上
    if (startHeight >= y && startWidth <= x && endWidth >= x) {
      newPosition = Offset(position.dx, startHeight);

      return newPosition;
    }

    //下
    if (endHeight <= y && startWidth <= x && endWidth >= x) {
      newPosition = Offset(position.dx, endHeight);

      return newPosition;
    }

    return newPosition;
  }

  @override
  Tuple2<List<PaintShapeInfoAppDto>, List<PaintShapeInfoAppDto>> onEditEnd(final List<PaintShapeInfoAppDto> paintShapeInfo, final PaintShapeInfoAppDto targetShapeInfo, final PaintShapeInfoAppDto previewShapeInfo, final PaintShapeHandleType handleType) {
    List<PaintShapeInfoAppDto> newPaintShapeList = [];
    newPaintShapeList.addAll(paintShapeInfo);

    final index = newPaintShapeList.lastIndexWhere((shapeInfo) {
      return shapeInfo.paintId == targetShapeInfo.paintId;
    });

    if (index != -1) {
      newPaintShapeList.removeAt(index);

      // 始点と終点の誤差が小さい場合、直線を水平にする
      final difference = (previewShapeInfo as PaintShapeLineInfoAppDto).start.dy - previewShapeInfo.end.dy;
      var start = previewShapeInfo.start;
      var end = previewShapeInfo.end;
      if (difference.abs() < 20) {
        if (handleType == PaintShapeHandleType.resizeFirst) {
          start = Offset(previewShapeInfo.start.dx, previewShapeInfo.end.dy);
        } else if (handleType == PaintShapeHandleType.resizeEnd) {
          end = Offset(previewShapeInfo.end.dx, previewShapeInfo.start.dy);
        } else {}
      }

      var newPaintShapeInfo = PaintShapeLineInfoAppDto();
      newPaintShapeInfo.isValid = true;
      newPaintShapeInfo.ownerId = targetShapeInfo.ownerId;
      newPaintShapeInfo.color = previewShapeInfo.color;
      newPaintShapeInfo.paintId = targetShapeInfo.paintId;
      newPaintShapeInfo.userId = targetShapeInfo.userId;
      newPaintShapeInfo.swingId = targetShapeInfo.swingId;
      newPaintShapeInfo.displayOrder = targetShapeInfo.displayOrder;
      newPaintShapeInfo.isRegistered = targetShapeInfo.isRegistered;
      newPaintShapeInfo.isUpdated = true;
      newPaintShapeInfo.isDeleted = targetShapeInfo.isDeleted;
      newPaintShapeInfo.start = start;
      newPaintShapeInfo.end = end;

      int displayOrder = 0;
      if (newPaintShapeList.isNotEmpty) {
        displayOrder = newPaintShapeList.first.displayOrder;
        for (var element in newPaintShapeList) {
          if (element.displayOrder > displayOrder) {
            displayOrder = element.displayOrder;
          }
        }
      }
      newPaintShapeInfo.displayOrder = displayOrder + 1;

      newPaintShapeList.add(newPaintShapeInfo);
    }

    var newTargetShapeInfo = PaintShapeLineInfoAppDto();
    newTargetShapeInfo.isValid = false;

    var newPreviewShapeInfo = PaintShapeLineInfoAppDto();
    newPreviewShapeInfo.isValid = false;

    return Tuple2(newPaintShapeList, [newTargetShapeInfo, newPreviewShapeInfo]);
  }

  @override
  List<PaintShapeInfoAppDto> onDelete(final List<PaintShapeInfoAppDto> paintShapeInfo, final PaintShapeInfoAppDto targetShapeInfo) {
    List<PaintShapeInfoAppDto> newPaintShapeList = [];
    newPaintShapeList.addAll(paintShapeInfo);

    //変更後の図形で更新する
    final index = newPaintShapeList.lastIndexWhere((shapeInfo) {
      return shapeInfo.paintId == targetShapeInfo.paintId;
    });
    if (index != -1) {
      newPaintShapeList.removeAt(index);
      targetShapeInfo.isValid = false;
      targetShapeInfo.isDeleted = true;
      newPaintShapeList.add(targetShapeInfo);
    }

    return newPaintShapeList;
  }

  @override
  List<PaintShapeInfoAppDto> onDeleteAll(final List<PaintShapeInfoAppDto> paintShapeInfo) {
    List<PaintShapeInfoAppDto> newPaintShapeList = [];
    for (var shapeInfo in paintShapeInfo) {
      shapeInfo.isValid = false;
      shapeInfo.isDeleted = true;
      newPaintShapeList.add(shapeInfo);
    }

    return newPaintShapeList;
  }

  @override
  List<PaintShapeInfoAppDto> onChangeColor(final List<PaintShapeInfoAppDto> paintShapeInfo, final PaintShapeInfoAppDto targetShapeInfo) {
    List<PaintShapeInfoAppDto> newPaintShapeList = [];
    newPaintShapeList.addAll(paintShapeInfo);

    final index = newPaintShapeList.lastIndexWhere((shapeInfo) {
      return shapeInfo.paintId == targetShapeInfo.paintId;
    });
    if (index != -1) {
      newPaintShapeList.removeAt(index);

      targetShapeInfo.isUpdated = true;

      final colorIndex = targetShapeInfo.colors.indexWhere((color) {
        return color == (targetShapeInfo as PaintShapeLineInfoAppDto).color;
      });

      if (colorIndex >= targetShapeInfo.colors.length - 1) {
        (targetShapeInfo as PaintShapeLineInfoAppDto).color = targetShapeInfo.colors[1];
      } else {
        (targetShapeInfo as PaintShapeLineInfoAppDto).color = targetShapeInfo.colors[colorIndex + 1];
      }

      int displayOrder = 0;
      if (newPaintShapeList.isNotEmpty) {
        displayOrder = newPaintShapeList.first.displayOrder;
        for (var element in newPaintShapeList) {
          if (element.displayOrder > displayOrder) {
            displayOrder = element.displayOrder;
          }
        }
      }
      targetShapeInfo.displayOrder = displayOrder + 1;

      newPaintShapeList.add(targetShapeInfo);
    }

    return newPaintShapeList;
  }
}
