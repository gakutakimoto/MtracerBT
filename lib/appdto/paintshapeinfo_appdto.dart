class PaintShapeInfoAppDto {
  late String userId;
  late String swingId;
  late String paintId;
  late String ownerId;

  late final List<int> colors;
  late bool isValid;

  late int displayOrder;
  late bool isRegistered;
  late bool isUpdated;
  late bool isDeleted;

  PaintShapeInfoAppDto() {
    userId = "";
    swingId = "";
    paintId = "";
    ownerId = "";

    //保持している色：Colors.grey, Colors.blue, Colors.red, Colors.green, Colors.yellow, Colors.purple, Colors.tealAccent
    colors = [0xFF9E9E9E, 0xFF2196F3, 0xFFF44336, 0xFF4CAF50, 0xFFFFEB3B, 0xFF9C27B0, 0xFF64FFDA];
    isValid = false;

    displayOrder = 0;
    isRegistered = false;
    isUpdated = false;
    isDeleted = false;
  }
}
