abstract class WebAppServiceInterface {
  Future<void> configure();
  String getHowToUseUrl();
  String getPrivacyStatementUrl();
  String getTermsOfServiceUrl();
  String getWebAppUrl();
  Future<String> getAcademyUrl();
}
