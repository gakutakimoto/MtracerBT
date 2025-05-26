import 'package:mtracersdkexample/appdto/gender_type.dart';

class UserBasicProfileInfoAppDto {
  late String? avatarPath;
  late String nickName;
  late String? firstName;
  late String? lastName;
  late String? firstNameKana;
  late String? lastNameKana;
  late DateTime? birthday;
  late GenderType genderType;
  late double height;
  late double weight;

  UserBasicProfileInfoAppDto() {
    avatarPath = null;
    nickName = "";
    firstName = null;
    lastName = null;
    firstNameKana = null;
    lastNameKana = null;
    birthday = null;
    genderType = GenderType.other;
    height = 0.0;
    weight = 0.0;
  }
}
