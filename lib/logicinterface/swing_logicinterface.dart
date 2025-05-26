import 'package:mtracersdkexample/appdto/swingheaderinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swinginfo_appdto.dart';

abstract class SwingLogicInterface {
  SwingHeaderInfoAppDto convertHeaderFromJson(final String rawJson);
  SwingInfoAppDto convertFromJson(final String rawJson);
}
