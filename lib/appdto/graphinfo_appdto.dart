class GraphInfoAppDto {
  late double xAxis;
  late double yAxis;
  late double? size;

  GraphInfoAppDto() {
    xAxis = 0.0;
    yAxis = 0.0;
    size = 0.0;
  }

  GraphInfoAppDto.init(this.xAxis, this.yAxis, [this.size]);
}
