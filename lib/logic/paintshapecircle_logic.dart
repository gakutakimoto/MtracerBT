import 'dart:math';

import 'package:angles/angles.dart';
import 'package:flutter/material.dart';
import 'package:mtracersdkexample/appdto/paintshapecircleinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/paintshapehandle_type.dart';
import 'package:mtracersdkexample/appdto/paintshapehandleinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/paintshapeinfo_appdto.dart';
import 'package:mtracersdkexample/logicinterface/paintshape_logicinterface.dart';
import 'package:tuple_dart/tuple_dart.dart';
import 'package:uuid/uuid.dart';

class PaintShapeCircleLogic extends PaintShapeLogicInterface {
  @override
  PaintShapeInfoAppDto onDrawStart(final Offset position, final String ownerId) {
    //Updateが発生するまで図形描画を制限するためにfalseをセットする
    //onUpdate側でtrueに変更している
    PaintShapeCircleInfoAppDto previewShapeInfo = PaintShapeCircleInfoAppDto();
    previewShapeInfo.isValid = false;
    previewShapeInfo.color = previewShapeInfo.colors[1];
    previewShapeInfo.center = position;
    previewShapeInfo.radius = 0;
    previewShapeInfo.ownerId = ownerId;

    return previewShapeInfo;
  }

  @override
  PaintShapeInfoAppDto onDrawUpdate(final PaintShapeInfoAppDto previewShapeInfo, final Offset position, final Size widgetSize) {
    if ((previewShapeInfo as PaintShapeCircleInfoAppDto).center == const Offset(0, 0)) {
      return PaintShapeCircleInfoAppDto();
    }

    final x = position.dx;
    final y = position.dy;
    double a = previewShapeInfo.center.dx;
    double b = previewShapeInfo.center.dy;

    if (isInsideVideoSize(previewShapeInfo.center, widgetSize)) {
      a = position.dx;
      b = position.dy;
    }

    double radius = sqrt((x - a) * (x - a) + (y - b) * (y - b));

    //最小半径の制限
    //ハンドルが同士が重ならない値として80を設定
    if (radius <= 60) {
      radius = 60;
    }

    bool isInside = false;
    for (int i = 0; i < 360; i += 90) {
      var x = previewShapeInfo.center.dx + radius * Angle.degrees(i.toDouble()).sin;
      var y = previewShapeInfo.center.dy - radius * Angle.degrees(i.toDouble()).cos;

      if (isInsideVideoSize(Offset(x, y), widgetSize)) {
        isInside = true;
        break;
      }
    }

    var newPreviewShapeInfo = PaintShapeCircleInfoAppDto();
    newPreviewShapeInfo.isValid = isInside ? false : true;
    newPreviewShapeInfo.ownerId = previewShapeInfo.ownerId;
    newPreviewShapeInfo.color = previewShapeInfo.color;
    newPreviewShapeInfo.center = previewShapeInfo.center;
    newPreviewShapeInfo.radius = radius;

    return newPreviewShapeInfo;
  }

  @override
  Tuple2<List<PaintShapeInfoAppDto>, PaintShapeInfoAppDto> onDrawEnd(final List<PaintShapeInfoAppDto> paintShapeInfo, final PaintShapeInfoAppDto previewShapeInfo, final Offset position) {
    List<PaintShapeInfoAppDto> newPaintShapeInfoList = [];
    newPaintShapeInfoList.addAll(paintShapeInfo);

    // 画面を連打した際にonPanUpdateを経由せずradiusが0の場合のケア
    if ((previewShapeInfo as PaintShapeCircleInfoAppDto).radius == 0) {
      final previewShapeNewInfo = PaintShapeInfoAppDto()..isValid = false;

      return Tuple2(newPaintShapeInfoList, previewShapeNewInfo);
    }

    var newPaintShapeInfo = PaintShapeCircleInfoAppDto();
    newPaintShapeInfo.isValid = true;
    newPaintShapeInfo.ownerId = previewShapeInfo.ownerId;
    newPaintShapeInfo.color = previewShapeInfo.color;
    newPaintShapeInfo.paintId = const Uuid().v4();
    newPaintShapeInfo.isRegistered = true;
    newPaintShapeInfo.isUpdated = false;
    newPaintShapeInfo.isDeleted = false;
    newPaintShapeInfo.center = previewShapeInfo.center;
    newPaintShapeInfo.radius = previewShapeInfo.radius;

    int displayOrder = 0;
    if (newPaintShapeInfoList.isNotEmpty) {
      displayOrder = newPaintShapeInfoList.first.displayOrder;
      for (var element in newPaintShapeInfoList) {
        if (element.displayOrder > displayOrder) {
          displayOrder = element.displayOrder;
        }
      }
    }
    newPaintShapeInfo.displayOrder = displayOrder + 1;

    newPaintShapeInfoList.add(newPaintShapeInfo);

    var newPreviewShapeInfo = PaintShapeCircleInfoAppDto();
    newPreviewShapeInfo.isValid = false;

    return Tuple2(newPaintShapeInfoList, newPreviewShapeInfo);
  }

