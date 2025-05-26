import 'package:intl/intl.dart';
import 'package:mtracersdkexample/appdto/gender_type.dart';

class ProfileInfoAppDto {
  late double height;
  late GenderType genderType;
  late DateTime birthdayYMD;

  ProfileInfoAppDto() {
    height = 0.0;
    genderType = GenderType.other;
    birthdayYMD = DateFormat("yyyy-MM-dd").parse("1900-01-01", true);
  }
}
