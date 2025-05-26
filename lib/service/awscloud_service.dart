import 'package:mtracersdkexample/appdto/cloudendpointinfo_appdto.dart';
import 'package:mtracersdkexample/datastore/cloudendpointinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/gateway/awsappsync_gateway.dart';
import 'package:mtracersdkexample/gateway/awscognito_gateway.dart';
import 'package:mtracersdkexample/gateway/awss3_gateway.dart';
import 'package:mtracersdkexample/gateway/parameter_gateway.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudapi_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudauth_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudstorage_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/parameter_gatewayinterface.dart';
import 'package:mtracersdkexample/logic/stringcodec_logic.dart';
import 'package:mtracersdkexample/logicinterface/stringcodec_logicinterface.dart';
import 'package:mtracersdkexample/serviceinterface/cloud_serviceinterface.dart';

class AWSCloudService extends CloudServiceInterface {
  late CloudAuthGatewayInterface cloudAuthGateway;
  late CloudAPIGatewayInterface cloudAPIGateway;
  late CloudStorageGatewayInterface cloudStorageGateway;
  late ParameterGatewayInterface parameterGateway;
  late StringCodecLogicInterface stringCodecLogic;

  late DatastoreInterface<void Function(CloudEndpointInfoAppDto), CloudEndpointInfoAppDto> cloudEndpointInfoDatastore;

  AWSCloudService() {
    cloudAuthGateway = AWSCognitoGateway();
    cloudAPIGateway = AWSAppSyncGateway();
    cloudStorageGateway = AWSS3Gateway();
    parameterGateway = ParameterGateway();
    stringCodecLogic = StringCodecLogic();

    cloudEndpointInfoDatastore = CloudEndpointInfoDatastore();
  }

  @override
  Future<void> configure() async {
    final systemParameterInfo = await parameterGateway.readSystemParameterInfo();
    final decryptKey = stringCodecLogic.decode(systemParameterInfo.decryptSICKey);
    final decryptIv = stringCodecLogic.decode(systemParameterInfo.decryptSICIv);

    final cloudEndpointInfo = await parameterGateway.readCloudEndpointInfo();
    final identityPoolId = stringCodecLogic.decrypt(decryptKey, decryptIv, cloudEndpointInfo.cloudAuthEndpointInfo.identityPoolId);
    final userPoolId = stringCodecLogic.decrypt(decryptKey, decryptIv, cloudEndpointInfo.cloudAuthEndpointInfo.userPoolId);
    final userPoolClientId = stringCodecLogic.decrypt(decryptKey, decryptIv, cloudEndpointInfo.cloudAuthEndpointInfo.userPoolClientId);
    final oAuthDomain = stringCodecLogic.decrypt(decryptKey, decryptIv, cloudEndpointInfo.cloudAuthEndpointInfo.oAuthDomain);
    final oAuthRedirectSignIn = stringCodecLogic.decrypt(decryptKey, decryptIv, cloudEndpointInfo.cloudAuthEndpointInfo.oAuthRedirectSignIn);
    final oAuthCallbackUrlScheme = stringCodecLogic.decrypt(decryptKey, decryptIv, cloudEndpointInfo.cloudAuthEndpointInfo.oAuthCallbackUrlScheme);
    final graphQlEndpoint = stringCodecLogic.decrypt(decryptKey, decryptIv, cloudEndpointInfo.cloudAPIEndpointInfo.graphQlEndpoint);
    final s3Region = stringCodecLogic.decrypt(decryptKey, decryptIv, cloudEndpointInfo.cloudStorageEndpointInfo.s3Region);
    final s3EndPoint = stringCodecLogic.decrypt(decryptKey, decryptIv, cloudEndpointInfo.cloudStorageEndpointInfo.s3EndPoint);
    final s3Host = stringCodecLogic.decrypt(decryptKey, decryptIv, cloudEndpointInfo.cloudStorageEndpointInfo.s3Host);
    final s3Bucket = stringCodecLogic.decrypt(decryptKey, decryptIv, cloudEndpointInfo.cloudStorageEndpointInfo.s3Bucket);

    cloudAuthGateway.configure(userPoolId, userPoolClientId, identityPoolId);
    cloudAPIGateway.configure();
    cloudStorageGateway.configure();

    final data = cloudEndpointInfoDatastore.getData();
    data.cloudAuthEndpointInfo.identityPoolId = identityPoolId;
    data.cloudAuthEndpointInfo.userPoolId = userPoolId;
    data.cloudAuthEndpointInfo.userPoolClientId = userPoolClientId;
    data.cloudAuthEndpointInfo.oAuthDomain = oAuthDomain;
    data.cloudAuthEndpointInfo.oAuthRedirectSignIn = oAuthRedirectSignIn;
    data.cloudAuthEndpointInfo.oAuthCallbackUrlScheme = oAuthCallbackUrlScheme;
    data.cloudAPIEndpointInfo.graphQlEndpoint = graphQlEndpoint;
    data.cloudStorageEndpointInfo.s3Region = s3Region;
    data.cloudStorageEndpointInfo.s3EndPoint = s3EndPoint;
    data.cloudStorageEndpointInfo.s3Host = s3Host;
    data.cloudStorageEndpointInfo.s3Bucket = s3Bucket;
    cloudEndpointInfoDatastore.publish(data);
  }
}