  @override
  List<PaintShapeHandleInfoAppDto> getHandlePositionInfo(final PaintShapeInfoAppDto targetShapeInfo) {
    List<PaintShapeHandleInfoAppDto> handleInfoList = [];

    //サイズ変更用ハンドルの情報
    final x = (targetShapeInfo as PaintShapeCircleInfoAppDto).center.dx + targetShapeInfo.radius * const Angle.degrees(90).sin;
    final y = targetShapeInfo.center.dy - targetShapeInfo.radius * const Angle.degrees(90).cos;
    var handleInfo = PaintShapeHandleInfoAppDto();
    handleInfo.position = Offset(x, y);
    handleInfo.handleType = PaintShapeHandleType.resizeAll;
    handleInfoList.add(handleInfo);

    return handleInfoList;
  }

  @override
  Tuple2<PaintShapeHandleType, List<PaintShapeInfoAppDto>> onEditStart(final Offset position, final PaintShapeInfoAppDto targetShapeInfo) {
    final x = position.dx;
    final y = position.dy;
    //  ハンドルサイズ(半径36)の倍の数値に設定する（倍が違和感なく操作できる値）
    var radius = 72;

    //サイズ変更判定
    {
      final a = (targetShapeInfo as PaintShapeCircleInfoAppDto).center.dx + targetShapeInfo.radius * const Angle.degrees(90).sin;
      final b = targetShapeInfo.center.dy - targetShapeInfo.radius * const Angle.degrees(90).cos;

      if ((x - a) * (x - a) + (y - b) * (y - b) <= (radius * radius)) {
        var newTargetShapeInfo = PaintShapeCircleInfoAppDto();
        newTargetShapeInfo.isValid = true;
        newTargetShapeInfo.color = newTargetShapeInfo.colors[0];
        newTargetShapeInfo.paintId = targetShapeInfo.paintId;
        newTargetShapeInfo.ownerId = targetShapeInfo.ownerId;
        newTargetShapeInfo.swingId = targetShapeInfo.swingId;
        newTargetShapeInfo.displayOrder = targetShapeInfo.displayOrder;
        newTargetShapeInfo.isRegistered = targetShapeInfo.isRegistered;
        newTargetShapeInfo.isUpdated = targetShapeInfo.isUpdated;
        newTargetShapeInfo.isDeleted = targetShapeInfo.isDeleted;
        newTargetShapeInfo.center = targetShapeInfo.center;
        newTargetShapeInfo.radius = targetShapeInfo.radius;

        var newPreviewShapeInfo = PaintShapeCircleInfoAppDto();
        newPreviewShapeInfo.isValid = true;
        newPreviewShapeInfo.color = targetShapeInfo.color;
        newPreviewShapeInfo.center = targetShapeInfo.center;
        newPreviewShapeInfo.radius = targetShapeInfo.radius;

        return Tuple2(PaintShapeHandleType.resizeAll, [newTargetShapeInfo, newPreviewShapeInfo]);
      }
    }

    //移動判定
    {
      final a = targetShapeInfo.center.dx;
      final b = targetShapeInfo.center.dy;

      if ((x - a) * (x - a) + (y - b) * (y - b) <= (targetShapeInfo.radius * targetShapeInfo.radius)) {
        var newTargetShapeInfo = PaintShapeCircleInfoAppDto();
        newTargetShapeInfo.isValid = true;
        newTargetShapeInfo.color = newTargetShapeInfo.colors[0];
        newTargetShapeInfo.paintId = targetShapeInfo.paintId;
        newTargetShapeInfo.ownerId = targetShapeInfo.ownerId;
        newTargetShapeInfo.swingId = targetShapeInfo.swingId;
        newTargetShapeInfo.displayOrder = targetShapeInfo.displayOrder;
        newTargetShapeInfo.isRegistered = targetShapeInfo.isRegistered;
        newTargetShapeInfo.isUpdated = targetShapeInfo.isUpdated;
        newTargetShapeInfo.isDeleted = targetShapeInfo.isDeleted;
        newTargetShapeInfo.center = targetShapeInfo.center;
        newTargetShapeInfo.radius = targetShapeInfo.radius;

        var newPreviewShapeInfo = PaintShapeCircleInfoAppDto();
        newPreviewShapeInfo.isValid = true;
        newPreviewShapeInfo.color = targetShapeInfo.color;
        newPreviewShapeInfo.center = targetShapeInfo.center;
        newPreviewShapeInfo.radius = targetShapeInfo.radius;

        return Tuple2(PaintShapeHandleType.move, [newTargetShapeInfo, newPreviewShapeInfo]);
      }
    }

    return Tuple2(PaintShapeHandleType.none, [PaintShapeInfoAppDto()..isValid = false, PaintShapeInfoAppDto()..isValid = false]);
  }

