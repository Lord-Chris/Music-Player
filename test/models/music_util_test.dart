import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:music_player/app/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/music_util.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';

class MockMusic extends Mock implements IMusic {}

List<Track> mockSongs = [
  Track(id: '1', title: 'Song 1', artist: 'Artist 1', duration: '10000'),
  Track(id: '2', title: 'Song 2', artist: 'Artist 2', duration: '10000'),
  Track(id: '3', title: 'Song 3', artist: 'Artist 3', duration: '10000'),
  Track(id: '4', title: 'Song 4', artist: 'Artist 4', duration: '10000'),
  Track(id: '5', title: 'Song 5', artist: 'Artist 5', duration: '10000'),
];

main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MockMusic _music = MockMusic();

  group('songs loading', () {
    setUpAll(() {
      setUpLocator();
    });

    test('check that music list is not null after the first fetching music',
        () async {
      // Music music = Music();
      SharedPrefs prefs = await SharedPrefs.getInstance();
      await prefs.removedata('music_list');
      expect(prefs.getmusicList(), isEmpty);
      expect(prefs.getmusicList(), isNotNull);
      await _music.songsList();
      expect(prefs.getmusicList(), isNotNull);
    });
  });
}
