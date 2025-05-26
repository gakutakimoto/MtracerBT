import 'package:flutter/material.dart';
import 'package:mtracersdkexample/appdto/paintshapehandle_type.dart';
import 'package:mtracersdkexample/appdto/paintshapehandleinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/paintshapeinfo_appdto.dart';
import 'package:tuple_dart/tuple_dart.dart';

abstract class PaintShapeLogicInterface {
  //図形の描画開始
  PaintShapeInfoAppDto onDrawStart(final Offset position, final String ownerId);
  //描画プレビュー
  PaintShapeInfoAppDto onDrawUpdate(final PaintShapeInfoAppDto previewShapeInfo, final Offset position, final Size widgetSize);
  //図形の描画終了
  Tuple2<List<PaintShapeInfoAppDto>, PaintShapeInfoAppDto> onDrawEnd(final List<PaintShapeInfoAppDto> paintShapeInfo, final PaintShapeInfoAppDto previewShapeInfo, final Offset position);

  //図形変更用ハンドルの座標一覧を取得する
  List<PaintShapeHandleInfoAppDto> getHandlePositionInfo(final PaintShapeInfoAppDto targetShapeInfo);

  //図形の変更開始
  Tuple2<PaintShapeHandleType, List<PaintShapeInfoAppDto>> onEditStart(final Offset position, final PaintShapeInfoAppDto targetShapeInfo);
  //変更プレビュー
  PaintShapeInfoAppDto onEditMoveUpdate(final Offset position, final PaintShapeInfoAppDto previewShapeInfo, final Size widgetSize);
  PaintShapeInfoAppDto onEditResizeUpdate(final Offset position, final PaintShapeInfoAppDto previewShapeInfo, final Size widgetSize);
  PaintShapeInfoAppDto onEditResizeStartUpdate(final Offset position, final PaintShapeInfoAppDto previewShapeInfo, final Size widgetSize);
  PaintShapeInfoAppDto onEditResizeEndUpdate(final Offset position, final PaintShapeInfoAppDto previewShapeInfo, final Size widgetSize);
  //お絵かき画面内に図形プレビューを表示する
  bool isInsideVideoSize(final Offset position, final Size widgetSize);
  //図形の変更終了
  Tuple2<List<PaintShapeInfoAppDto>, List<PaintShapeInfoAppDto>> onEditEnd(final List<PaintShapeInfoAppDto> paintShapeInfo, final PaintShapeInfoAppDto targetShapeInfo, final PaintShapeInfoAppDto previewShapeInfo, final PaintShapeHandleType handleType);
  //図形削除
  List<PaintShapeInfoAppDto> onDelete(final List<PaintShapeInfoAppDto> paintShapeInfo, final PaintShapeInfoAppDto targetShapeInfo);
  List<PaintShapeInfoAppDto> onDeleteAll(final List<PaintShapeInfoAppDto> paintShapeInfo);
  //図形の色変更
  List<PaintShapeInfoAppDto> onChangeColor(final List<PaintShapeInfoAppDto> paintShapeInfo, final PaintShapeInfoAppDto targetShapeInfo);
}
