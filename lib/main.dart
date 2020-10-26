import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/music.dart';
import 'package:music_player/core/utils/controls.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/ui/constants/colors.dart';
import 'package:music_player/ui/home.dart';
import 'package:music_player/ui/splash.dart';
import 'package:provider/provider.dart';
import 'core/models/track.dart';
import 'ui/shared/theme.dart' as themes;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpLocator();
  runApp(MyApp());
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
  static bool isDarkMode = locator<SharedPrefs>().isDarkMode;
  // ThemeData theme = isDarkMode ?darkMaterialTheme;

  static ThemeData get theme =>
      isDarkMode ? themes.darkMaterialTheme : themes.primaryMaterialTheme;
  final AudioControls _controls = locator<AudioControls>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Track>.value(
      value: _controls.currentSongStream(),
      builder: (context, widget) => MaterialApp(
        title: 'Music Player',
        debugShowCheckedModeBanner: false,
        theme: theme,
        // theme: ThemeData(
        //   accentColor: ThemeColors.kPrimary,
        //   primarySwatch: Colors.blueGrey,
        //   appBarTheme: AppBarTheme(
        //     color: ThemeColors.kLightBg,
        //     iconTheme: IconThemeData(
        //       color: ThemeColors.kPrimary,
        //     ),
        //   ),
        //   visualDensity: VisualDensity.adaptivePlatformDensity,
        // ),
        home: SplashScreen(),
      ),
    );
  }
}