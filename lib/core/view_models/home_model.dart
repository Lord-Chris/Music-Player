import 'package:flutter/material.dart';

class HomeModel extends ChangeNotifier {
  int _selected = 0;

  set selected(index) {
    _selected = index;
    notifyListeners();
  }

  onTap(int index) {
    selected = index;
  }

  int get selected => _selected;
}
