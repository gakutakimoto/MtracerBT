import 'package:mtracersdkexample/appdto/cloudendpointinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/systemparameterinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/webappinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/webpageinfo_appdto.dart';

abstract class ParameterGatewayInterface {
  Future<SystemParameterInfoAppDto> readSystemParameterInfo();
  Future<CloudEndpointInfoAppDto> readCloudEndpointInfo();
  Future<WebAppInfoAppDto> readWebAppInfo();
  Future<WebPageInfoAppDto> readWebPageInfo();
}
