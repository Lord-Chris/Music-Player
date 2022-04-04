import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicool/app/index.dart';
import 'package:musicool/core/enums/app_player_state.dart';
import 'package:musicool/core/enums/repeat.dart';
import 'package:musicool/core/models/albums.dart';
import 'package:musicool/core/models/artists.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/ui/constants/pref_keys.dart';

import 'i_local_storage_service.dart';

class LocalStorageService extends ILocalStorageService {
  final _log = Logger();
  @override
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TrackAdapter(), override: true);
    Hive.registerAdapter(TrackListAdapter());
    Hive.registerAdapter(AlbumAdapter(), override: true);
    Hive.registerAdapter(AlbumListAdapter());
    Hive.registerAdapter(ArtistAdapter(), override: true);
    Hive.registerAdapter(ArtistListAdapter());
    Hive.registerAdapter(RepeatAdapter());
    Hive.registerAdapter(AppPlayerStateAdapter());
    await openBox(boxId: APP_NAME);
  }

  @override
  Future<Box<T>> openBox<T>({required String boxId}) async {
    assert(boxId.isNotEmpty);
    bool _boxIsIOpen = Hive.isBoxOpen(boxId);
    if (_boxIsIOpen) return Hive.box(boxId);
    return await Hive.openBox(boxId);
  }

  @override
  Future<void> writeToBox<T>(String key, T data, {String? boxId}) async {
    assert(key.isNotEmpty);
    final _box = await openBox(boxId: boxId ?? APP_NAME);
    await _box.put(key, data);
    _log.d("DATA STORED TO BOX...");
  }

  @override
  T getFromBox<T>(String key, {String? boxId, T? def}) {
    assert(key.isNotEmpty, "Key Must not be empty");
    final _box = Hive.box(boxId ?? APP_NAME);
    // print("DATA GOTTEN FROM BOX...");
    return _box.get(key, defaultValue: def) as T;
  }

  @override
  Future<void> clearBox({String? boxId}) async {
    final _box = Hive.box(boxId ?? APP_NAME);
    await _box.clear();
  }
}
