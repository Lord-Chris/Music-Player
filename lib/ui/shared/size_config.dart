import 'package:flutter/material.dart';

class SizeConfig {
  static double xMargin(context, width) {
    double _screenWidth = MediaQuery.of(context).size.width / 100;
    return width * _screenWidth;
  }

  static double yMargin(context, height) {
    double _screenHeight = MediaQuery.of(context).size.height / 100;
    return height * _screenHeight;
  }

  static double textSize(context, size) {
    double _screenWidth = MediaQuery.of(context).size.width / 100;
    double _screenHeight = MediaQuery.of(context).size.height / 100;
    if (_screenHeight < _screenWidth) return _screenHeight * size;
    return _screenWidth * size;
  }

  static double screenHeight(
    context,
  ) {
    double height = MediaQuery.of(context).size.height;
    double padding = MediaQuery.of(context).padding.vertical;
    return height - padding;
  }
}
