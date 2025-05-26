class RegisterPaintCircleInputAppDto {
  late String userId;
  late String swingId;
  late String paintId;
  late String ownerId;

  late double centerX;
  late double centerY;
  late double radius;
  late int color;
  late int displayOrder;

  RegisterPaintCircleInputAppDto() {
    userId = "";
    swingId = "";
    paintId = "";
    ownerId = "";

    centerX = 0.0;
    centerY = 0.0;
    radius = 0.0;
    color = 0;
    displayOrder = 0;
  }
}
