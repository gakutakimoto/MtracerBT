import 'package:http/http.dart' as http;

abstract class CloudAPIDriverInterface {
  Future<void> configure();
  Future<http.Response> request(final Uri endpoint, final String operationName, final String query, final String accessToken, {final int timeout = 20});
}
