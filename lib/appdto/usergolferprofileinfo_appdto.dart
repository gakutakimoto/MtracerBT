import 'package:mtracersdkexample/appdto/dominanthand_type.dart';

class UserGolferProfileInfoAppDto {
  late DateTime? startAt;
  late DominantHandType dominantHandType;
  late int scoreAVG;
  late int gloveSize;
  late int? roundPlayFrequency;
  late int? exerciseFrequency;
  late int? worry;
  late String? worryMemo;

  UserGolferProfileInfoAppDto() {
    startAt = null;
    dominantHandType = DominantHandType.right;
    scoreAVG = 0;
    gloveSize = 0;
    roundPlayFrequency = null;
    exerciseFrequency = null;
    worry = null;
    worryMemo = null;
  }
}