  @override
  PaintShapeInfoAppDto onEditMoveUpdate(final Offset position, final PaintShapeInfoAppDto previewShapeInfo, final Size widgetSize) {
    PaintShapeCircleInfoAppDto newPreviewShapeInfo = PaintShapeCircleInfoAppDto();
    newPreviewShapeInfo.isValid = true;
    newPreviewShapeInfo.color = (previewShapeInfo as PaintShapeCircleInfoAppDto).color;
    newPreviewShapeInfo.radius = previewShapeInfo.radius;

    newPreviewShapeInfo.center = getBorderPosition(widgetSize, position, previewShapeInfo.center, previewShapeInfo.radius);

    return newPreviewShapeInfo;
  }

  Offset getBorderPosition(final Size widgetSize, final Offset position, final Offset previewPosition, final double radius) {
    //図形を移動出来るサイズをビデオ動画より一回り小さいサイズに設定する
    const double startWidth = 15; //X軸始点
    const double startHeight = 15; //Y軸始点
    final double endWidth = widgetSize.width - 15; //X軸終点
    final double endHeight = widgetSize.height - 15; //Y軸終点

    //90度の位置
    final positionX_90 = position.dx + radius * const Angle.degrees(90).sin;
    final positionY_90 = position.dy - radius * const Angle.degrees(90).cos;
    //180度の位置
    final positionX_180 = position.dx + radius * const Angle.degrees(180).sin;
    final positionY_180 = position.dy - radius * const Angle.degrees(180).cos;
    //270度の位置
    final positionX_270 = position.dx + radius * const Angle.degrees(270).sin;
    final positionY_270 = position.dy - radius * const Angle.degrees(270).cos;
    //360度の位置
    final positionX_360 = position.dx + radius * const Angle.degrees(360).sin;
    final positionY_360 = position.dy - radius * const Angle.degrees(360).cos;

    Offset newPosition = position;

    int count = 0;
    for (int i = 0; i < 360; i += 90) {
      final x = position.dx + radius * Angle.degrees(i.toDouble()).sin;
      final y = position.dy - radius * Angle.degrees(i.toDouble()).cos;

      if (isInsideVideoSize(Offset(x, y), widgetSize)) {
        count++;
      }
    }

    if (count > 1) {
      newPosition = Offset(previewPosition.dx, previewPosition.dy);
      return newPosition;
    }

    //左　270度
    if (startWidth >= positionX_270 && startHeight <= positionY_270 && endHeight >= positionY_270) {
      newPosition = Offset(previewPosition.dx, position.dy);

      return newPosition;
    }

    //右 90度
    if (endWidth <= positionX_90 && startHeight <= positionY_90 && endHeight >= positionY_90) {
      newPosition = Offset(previewPosition.dx, position.dy);

      return newPosition;
    }

    //上　360度
    if (startHeight >= positionY_360 && startWidth <= positionX_360 && endWidth >= positionX_360) {
      newPosition = Offset(position.dx, previewPosition.dy);

      return newPosition;
    }

    //下　180度
    if (endHeight <= positionY_180 && startWidth <= positionX_180 && endWidth >= positionX_180) {
      newPosition = Offset(position.dx, previewPosition.dy);

      return newPosition;
    }

    return newPosition;
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
    final x = position.dx;
    final y = position.dy;
    final a = (previewShapeInfo as PaintShapeCircleInfoAppDto).center.dx;
    final b = previewShapeInfo.center.dy;
    double radius = sqrt((x - a) * (x - a) + (y - b) * (y - b));

    //最小半径の制限
    //ハンドルが同士が重ならない値として80を設定
    if (radius <= 60) {
      radius = 60;
    }

    bool isInside = false;
    for (int i = 0; i < 360; i += 90) {
      var x = previewShapeInfo.center.dx + radius * Angle.degrees(i.toDouble()).sin;
      var y = previewShapeInfo.center.dy - radius * Angle.degrees(i.toDouble()).cos;

      if (isInsideVideoSize(Offset(x, y), widgetSize)) {
        isInside = true;
        break;
      }
    }

    var newPreviewShapeInfo = PaintShapeCircleInfoAppDto();
    newPreviewShapeInfo.isValid = true;
    newPreviewShapeInfo.ownerId = previewShapeInfo.ownerId;
    newPreviewShapeInfo.color = previewShapeInfo.color;
    newPreviewShapeInfo.center = previewShapeInfo.center;
    newPreviewShapeInfo.radius = isInside ? previewShapeInfo.radius : radius;

    return newPreviewShapeInfo;
  }

