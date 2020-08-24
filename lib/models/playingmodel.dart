import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlayingProvider extends ChangeNotifier {
  String _musicName = 'My Audience';
  String _albumName = 'Artist - Derbyaba Album';
  double _sliderPosition = 0.1;

  void onSliderChange(double val) {
    _sliderPosition = val;
    notifyListeners();
  }

  
  String get musicName => _musicName;
  String get albumName => _albumName;
  double get sliderPosition => _sliderPosition;
  // double get onSliderChange => _onSliderChange(val);
}
