import 'package:mtracersdkexample/entity/cloudapiendpointdata_entity.dart';
import 'package:mtracersdkexample/entity/cloudauthendpointdata_entity.dart';
import 'package:mtracersdkexample/entity/cloudstorageendpointdata_entity.dart';

class CloudEndpointDataEntity {
  late CloudAuthEndpointDataEntity cloudAuthEndpointData;
  late CloudAPIEndpointDataEntity cloudAPIEndpointData;
  late CloudStorageEndpointDataEntity cloudStorageEndpointData;

  CloudEndpointDataEntity() {
    cloudAuthEndpointData = CloudAuthEndpointDataEntity();
    cloudAPIEndpointData = CloudAPIEndpointDataEntity();
    cloudStorageEndpointData = CloudStorageEndpointDataEntity();
  }

  CloudEndpointDataEntity.fromMap(final Map<String, dynamic> map) {
    if (map.containsKey("auth")) {
      cloudAuthEndpointData = CloudAuthEndpointDataEntity.fromMap(map["auth"]);
    }
    if (map.containsKey("api")) {
      cloudAPIEndpointData = CloudAPIEndpointDataEntity.fromMap(map["api"]);
    }
    if (map.containsKey("storage")) {
      cloudStorageEndpointData = CloudStorageEndpointDataEntity.fromMap(map["storage"]);
    }
  }
}
