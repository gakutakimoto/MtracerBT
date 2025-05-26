import 'package:mtracersdkexample/residentservice/devicemonitor_residentservice.dart';
import 'package:mtracersdkexample/residentservice/swinginfosync_residentservice.dart';
import 'package:mtracersdkexample/residentservice/swingvideosync_residentservice.dart';
import 'package:mtracersdkexample/residentservice_interface/timeperiodic_residentservice_interface.dart';

class MainViewModel {
  // late TimePeriodicResidentServiceInterface deviceMonitorResidentService;
  // late TimePeriodicResidentServiceInterface swingInfoSyncResidentService;
  // late TimePeriodicResidentServiceInterface swingVideoSyncResidentService;

  MainViewModel() {
    // deviceMonitorResidentService = DeviceMonitorResidentService();
    // swingInfoSyncResidentService = SwingInfoSyncResidentService();
    // swingVideoSyncResidentService = SwingVideoSyncResidentService();
  }

  void initState() {
    // deviceMonitorResidentService.start();
    // swingInfoSyncResidentService.start();
    // swingVideoSyncResidentService.start();
  }

  void dispose() {
    // deviceMonitorResidentService.stop();
    // swingInfoSyncResidentService.stop();
    // swingVideoSyncResidentService.stop();
  }

  void inactive() {
    // deviceMonitorResidentService.inactive();
    // swingInfoSyncResidentService.inactive();
    // swingVideoSyncResidentService.inactive();
  }

  void resumed() {
    // deviceMonitorResidentService.resume();
    // swingInfoSyncResidentService.resume();
    // swingVideoSyncResidentService.resume();
  }
}
