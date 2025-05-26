import 'package:mtracersdkexample/appdto/shopiteminfo_appdto.dart';

class ShoppingInfoAppDto {
  late List<String> categorys;
  late List<ShopItemInfoAppDto> shopItemInfos;

  ShoppingInfoAppDto() {
    categorys = [];
    shopItemInfos = [];
  }
}
