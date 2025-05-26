import 'package:mtracersdkexample/appdto/paintshapeinfo_appdto.dart';

class UserSwingInfoAppDto {
  late String userId;
  late String swingId;
  late String ownerId;
  //特定のuserIdのペイント情報リスト
  late List<PaintShapeInfoAppDto> paintShapeInfos;

  UserSwingInfoAppDto() {
    userId = "";
    swingId = "";
    ownerId = "";
    paintShapeInfos = [];
  }
}
