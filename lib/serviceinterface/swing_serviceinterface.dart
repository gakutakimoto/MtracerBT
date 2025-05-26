import 'dart:io';

import 'package:mtracersdkexample/appdto/userswinginfo_appdto.dart';

abstract class SwingServiceInterface {
  Future<File?> downloadSwingVideo(final String url, final String userId, final String swingInfoId);
  Future<bool> requestNextSwing();
  Future<bool> requestPrevSwing();
  Future<bool> requestSwing(final String swingId);
  Future<bool> requestSwingHeaderInfos(final DateTime swingDateFrom, final DateTime swingDateTo);
  void reserveDeleteSwing(final String swingId);
  Future<DateTime?> searchNextSwing(final DateTime swingDate);
  Future<DateTime?> searchPrevSwing(final DateTime swingDate);
  Future<bool> toggleFavoriteSwing(final String swingId);
  Future<bool> updateMemo(final String swingId, final String? memo);
  Future<void> updateSwingPaint(final UserSwingInfoAppDto swingPaintInfo, final String swingId);

  Future<bool> deleteSwing();

  // Future<bool> updateFavoriteInfo(final String swingInfoId, final bool isFavorite);
  // Future<bool> selectMonthlySwingHeaderInfo(final DateTime date);
  // Future<DateTime> requestPreviousSwingInfoList(final DateTime date);
  // Future<DateTime> requestNextSwingInfoList(final DateTime date);
  // Future<bool> requestMonthlySwingHeaderInfos(final DateTime date);
  // Future<bool> requestSwing(final String swingId);
}
