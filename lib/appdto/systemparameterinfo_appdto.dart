class SystemParameterInfoAppDto {
  late String decryptSICKey;
  late String decryptSICIv;
  late String decryptCBCKey;
  late String decryptCBCIv;

  SystemParameterInfoAppDto() {
    decryptSICKey = "";
    decryptSICIv = "";
    decryptCBCKey = "";
    decryptCBCIv = "";
  }
}
