class MTSwingTrajectoryFlatDetailDataEntity {
  late List<double> headSpeeds;
  late List<double> gripSpeeds;
  late List<double> elapsedTimes;

  MTSwingTrajectoryFlatDetailDataEntity() {
    headSpeeds = [];
    gripSpeeds = [];
    elapsedTimes = [];
  }

  MTSwingTrajectoryFlatDetailDataEntity.fromMap(final Map<String, dynamic> map) {
    List<dynamic> rawHeadSpeed = map.containsKey("headSpeed") ? map["headSpeed"] : [];
    headSpeeds = [];
    for (var value in rawHeadSpeed) {
      headSpeeds.add(double.parse(value.toString()));
    }

    List<dynamic> rawgripSpeed = map.containsKey("gripSpeed") ? map["gripSpeed"] : [];
    gripSpeeds = [];
    for (var value in rawgripSpeed) {
      gripSpeeds.add(double.parse(value.toString()));
    }

    List<dynamic> rawElapsedTime = map.containsKey("elapsedTime") ? map["elapsedTime"] : [];
    elapsedTimes = [];
    for (var value in rawElapsedTime) {
      elapsedTimes.add(double.parse(value.toString()));
    }
  }
}
