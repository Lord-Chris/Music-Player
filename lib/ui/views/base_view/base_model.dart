import 'package:flutter/material.dart';
import 'package:musicool/core/enums/viewState.dart';

class BaseModel extends ChangeNotifier {
  ViewState _state = ViewState.Idle;

  void setState([ViewState? state]) {
    if (state == null) {
      _state = ViewState.Idle;
    } else {
      _state = state;
    }
    notifyListeners();
  }

  ViewState get state => _state;
}
