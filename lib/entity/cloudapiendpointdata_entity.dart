class CloudAPIEndpointDataEntity {
  late String graphQlEndpoint;

  CloudAPIEndpointDataEntity() {
    graphQlEndpoint = "";
  }

  CloudAPIEndpointDataEntity.fromMap(final Map<String, dynamic> map) {
    graphQlEndpoint = map.containsKey("graphQlEndpoint") ? map["graphQlEndpoint"] : "";
  }
}
