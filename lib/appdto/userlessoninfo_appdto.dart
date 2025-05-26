import 'package:mtracersdkexample/appdto/lessoninfo_appdto.dart';

class UserLessonInfoAppDto {
  late String userId;
  late List<LessonInfoAppDto> lessonInfoList;

  UserLessonInfoAppDto() {
    userId = "";
    lessonInfoList = [];
  }
}
