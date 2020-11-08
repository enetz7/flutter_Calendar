import 'package:flutter/cupertino.dart';

class Contenedor {
  Color containerColor;
  String text;
  int rowCount;
  String numberClass;
  String teacher;
  // constructor
  Contenedor(Color containerColor, String text, int rowCount, String teacher,
      String numberClass) {
    this.containerColor = containerColor;
    this.text = text;
    this.rowCount = rowCount;
    this.numberClass = numberClass;
    this.teacher = teacher;
  }
}
