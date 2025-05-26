import 'package:mtracersdkexample/appdto/clubcategorytype.dart';

class LessonInfoAppDto {
  late String id;
  late String videoUrl;
  late String imgUrl;
  late String detailImgUrl;
  late String detailExplanation;
  late String title;
  late int lessonType;
  late String createdAt;
  late String updatedAt;
  late int targetType;
  late String code;
  late int clubCategory;
  late ClubCategoryType categoryType;
  late int likeCount;

  LessonInfoAppDto() {
    id = "";
    videoUrl = "";
    imgUrl = "";
    detailImgUrl = "";
    detailExplanation = "";
    title = "";
    lessonType = 0;
    createdAt = "";
    updatedAt = "";
    targetType = 0;
    code = "";
    clubCategory = 0;
    categoryType = ClubCategoryType.wood;
    likeCount = 0;
  }
}
