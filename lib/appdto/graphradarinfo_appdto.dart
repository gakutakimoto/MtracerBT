import 'package:flutter/material.dart';

class GraphRadarInfoAppDto {
  late Color color;
  late List<double> values;

  GraphRadarInfoAppDto() {
    color = Colors.transparent;
    values = [];
  }

  GraphRadarInfoAppDto.init(this.color, this.values);
}
