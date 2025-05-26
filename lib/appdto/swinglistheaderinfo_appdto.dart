import 'package:mtracersdkexample/appdto/swinglistheaderindexesinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingstatus_type.dart';

class SwingListHeaderInfoAppDto {
  late bool isDeleteReserved;

  late String swingId;
  late SwingStatusType swingStatusType;
  late bool isExistVideo;
  late bool isFavorite;
  late String? memo;
  late SwingListHeaderIndexesInfoAppDto swingListHeaderIndexesInfo;

  SwingListHeaderInfoAppDto() {
    isDeleteReserved = false;

    swingId = "";
    swingStatusType = SwingStatusType.disable;
    isExistVideo = false;
    isFavorite = false;
    memo = null;
    swingListHeaderIndexesInfo = SwingListHeaderIndexesInfoAppDto();
  }
}
