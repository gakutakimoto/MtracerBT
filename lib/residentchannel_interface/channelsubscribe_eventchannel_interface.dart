// abstract class ChannelSubscribeEventChannelInterface<T, U> {
abstract class ChannelSubscribeEventChannelInterface<T, U, V, W, X, Y> {
  void addEventStartSubscriber(final String key, T subscriber);
  void removeEventStartSubscriber(final String key);
  void publishEventStart(final U value);

  void addEventSubscriber(final String key, V subscriber);
  void removeEventSubscriber(final String key);
  void publishEvent(final W value);

  void addEventFinishSubscriber(final String key, X subscriber);
  void removeEventFinishSubscriber(final String key);
  void publishEventFinish(final Y value);
}
