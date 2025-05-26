class GraphCircleInfoAppDto {
  late String title;
  late double circleData;

  GraphCircleInfoAppDto() {
    title = "";
    circleData = 0.0;
  }

  GraphCircleInfoAppDto.input(final String inputTitle, final double inputCircleData) {
    title = inputTitle;
    circleData = inputCircleData;
  }
}
