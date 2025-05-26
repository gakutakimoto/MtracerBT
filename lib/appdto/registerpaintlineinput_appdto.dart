class RegisterPaintLineInputAppDto {
  late String userId;
  late String swingId;
  late String paintId;
  late String ownerId;

  late double startX;
  late double startY;
  late double endX;
  late double endY;
  late int color;
  late int displayOrder;

  RegisterPaintLineInputAppDto() {
    userId = "";
    swingId = "";
    paintId = "";
    ownerId = "";

    startX = 0.0;
    startY = 0.0;
    endX = 0.0;
    endY = 0.0;
    color = 0;
    displayOrder = 0;
  }
}
