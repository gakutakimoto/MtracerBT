abstract class MethodChannelDriverInterface {
  Future<T> invokeMethod<T>(final String methodName, [final dynamic arguments]);
}
