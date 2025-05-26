class WebAppDataEntity {
  late String academyUrl;
  late String howToUseUrl;
  late String privacyStatementUrl;
  late String termsOfServiceUrl;
  late String webAppUrl;

  WebAppDataEntity() {
    academyUrl = "";
    howToUseUrl = "";
    privacyStatementUrl = "";
    termsOfServiceUrl = "";
    webAppUrl = "";
  }

  WebAppDataEntity.fromMap(final Map<String, dynamic> map) {
    academyUrl = map.containsKey("academyUrl") ? map["academyUrl"] : "";
    howToUseUrl = map.containsKey("howToUseUrl") ? map["howToUseUrl"] : "";
    privacyStatementUrl = map.containsKey("privacyStatementUrl") ? map["privacyStatementUrl"] : "";
    termsOfServiceUrl = map.containsKey("termsOfServiceUrl") ? map["termsOfServiceUrl"] : "";
    webAppUrl = map.containsKey("webAppUrl") ? map["webAppUrl"] : "";
  }
}
