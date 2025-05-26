abstract class WebPageServiceInterface {
  Future<void> configure();
  Future<void> getReportDetailWebPageUrl(final String customParam);
  Future<void> getUserLessonWebPageUrl(final String lessonId);
  Future<void> getLessonBasicWebPageUrl();
}
