import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/music.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/ui/home.dart';
import 'package:music_player/ui/splash.dart';
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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      debugShowCheckedModeBanner: false,
      theme: theme,
      // theme: ThemeData(
      //   accentColor: kPrimary,
      //   primarySwatch: Colors.blueGrey,
      //   appBarTheme: AppBarTheme(
      //     color: kbgColor,
      //     iconTheme: IconThemeData(
      //       color: kPrimary,
      //     ),
      //   ),
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      home: SplashScreen(),
    );
  }
}

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   SharedPrefs _sharedPrefs = locator<SharedPrefs>();
//   Music _music = locator<Music>();

//   loading() async {
//     if (_sharedPrefs.musicList == null) {
//       await _music.setupLibrary();
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => Home()));
//     } else {
//       await Future.delayed(Duration(seconds: 3));
//       _music.setupLibrary();
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => Home()));
//     }
//   }

//   @override
//   void initState() {
//     loading();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
