// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility that Flutter provides. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'package:assets_audio_player/assets_audio_player.dart' as pl;
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:musicool/app/locator.dart';
// import 'package:musicool/core/models/track.dart';
// import 'package:musicool/core/utils/controls/controls_util.dart';
// import 'package:musicool/core/utils/sharedPrefs.dart';
// import 'package:musicool/main.dart';
// import 'package:musicool/ui/constants/pref_keys.dart';
// import 'package:musicool/ui/constants/unique_keys.dart';
// import 'package:musicool/ui/views/home/home.dart';
// import 'package:musicool/ui/views/my_drawer/my_drawer.dart';
// import 'package:musicool/ui/views/playing/playing.dart';
// import 'package:musicool/ui/shared/theme_model.dart';
// import 'package:musicool/ui/splash.dart';
// import 'package:provider/provider.dart';
// import 'package:mockito/mockito.dart';

// class MockControls extends Mock implements IAudioControls {}

// List<Track> mockSongs = [
//   Track(id: '1', title: 'Song 1', artist: 'Artist 1', duration: '10000'),
//   Track(id: '2', title: 'Song 2', artist: 'Artist 2', duration: '10000'),
//   Track(id: '3', title: 'Song 3', artist: 'Artist 3', duration: '10000'),
//   Track(id: '4', title: 'Song 4', artist: 'Artist 4', duration: '10000'),
//   Track(id: '5', title: 'Song 5', artist: 'Artist 5', duration: '10000'),
// ];

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();
//   setUpAll(() async {
//     setUpLocator();
//     locator.allowReassignment = true;
//   });
//   MockControls controls = MockControls();

//   Widget makeTestableWidget(Widget widget) {
//     return ChangeNotifierProvider<ThemeChanger>(
//       create: (__) => locator<ThemeChanger>(),
//       builder: (context, child) => StreamProvider<Track>.value(
//         value: controls.currentSongStream(),
//         builder: (context, child) {
//           print(widget);
//           return MaterialApp(
//             home: widget ?? SplashScreen(),
//           );
//         },
//       ),
//     );
//   }

//   testWidgets('Splash screen shows', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.runAsync(() async {
//       await tester.pumpWidget(
//         ChangeNotifierProvider<ThemeChanger>(
//           create: (__) => locator<ThemeChanger>(),
//           builder: (context, child) => MyApp(),
//         ),
//       );
//     });

//     // Verify that the splash screen shows.
//     expect(find.text('Musicool'), findsOneWidget);
//     // print('reached here');
//   });

//   group('Home Screen test', () {
//     testWidgets('Home Widget test', (WidgetTester tester) async {
//       await tester.pumpWidget(makeTestableWidget(Home()));
//       await tester.pump();

//       // checks that the screen opens
//       expect(find.byKey(UniqueKeys.HOMECONTAINER, skipOffstage: false),
//           findsOneWidget);

//       // checks that the music bar shows
//       expect(find.byKey(UniqueKeys.MUSICBARCONTAINER, skipOffstage: false),
//           findsOneWidget);

//       await tester
//           .tap(find.byKey(UniqueKeys.MUSICBARCONTAINER, skipOffstage: false));
//       await tester.pump();

//       // checks that the music bar and home page aren't showing
//       expect(find.byKey(UniqueKeys.HOMECONTAINER, skipOffstage: false),
//           findsOneWidget);
//       expect(find.byKey(UniqueKeys.MUSICBARCONTAINER, skipOffstage: false),
//           findsOneWidget);
//     });

//     testWidgets('check that theme changes work well first time the app starts',
//         (WidgetTester tester) async {
//       locator.registerLazySingleton(() => ThemeChanger());
//       SharedPrefs prefs = locator<SharedPrefs>();

//       prefs.removedata('isDarkMode');
//       await tester.pumpWidget(makeTestableWidget(MyDrawer()));

//       //check that isDark mode data has been removed
//       expect(prefs.readBool(ISDARKMODE), isNull);

//       //tap the dark mode changer switch
//       expect(find.text('Dark Mode'), findsOneWidget);
//       await tester.tap(find.byKey(UniqueKeys.DARKMODE));
//       await tester.pump();

//       //check that isDark mode data is no longer null
//       expect(prefs.readBool(ISDARKMODE), isNotNull);
//     });

//     testWidgets('if theme is dark, check that is light when it is changed',
//         (WidgetTester tester) async {
//       // initialize classes and set is dark mode to false
//       SharedPrefs prefs = locator<SharedPrefs>();
//       prefs.saveBool(ISDARKMODE, false);
//       locator.registerLazySingleton(() => ThemeChanger());
//       ThemeChanger theme = locator<ThemeChanger>();

//       await tester.pumpWidget(makeTestableWidget(MyDrawer()));

//       // check that dark mode is false and theme is light
//       expect(prefs.readBool(ISDARKMODE), false);
//       expect(theme.theme.brightness, Brightness.light);

//       //tap the dark mode changer switch
//       expect(find.text('Dark Mode'), findsOneWidget);
//       await tester.tap(find.byKey(UniqueKeys.DARKMODE));
//       await tester.pump();

//       // check that dark mode is true and theme is dark
//       expect(prefs.readBool(ISDARKMODE), isNotNull);
//       expect(prefs.readBool(ISDARKMODE), true);
//       expect(theme.theme.brightness, Brightness.dark);
//     });
//   });

//   testWidgets('PlayingScreen tests', (WidgetTester tester) async {
//     locator<SharedPrefs>().setmusicList(mockSongs);

//     await tester.pumpWidget(
//       makeTestableWidget(Playing(songId: mockSongs[1].id)),
//     );
//     // await tester.pump();

//     // nowplaying screen should show and play button should be showing
//     expect(
//         find.byKey(UniqueKeys.NOWPLAYING, skipOffstage: false), findsOneWidget);
//     expect(
//         find.byKey(UniqueKeys.PAUSEPLAY, skipOffstage: false), findsOneWidget);

//     //check that the music is playing
//     expect(locator<SharedPrefs>().getCurrentSong(), isNotNull);
//     expect(locator<IAudioControls>().state, pl.PlayerState.play);

//     // expect(find.byIcon(MdiIcons.play, skipOffstage: false), findsOneWidget);

//     // // tap the play button to pause the song
//     // await tester.tap(find.byKey(UniqueKeys.PAUSEPLAY));
//     // await tester.runAsync(() async {
//     //   controls.playAndPause();
//     // });
//     // await tester.pump();

//     // expect(locator<AudioControls>().state, AudioPlayerState.PAUSED);

//     // expect(locator<SharedPrefs>().currentSong, isNotNull);
//     // expect(find.byIcon(MdiIcons.play, skipOffstage: false), findsNothing);
//   });
// }
