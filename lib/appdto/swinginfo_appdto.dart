import 'package:mtracersdkexample/appdto/analyzeresult_type.dart';
import 'package:mtracersdkexample/appdto/swinggpsinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingheaderinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingmeasurementinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingphaseinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingtrajectoryheaderinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingvzoneinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userswinginfo_appdto.dart';

class SwingInfoAppDto {
  late String raw;

  late String swingId;

  late SwingMeasurementInfoAppDto swingMeasurementInfo;
  late SwingGPSInfoAppDto swingGPSInfo;
  late AnalyzeResultType analyzeResultType;
  late SwingVZoneInfoAppDto swingVZoneInfo;
  late SwingPhaseInfoAppDto swingPhaseInfo;
  late SwingHeaderInfoAppDto swingHeaderInfo;
  late SwingTrajectoryHeaderInfoAppDto swingTrajectoryHeaderInfo;

  late bool isExistVideo;
  late String? memo;
  late bool isFavorite;
  late String? swingVideoUrl;

  late List<UserSwingInfoAppDto> userSwingInfos;

  SwingInfoAppDto() {
    swingId = "";
    raw = "";

    swingMeasurementInfo = SwingMeasurementInfoAppDto();
    swingGPSInfo = SwingGPSInfoAppDto();
    analyzeResultType = AnalyzeResultType.outputERROR;
    swingVZoneInfo = SwingVZoneInfoAppDto();
    swingPhaseInfo = SwingPhaseInfoAppDto();
    swingHeaderInfo = SwingHeaderInfoAppDto();
    swingTrajectoryHeaderInfo = SwingTrajectoryHeaderInfoAppDto();

    isExistVideo = false;
    memo = null;
    isFavorite = false;
    swingVideoUrl = null;

    userSwingInfos = [];
  }
}
