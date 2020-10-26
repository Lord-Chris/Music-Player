import 'package:flutter/material.dart';
import 'package:music_player/core/enums/viewState.dart';

class BaseModel extends ChangeNotifier {
  ViewState _state = ViewState.Idle;

  set appState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  ViewState get appState => _state;
}
