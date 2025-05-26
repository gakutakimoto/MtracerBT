abstract class PreferenceDriverInterface {
  Future<String?> readString(final String key);
  Future<bool> persistString(final String key, final String value);
  Future<int?> readInt(final String key);
  Future<bool> persistInt(final String key, final int value);
  Future<bool?> readBool(final String key);
  Future<bool> persistBool(final String key, final bool value);
  Future<bool> removeBy(final String key);
}
