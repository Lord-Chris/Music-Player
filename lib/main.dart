import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicool/ui/constants/pref_keys.dart';
import 'package:musicool/ui/constants/theme.dart';
import 'package:musicool/ui/views/splash/splash.dart';
import 'package:provider/provider.dart';
import 'app/locator.dart';
import 'core/models/track.dart';
import 'core/services/player_controls/player_controls.dart';
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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final IPlayerControls _controls = locator<IPlayerControls>();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return StreamProvider<Track?>.value(
      value: currentSongStream(),
      initialData: _controls.getCurrentTrack(),
      builder: (context, widget) => MaterialApp(
        title: APP_NAME,
        debugShowCheckedModeBanner: false,
        theme: _themeChanger.theme,
        darkTheme: kdarkTheme,
        home: SplashScreen(),
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
