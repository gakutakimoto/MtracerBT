class AppStateInfoAppDto {
  late bool isLoading;

  late bool isDeviceBooking;
  late bool isInSyncing;
  late bool isInTraining;
  late bool isDeviceLoading;
  late bool isStartedSwingImpactEventMonitoring;
  late bool isStartedSwingInfoEventMonitoring;

  AppStateInfoAppDto() {
    isLoading = false;

    isDeviceBooking = false;
    isInSyncing = false;
    isInTraining = false;
    isDeviceLoading = false;
    isStartedSwingImpactEventMonitoring = false;
    isStartedSwingInfoEventMonitoring = false;
  }
}
