class WebPageDataEntity {
  late String authKey;
  late String reportDetailUrl;
  late String userLessonUrl;
  late String basicLessonUrl;

  WebPageDataEntity() {
    authKey = "";
    reportDetailUrl = "";
    userLessonUrl = "";
    basicLessonUrl = "";
  }

  WebPageDataEntity.fromMap(final Map<String, dynamic> map) {
    authKey = map.containsKey("authKey") ? map["authKey"] : "";
    reportDetailUrl = map.containsKey("reportDetailUrl") ? map["reportDetailUrl"] : "";
    userLessonUrl = map.containsKey("userLessonUrl") ? map["userLessonUrl"] : "";
    basicLessonUrl = map.containsKey("basicLessonUrl") ? map["basicLessonUrl"] : "";
  }
}
