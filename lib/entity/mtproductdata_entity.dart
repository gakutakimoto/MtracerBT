class MTProductDataEntity {
  late String modelName;
  late String modelCode;
  late String destinationCode;
  late int productGrade;

  MTProductDataEntity() {
    modelName = "";
    modelCode = "";
    destinationCode = "";
    productGrade = 255;
  }

  MTProductDataEntity.fromMap(final Map<String, dynamic> map) {
    modelName = map.containsKey("modelName") ? map["modelName"] : "";
    modelCode = map.containsKey("modelCode") ? map["modelCode"] : "";
    destinationCode = map.containsKey("destinationCode") ? map["destinationCode"] : "";
    productGrade = map.containsKey("productGrade") ? (map["productGrade"] as num) as int : 255;
  }
}
