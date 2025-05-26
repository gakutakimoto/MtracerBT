import 'package:mtracersdkexample/appdto/swinginfo_appdto.dart';

class SwingInfosAppDto {
  late List<SwingInfoAppDto> swingInfos;
  late SwingInfoAppDto? currentSwingInfo;

  SwingInfosAppDto() {
    swingInfos = [];
    currentSwingInfo = null;
  }
}
