import 'package:mtracersdkexample/appdto/graphradarinfo_appdto.dart';

import 'reportclubrecommendinfo_appdto.dart';

class ReportClubInfoAppDto {
  late GraphRadarInfoAppDto currentClubGraph;
  late String clubName;
  late String scoreDescription;
  late int score;

  //おすすめクラブ
  late List<ReportClubRecommendInfoAppDto> recommendClubInfos;

  ReportClubInfoAppDto() {
    currentClubGraph = GraphRadarInfoAppDto();
    clubName = "";
    score = 0;
    scoreDescription = "";

    recommendClubInfos = [];
  }
}
