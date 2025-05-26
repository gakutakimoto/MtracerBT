abstract class PermissionServiceInterface {
  Future<void> requestPermissionForConnect();
  Future<void> requestPermissionForTraining();
  bool isGrantedPermissionForTraining();
}
