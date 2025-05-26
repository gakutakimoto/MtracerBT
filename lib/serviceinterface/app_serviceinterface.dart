abstract class AppServiceInterface {
  Future<bool> isAccept();
  void startLoading();
  void stopLoading();
  void startDeviceLoading();
  void stopDeviceLoading();
  void startTraining();
  void stopTraining();
}
