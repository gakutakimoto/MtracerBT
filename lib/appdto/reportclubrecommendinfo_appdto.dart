import 'package:mtracersdkexample/appdto/graphradarinfo_appdto.dart';

class ReportClubRecommendInfoAppDto {
  late GraphRadarInfoAppDto recommendClubGraph;
  late String clubName;
  late int price;
  late String scoreDescription;
  late int score;

  ReportClubRecommendInfoAppDto() {
    recommendClubGraph = GraphRadarInfoAppDto();
    clubName = "";
    price = 0;
    scoreDescription = "";
    score = 0;
  }
}
