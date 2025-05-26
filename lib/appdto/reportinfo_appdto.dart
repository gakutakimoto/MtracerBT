import 'package:mtracersdkexample/appdto/reportdetailinfo_appdto.dart';

class ReportInfoAppDto {
  //診断日
  late DateTime reportDateFrom;
  late DateTime reportDateTo;

  //総合点
  late double totalScore;

  //上達率
  late double improvementRate;

  //スイング回数
  late int swingCount;

  //再現性点
  late double reproducibility;

  //スイングレベル
  late ReportDetailInfoAppDto swingLevel;

  //アドレス
  late ReportDetailInfoAppDto address;

  //HWD
  late ReportDetailInfoAppDto hwd;

  //効率
  late ReportDetailInfoAppDto efficiency;

  //HWB
  late ReportDetailInfoAppDto hwb;

  //インパクト
  late ReportDetailInfoAppDto impact;

  //打点
  late ReportDetailInfoAppDto hitPoint;

  //回転
  late ReportDetailInfoAppDto rotation;

  //トップ
  late ReportDetailInfoAppDto top;

  //Vゾーン
  late ReportDetailInfoAppDto vZone;

  //スピード(Driver)
  late ReportDetailInfoAppDto speed;

  //ダウンブロー(Iron)
  late ReportDetailInfoAppDto downBlow;

  ReportInfoAppDto() {
    reportDateFrom = DateTime.now();
    reportDateTo = DateTime.now();
    totalScore = 0.0;
    improvementRate = 0.0;
    swingCount = 0;
    reproducibility = 0.0;

    swingLevel = ReportDetailInfoAppDto();
    address = ReportDetailInfoAppDto();
    hwd = ReportDetailInfoAppDto();
    efficiency = ReportDetailInfoAppDto();
    hwb = ReportDetailInfoAppDto();
    impact = ReportDetailInfoAppDto();
    hitPoint = ReportDetailInfoAppDto();
    rotation = ReportDetailInfoAppDto();
    top = ReportDetailInfoAppDto();
    vZone = ReportDetailInfoAppDto();
    speed = ReportDetailInfoAppDto();
    downBlow = ReportDetailInfoAppDto();
  }
}
