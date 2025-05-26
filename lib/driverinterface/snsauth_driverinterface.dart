import 'package:mtracersdkexample/entity/oauthdata_entity.dart';

abstract class SNSAuthDriverInterface {
  OAuthDataEntity getOAuthUrl(final String authority, final String clientId, final String redirectUri, final String callbackUrlScheme);
  Future<OAuthDataEntity> signUp(final String uri, final String authority, final String clientId, final String redirectUri);
}
