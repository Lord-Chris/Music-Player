import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlaylistProvider extends ChangeNotifier{
  String _musicSection = 'Favourites';
  String _musicAlbum = 'Drake Album Songs';
  String _musicList = '270 Songs';

  
 

  
  String get musicSection => _musicSection;
  String get musicAlbum => _musicAlbum;
  String get musicList => _musicList;
 
 
}




