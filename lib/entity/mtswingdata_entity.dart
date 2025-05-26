import 'package:mtracersdkexample/entity/mtswinggpsdata_entity.dart';
import 'package:mtracersdkexample/entity/mtswingheaderdata_entity.dart';
import 'package:mtracersdkexample/entity/mtswingmeasurementdata_entity.dart';
import 'package:mtracersdkexample/entity/mtswingphasedata_entity.dart';
import 'package:mtracersdkexample/entity/mtswingtrajectoryheaderdata_entity.dart';
import 'package:mtracersdkexample/entity/mtswingvzonedata_entity.dart';

class MTSwingDataEntity {
  late String vendorId;
  late MTSwingMeasurementDataEntity swingMeasurementData;
  late MTSwingGPSDataEntity swingGPSData;
  late int analyzeResultType;
  late MTSwingVZoneDataEntity swingVZoneData;
  late MTSwingPhaseDataEntity swingPhaseData;
  late MTSwingHeaderDataEntity swingHeaderData;
  late MTSwingTrajectoryHeaderDataEntity swingTrajectoryHeaderData;

  MTSwingDataEntity() {
    vendorId = "";
    swingMeasurementData = MTSwingMeasurementDataEntity();
    swingGPSData = MTSwingGPSDataEntity();
    analyzeResultType = -1;
    swingVZoneData = MTSwingVZoneDataEntity();
    swingPhaseData = MTSwingPhaseDataEntity();
    swingHeaderData = MTSwingHeaderDataEntity();
    swingTrajectoryHeaderData = MTSwingTrajectoryHeaderDataEntity();
  }

  MTSwingDataEntity.fromMap(final Map<String, dynamic> map) {
    vendorId = map.containsKey("vendorId") ? map["vendorId"] : "";
    if (map.containsKey("measurementInfo")) {
      swingMeasurementData = MTSwingMeasurementDataEntity.fromMap(map["measurementInfo"]);
    }
    if (map.containsKey("gpsInfo")) {
      swingGPSData = MTSwingGPSDataEntity.fromMap(map["gpsInfo"]);
    }
    analyzeResultType = map.containsKey("analyzeResultType") ? map["analyzeResultType"] : -1;
    if (map.containsKey("vZoneInfo")) {
      swingVZoneData = MTSwingVZoneDataEntity.fromMap(map["vZoneInfo"]);
    }
    if (map.containsKey("swingPhaseInfo")) {
      swingPhaseData = MTSwingPhaseDataEntity.fromMap(map["swingPhaseInfo"]);
    }
    if (map.containsKey("headerInfo")) {
      swingHeaderData = MTSwingHeaderDataEntity.fromMap(map["headerInfo"]);
    }
    if (map.containsKey("trajectoryInfo")) {
      swingTrajectoryHeaderData = MTSwingTrajectoryHeaderDataEntity.fromMap(map["trajectoryInfo"]);
    }
  }
}
