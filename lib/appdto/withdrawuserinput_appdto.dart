import 'package:mtracersdkexample/appdto/withdrawalreason_type.dart';

class WithdrawUserInputAppDto {
  late WithdrawalReasonType withdrawalReasonType;
  late String comment;

  WithdrawUserInputAppDto() {
    withdrawalReasonType = WithdrawalReasonType.other;
    comment = "";
  }
}
