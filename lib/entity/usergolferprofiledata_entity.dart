class UserGolferProfileDataEntity {
  late String userId;
  late DateTime? startAt;
  late int dominantHandType;
  late int scoreAVG;
  late int gloveSize;
  late int? roundPlayFrequency;
  late int? exerciseFrequency;
  late int? worry;
  late String? worryMemo;

  UserGolferProfileDataEntity() {
    userId = "";
    startAt = null;
    dominantHandType = 0;
    scoreAVG = 0;
    gloveSize = 0;
    roundPlayFrequency = null;
    exerciseFrequency = null;
    worry = null;
    worryMemo = null;
  }

  UserGolferProfileDataEntity.fromMap(final Map<String, dynamic> map) {
    userId = map.containsKey("userId") ? map["userId"] : "";

    if (map.containsKey("startAt") && (map["startAt"] != null)) {
      final startAtLocal = DateTime.parse(map["startAt"]);
      final startAtUtc = DateTime.utc(startAtLocal.year, startAtLocal.month, startAtLocal.day, 0, 0, 0);
      startAt = startAtUtc;
    } else {
      startAt = null;
    }

    dominantHandType = map.containsKey("dominantHandType") ? map["dominantHandType"] : 0;
    scoreAVG = map.containsKey("scoreAVG") ? map["scoreAVG"] : 0;
    gloveSize = map.containsKey("gloveSize") ? map["gloveSize"] : 0;
    roundPlayFrequency = map.containsKey("roundPlayFrequency") ? map["roundPlayFrequency"] : null;
    exerciseFrequency = map.containsKey("exerciseFrequency") ? map["exerciseFrequency"] : null;
    worry = map.containsKey("worry") ? map["worry"] : null;
    worryMemo = map.containsKey("worryMemo") ? map["worryMemo"] : null;
  }
}
