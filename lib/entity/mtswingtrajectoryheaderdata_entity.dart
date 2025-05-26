import 'package:mtracersdkexample/entity/mtswingtrajectoryflatdetaildata_entity.dart';

class MTSwingTrajectoryHeaderDataEntity {
  late int indexStart;
  late int indexHWB;
  late int indexTop;
  late int indexImpact;
  late int indexHWD;
  late int indexFinish;
  late int indexMaxHeadSpeed;
  late int indexMaxGripSpeed;
  late MTSwingTrajectoryFlatDetailDataEntity trajectoryFlatDetailInfo;

  MTSwingTrajectoryHeaderDataEntity() {
    indexStart = 0;
    indexHWB = 0;
    indexTop = 0;
    indexImpact = 0;
    indexHWD = 0;
    indexFinish = 0;
    indexMaxHeadSpeed = 0;
    indexMaxGripSpeed = 0;
    trajectoryFlatDetailInfo = MTSwingTrajectoryFlatDetailDataEntity();
  }

  MTSwingTrajectoryHeaderDataEntity.fromMap(final Map<String, dynamic> map) {
    indexStart = map.containsKey("indexStart") ? int.parse(map["indexStart"].toString()) : 0;
    indexHWB = map.containsKey("indexHWB") ? int.parse(map["indexHWB"].toString()) : 0;
    indexTop = map.containsKey("indexTop") ? int.parse(map["indexTop"].toString()) : 0;
    indexImpact = map.containsKey("indexImpact") ? int.parse(map["indexImpact"].toString()) : 0;
    indexHWD = map.containsKey("indexHWD") ? int.parse(map["indexHWD"].toString()) : 0;
    indexFinish = map.containsKey("indexFinish") ? int.parse(map["indexFinish"].toString()) : 0;
    indexMaxHeadSpeed = map.containsKey("indexMaxHeadSpeed") ? int.parse(map["indexMaxHeadSpeed"].toString()) : 0;
    indexMaxGripSpeed = map.containsKey("indexMaxGripSpeed") ? int.parse(map["indexMaxGripSpeed"].toString()) : 0;

    if (map.containsKey("trajectoryFlatDetailInfo")) {
      trajectoryFlatDetailInfo = MTSwingTrajectoryFlatDetailDataEntity.fromMap(map["trajectoryFlatDetailInfo"]);
    }
  }
}
