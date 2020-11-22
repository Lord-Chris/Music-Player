import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:music_player/app/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/controls/controls_util.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';

List<String> track = ['song', 'please', 'dance', 'with me'];
List<Track> mockSongs = [
  Track(id: '1', title: 'Song 1', artist: 'Artist 1', duration: '10000'),
  Track(id: '2', title: 'Song 2', artist: 'Artist 2', duration: '10000'),
  Track(id: '3', title: 'Song 3', artist: 'Artist 3', duration: '10000'),
  Track(id: '4', title: 'Song 4', artist: 'Artist 4', duration: '10000'),
  Track(id: '5', title: 'Song 5', artist: 'Artist 5', duration: '10000'),
];

class MockControls extends Mock implements IAudioControls {}

main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    setUpLocator();
    locator.allowReassignment = true;
  });
  group('test concerning the index when shuffle is off', () {
    test('index should increase after next() is called', () async {
      locator.registerLazySingleton(() => MockControls());
      IAudioControls cont = locator<IAudioControls>();
      cont.songs = track.map((e) => Track(title: e)).toList();
      cont.index = 0;

      await cont.next();

      expect(cont.index, 1);
    });

    test('index should decrease after previous() is called', () async {
      locator.registerLazySingleton(() => MockControls());
      IAudioControls cont = locator<IAudioControls>();
      cont.songs = track.map((e) => Track(title: e)).toList();
      cont.index = 0;

      await cont.previous();

      expect(cont.index, 3);
    });
  });

  group('tests concerning favorite songs', () {
    test('when a song is added to favorites, the length should increase by one',
        () async {
      locator.registerLazySingleton(() => MockControls());
      IAudioControls cont = locator<IAudioControls>();

      SharedPrefs _prefs = await SharedPrefs.getInstance();
      await _prefs.removedata('favorites');
      int length = _prefs.favorites.length;
      expect(_prefs.favorites, isEmpty);
      expect(length, 0);

      cont.toggleFav(mockSongs[0]);

      expect(_prefs.favorites, isNotEmpty);
      expect(_prefs.favorites.length, 1);
    });

    test(
        'when a song is removed from favorites, the length should decrease by one',
        () async {
      locator.registerLazySingleton(() => MockControls());
      IAudioControls cont = locator<IAudioControls>();

      SharedPrefs _prefs = await SharedPrefs.getInstance();
      _prefs.favorites = mockSongs;
      List<Track> favs = _prefs.favorites;
      
      expect(favs, isNotEmpty);
      expect(favs.length, 5);

      cont.toggleFav(mockSongs[0]);

      expect(_prefs.favorites, isNotEmpty);
      expect(_prefs.favorites.length, 4);
    });
  });
}
