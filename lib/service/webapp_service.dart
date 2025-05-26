import 'package:mtracersdkexample/appdto/webappinfo_appdto.dart';
import 'package:mtracersdkexample/datastore/webappinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/gateway/awscognito_gateway.dart';
import 'package:mtracersdkexample/gateway/parameter_gateway.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudauth_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/parameter_gatewayinterface.dart';
import 'package:mtracersdkexample/serviceinterface/webapp_serviceinterface.dart';

class WebAppService extends WebAppServiceInterface {
  late DatastoreInterface<void Function(WebAppInfoAppDto), WebAppInfoAppDto> webAppInfoDatastore;
  late ParameterGatewayInterface parameterGateway;
  late CloudAuthGatewayInterface cloudAuthGateway;

  WebAppService() {
    webAppInfoDatastore = WebAppInfoDatastore();
    parameterGateway = ParameterGateway();
    cloudAuthGateway = AWSCognitoGateway();
  }

  @override
  Future<void> configure() async {
    final webAppInfo = await parameterGateway.readWebAppInfo();
    webAppInfoDatastore.publish(webAppInfo);
  }

  @override
  String getHowToUseUrl() {
    final webAppInfo = webAppInfoDatastore.getData();
    return webAppInfo.howToUseUrl;
  }

  @override
  String getPrivacyStatementUrl() {
    final webAppInfo = webAppInfoDatastore.getData();
    return webAppInfo.privacyStatementUrl;
  }

  @override
  String getTermsOfServiceUrl() {
    final webAppInfo = webAppInfoDatastore.getData();
    return webAppInfo.termsOfServiceUrl;
  }

  @override
  String getWebAppUrl() {
    final webAppInfo = webAppInfoDatastore.getData();
    return webAppInfo.webAppUrl;
  }

  @override
  Future<String> getAcademyUrl() async {
    final webAppInfo = webAppInfoDatastore.getData();

    final cognitoUser = await cloudAuthGateway.getCurrentUser();
    if (cognitoUser == null) {
      return "";
    }

    final session = await cloudAuthGateway.getSession(cognitoUser);
    if (session == null) {
      return "";
    }

    final idToken = session.getIdToken().getJwtToken() ?? "";
    if (idToken.isEmpty) {
      return "";
    }

    final userSub = cloudAuthGateway.getUserSub(idToken) ?? "";
    if (userSub.isEmpty) {
      return "";
    }

    String? refreshToken = session.refreshToken?.getToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return "";
    }

    return "${webAppInfo.academyUrl}?sub=$userSub&token=$refreshToken";
  }
}
