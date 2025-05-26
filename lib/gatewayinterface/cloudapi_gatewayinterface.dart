import 'dart:async';

import 'package:mtracersdkexample/appdto/appinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/attachswingvideocondition_appdto.dart';
import 'package:mtracersdkexample/appdto/deletepaintcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/deleteswingcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/getappcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/getswingcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/getswingheadercondition_appdto.dart';
import 'package:mtracersdkexample/appdto/getswingnextcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/getswingprevcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/getusercondition_appdto.dart';
import 'package:mtracersdkexample/appdto/getuserlessoncondition_appdto.dart';
import 'package:mtracersdkexample/appdto/getuserpointcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/newsinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/registerpaintcircleinput_appdto.dart';
import 'package:mtracersdkexample/appdto/registerpaintlineinput_appdto.dart';
import 'package:mtracersdkexample/appdto/registerswinginput_appdto.dart';
import 'package:mtracersdkexample/appdto/registeruseractivateinput_appdto.dart';
import 'package:mtracersdkexample/appdto/shoppinginfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swinginfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swinglistheaderinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/updatepaintcirclecondition_appdto.dart';
import 'package:mtracersdkexample/appdto/updatepaintcircleinput_appdto.dart';
import 'package:mtracersdkexample/appdto/updatepaintlinecondition_appdto.dart';
import 'package:mtracersdkexample/appdto/updatepaintlineinput_appdto.dart';
import 'package:mtracersdkexample/appdto/updateswingcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/updateswinginput_appdto.dart';
import 'package:mtracersdkexample/appdto/useractivateinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userlessoninfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userpointinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/withdrawusercondition_appdto.dart';
import 'package:mtracersdkexample/appdto/withdrawuserinput_appdto.dart';

abstract class CloudAPIGatewayInterface {
  void configure();

  Future<SwingInfoAppDto?> attachSwingVideo(final String endpoint, final String accessToken, final AttachSwingVideoConditionAppDto condition);
  Future<List<SwingListHeaderInfoAppDto>?> deleteSwing(final String endpoint, final String accessToken, final DeleteSwingConditionAppDto condition);
  Future<AppInfoAppDto?> getApp(final String endpoint, final String accessToken, final GetAppConditionAppDto condition);
  Future<List<NewsInfoAppDto>> getNews(final String endpoint, final String accessToken, final String userId);
  Future<List<SwingListHeaderInfoAppDto>?> getSwingHeader(final String endpoint, final String accessToken, final GetSwingHeaderConditionAppDto condition);
  Future<SwingInfoAppDto?> getSwing(final String endpoint, final String accessToken, final GetSwingConditionAppDto condition);
  Future<SwingInfoAppDto?> getSwingNext(final String endpoint, final String accessToken, final GetSwingNextConditionAppDto condition);
  Future<SwingInfoAppDto?> getSwingPrev(final String endpoint, final String accessToken, final GetSwingPrevConditionAppDto condition);
  Future<UserInfoAppDto?> getUser(final String endpoint, final String accessToken, final GetUserConditionAppDto condition);
  Future<UserLessonInfoAppDto?> getUserLesson(final String endpoint, final String accessToken, final GetUserLessonConditionAppDto condition);
  Future<UserPointInfoAppDto?> getUserPoint(final String endpoint, final String accessToken, final GetUserPointConditionAppDto condition);
  Future<SwingInfoAppDto?> registerSwing(final String endpoint, final String accessToken, final RegisterSwingInputAppDto input);
  Future<UserActivateInfoAppDto?> registerUserActivate(final String endpoint, final String accessToken, final RegisterUserActivateInputAppDto input);
  Future<SwingInfoAppDto?> updateSwing(final String endpoint, final String accessToken, final UpdateSwingConditionAppDto condition, final UpdateSwingInputAppDto input);
  Future<UserInfoAppDto?> withdrawUser(final String endpoint, final String accessToken, final WithdrawUserConditionAppDto condition, final WithdrawUserInputAppDto input);

  //お絵描きAPI
  Future<void> deletePaint(final String endpoint, final String accessToken, final DeletePaintConditionAppDto condition);
  Future<void> updatePaintCircle(final String endpoint, final String accessToken, final UpdatePaintCircleConditionAppDto condition, final UpdatePaintCircleInputAppDto input);
  Future<void> updatePaintLine(final String endpoint, final String accessToken, final UpdatePaintLineConditionAppDto condition, final UpdatePaintLineInputAppDto input);
  Future<void> registerPaintCircle(final String endpoint, final String accessToken, final RegisterPaintCircleInputAppDto input);
  Future<void> registerPaintLine(final String endpoint, final String accessToken, final RegisterPaintLineInputAppDto input);

  Future<ShoppingInfoAppDto> getShopping(final String endpoint, final String accessToken);
}
