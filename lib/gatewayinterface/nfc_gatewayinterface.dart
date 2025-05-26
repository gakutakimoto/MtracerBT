abstract class NFCGatewayInterface {
  Future<String> wakeupNFCReader();
  Future<void> sleepNFCReader();
}
