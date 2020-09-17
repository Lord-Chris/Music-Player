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

  List<Uint8List> artwork() {
    return _library.artworks;
  }

  onTap(int index) {}

  List _stuff = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<SongInfo> get musicList => _library.songs;
  List<AlbumInfo> get albumList => _library.albums;
  List<ArtistInfo> get artistList => _library.artists;
  List get stuff => _stuff;
  int get selected => _selected;
}