  @override
  PaintShapeInfoAppDto onEditResizeStartUpdate(final Offset position, final PaintShapeInfoAppDto previewShapeInfo, final Size widgetSize) {
    return PaintShapeInfoAppDto()..isValid = false;
  }

  @override
  PaintShapeInfoAppDto onEditResizeEndUpdate(final Offset position, final PaintShapeInfoAppDto previewShapeInfo, final Size widgetSize) {
    return PaintShapeInfoAppDto()..isValid = false;
  }

  @override
  Tuple2<List<PaintShapeInfoAppDto>, List<PaintShapeInfoAppDto>> onEditEnd(final List<PaintShapeInfoAppDto> paintShapeInfo, final PaintShapeInfoAppDto targetShapeInfo, final PaintShapeInfoAppDto previewShapeInfo, final PaintShapeHandleType handleType) {
    List<PaintShapeInfoAppDto> newPaintShapeList = [];
    newPaintShapeList.addAll(paintShapeInfo);

    //変更後の図形で更新する
    final index = newPaintShapeList.lastIndexWhere((shapeInfo) {
      return shapeInfo.paintId == targetShapeInfo.paintId;
    });
    if (index != -1) {
      newPaintShapeList.removeAt(index);

      var newPaintShapeInfo = PaintShapeCircleInfoAppDto();
      newPaintShapeInfo.isValid = true;
      newPaintShapeInfo.ownerId = targetShapeInfo.ownerId;
      newPaintShapeInfo.color = (previewShapeInfo as PaintShapeCircleInfoAppDto).color;
      newPaintShapeInfo.paintId = targetShapeInfo.paintId;
      newPaintShapeInfo.swingId = targetShapeInfo.swingId;
      newPaintShapeInfo.displayOrder = targetShapeInfo.displayOrder;
      newPaintShapeInfo.isRegistered = targetShapeInfo.isRegistered;
      newPaintShapeInfo.isUpdated = true;
      newPaintShapeInfo.isDeleted = targetShapeInfo.isDeleted;
      newPaintShapeInfo.center = previewShapeInfo.center;
      newPaintShapeInfo.radius = previewShapeInfo.radius;

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

    var newTargetShapeInfo = PaintShapeCircleInfoAppDto();
    newTargetShapeInfo.isValid = false;

    var newPreviewShapeInfo = PaintShapeCircleInfoAppDto();
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
        return color == (targetShapeInfo as PaintShapeCircleInfoAppDto).color;
      });

      if (colorIndex >= targetShapeInfo.colors.length - 1) {
        (targetShapeInfo as PaintShapeCircleInfoAppDto).color = targetShapeInfo.colors[1];
      } else {
        (targetShapeInfo as PaintShapeCircleInfoAppDto).color = targetShapeInfo.colors[colorIndex + 1];
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
