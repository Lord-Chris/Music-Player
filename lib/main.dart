// import 'package:device_preview/device_preview.dart';
// import 'package:flutter/foundation.dart';
// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/ui/views/splash/splash.dart';
import 'package:provider/provider.dart';
import 'app/locator.dart';
import 'core/models/track.dart';
import 'core/services/player_controls/player_controls.dart';
import 'ui/shared/theme_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await setUpLocator();

  // AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
  //   //custom action
  //   return true; //true : handled, does not notify others listeners
  //   //false : enable others listeners to handle it
  // });

  // AssetsAudioPlayer.addNotificationOpenAction((notification) {
  //   //custom action
  //   return false; //true : handled, does not notify others listeners
  //   //false : enable others listeners to handle it
  // });

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
  final IPlayerControls _controls = locator<IPlayerControls>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    hemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return StreamProvider<Track>.value(
      value: null, //_controls.currentSongStream(),
      builder: (context, widget) => MaterialApp(
        title: 'Music Player',
        debugShowCheckedModeBanner: false,
        theme: _themeChanger.theme,
        home: SplashScreen(),
      ),
      initialData: Track(),
    );
  }
}
