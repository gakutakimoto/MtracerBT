import 'package:mtracersdkexample/appdto/cloudapiendpointinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/cloudauthendpointinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/cloudstorageendpointinfo_appdto.dart';

class CloudEndpointInfoAppDto {
  late CloudAuthEndpointInfoAppDto cloudAuthEndpointInfo;
  late CloudAPIEndpointInfoAppDto cloudAPIEndpointInfo;
  late CloudStorageEndpointInfoAppDto cloudStorageEndpointInfo;

  CloudEndpointInfoAppDto() {
    cloudAuthEndpointInfo = CloudAuthEndpointInfoAppDto();
    cloudAPIEndpointInfo = CloudAPIEndpointInfoAppDto();
    cloudStorageEndpointInfo = CloudStorageEndpointInfoAppDto();
  }
}
