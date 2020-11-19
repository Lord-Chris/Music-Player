// import 'package:device_preview/device_preview.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/utils/controls_util.dart';
import 'package:music_player/ui/splash.dart';
import 'package:provider/provider.dart';
import 'core/models/track.dart';
import 'ui/shared/theme_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await setUpLocator();

  runApp(
    ChangeNotifierProvider<ThemeChanger>(
      create: (__) => locator<ThemeChanger>(),
      builder: (context, child) => MyApp(),
    ),
  );
}
// void main() {
//   setUpLocator();
//   runApp(
//      DevicePreview(
//        enabled: !kReleaseMode,
//        builder: (context) => MyApp(),
//      ),
//    );
// }

class MyApp extends StatelessWidget {
  final AudioControls _controls = locator<AudioControls>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return StreamProvider<Track>.value(
      value: _controls.currentSongStream(),
      builder: (context, widget) => MaterialApp(
        title: 'Music Player',
        debugShowCheckedModeBanner: false,
        theme: _themeChanger.theme,
        home: SplashScreen(),
      ),
    );
  }
}
