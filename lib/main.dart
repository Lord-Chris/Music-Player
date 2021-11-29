// import 'package:device_preview/device_preview.dart';
// import 'package:flutter/foundation.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/core/services/player_controls/player_controls_impl.dart';
import 'package:music_player/ui/views/splash/splash.dart';
import 'package:provider/provider.dart';
import 'app/locator.dart';
import 'core/models/track.dart';
import 'core/services/player_controls/player_controls.dart';
import 'core/services/player_controls/testing controls.dart';
import 'ui/shared/theme_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await setUpLocator();
  await func();

  runApp(
    ChangeNotifierProvider<ThemeChanger>(
      create: (__) => locator<ThemeChanger>(),
      builder: (context, child) => MyApp(),
    ),
  );
}

void _entrypoint() async {
  // if (!AudioService.usesIsolate)
  await AudioServiceBackground.run(() => TestingControls());
}

func() async {
  print(AudioService.connected);
  print(AudioService.usesIsolate);
  print(AudioService.running);
  // if (!AudioService.connected) {
  // AudioService.
  await AudioService.connect();
  // }

  // if (!AudioService.running)
  await AudioService.start(
    backgroundTaskEntrypoint: _entrypoint,
    androidNotificationChannelName: 'Musicool',
    androidNotificationColor: 0xFF2196f3,
    androidNotificationIcon: 'mipmap/ic_launcher',
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final IPlayerControls _controls = locator<IPlayerControls>();
  @override
  void dispose() {
    AudioService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return StreamProvider<Track?>.value(
      value: currentSongStream(),
      initialData: _controls.getCurrentTrack(),
      builder: (context, widget) => MaterialApp(
        title: 'Music Player',
        debugShowCheckedModeBanner: false,
        theme: _themeChanger.theme,
        home: AudioServiceWidget(child: SplashScreen()),
      ),
    );
  }

  Stream<Track?> currentSongStream() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 300));
      yield _controls.getCurrentTrack();
    }
  }
}
