import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/core/models/albums.dart';
import 'package:music_player/core/models/artists.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/ui/constants/pref_keys.dart';

import 'i_local_storage_service.dart';

class LocalStorageService extends ILocalStorageService {
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TrackAdapter());
    Hive.registerAdapter(TrackListAdapter());
    Hive.registerAdapter(AlbumAdapter());
    Hive.registerAdapter(AlbumListAdapter());
    Hive.registerAdapter(ArtistAdapter());
    Hive.registerAdapter(ArtistListAdapter());
    await openBox(boxId: APP_NAME);
  }

  Future<Box<T>> openBox<T>({required String boxId}) async {
    assert(boxId.isNotEmpty);
    bool _boxIsIOpen = Hive.isBoxOpen(boxId);
    if (_boxIsIOpen) return Hive.box(boxId);
    return await Hive.openBox(boxId);
  }

  Future<void> writeToBox<T>(String key, T data, {String? boxId}) async {
    assert(key.isNotEmpty);
    final _box = await openBox(boxId: boxId ?? APP_NAME);
    await _box.put(key, data);
    print("DATA STORED TO BOX...");
  }

  T getFromBox<T>(String key, {String? boxId, T? def}) {
    assert(key.isNotEmpty, "Key Must not be empty");
    final _box = Hive.box(boxId ?? APP_NAME);
    // print("DATA GOTTEN FROM BOX...");
    return _box.get(key, defaultValue: def) as T;
  }
}
