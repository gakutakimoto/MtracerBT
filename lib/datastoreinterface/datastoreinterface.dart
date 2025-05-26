abstract class DatastoreInterface<T, U> {
  U getData();
  void addSubscriber(final String key, T subscriber);
  void removeSubscriber(final String key);
  void publish(final U value);
}
