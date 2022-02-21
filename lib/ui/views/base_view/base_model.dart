import 'package:flutter/material.dart';
import 'package:musicool/core/enums/_enums.dart';

class BaseModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;

  void setState([ViewState? state]) {
    if (state == null) {
      _state = ViewState.idle;
    } else {
      _state = state;
    }
    notifyListeners();
  }

  ViewState get state => _state;
}
