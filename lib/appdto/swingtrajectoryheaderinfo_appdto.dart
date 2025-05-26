import 'package:mtracersdkexample/appdto/swingtrajectoryflatdetailinfo_appdto.dart';

class SwingTrajectoryHeaderInfoAppDto {
  late int indexStart;
  late int indexHWB;
  late int indexTop;
  late int indexImpact;
  late int indexHWD;
  late int indexFinish;
  late int indexMaxHeadSpeed;
  late int indexMaxGripSpeed;
  late SwingTrajectoryFlatDetailInfoAppDto swingTrajectoryFlatDetailInfo;

  SwingTrajectoryHeaderInfoAppDto() {
    indexStart = 0;
    indexHWB = 0;
    indexTop = 0;
    indexImpact = 0;
    indexHWD = 0;
    indexFinish = 0;
    indexMaxHeadSpeed = 0;
    indexMaxGripSpeed = 0;
    swingTrajectoryFlatDetailInfo = SwingTrajectoryFlatDetailInfoAppDto();
  }
}
