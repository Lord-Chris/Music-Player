import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/core/models/music.dart';

class PlaylistProvider extends ChangeNotifier {
  Music _library = Music();
  int _selected = 0;

  set selected(index) {
    _selected = index;
    notifyListeners();
  }

  onTap(int index) {}

  List<SongInfo> get musicList => _library.songs;
  List<AlbumInfo> get albumList => _library.albums;
  List<ArtistInfo> get artistList => _library.artists;
  int get selected => _selected;
}
