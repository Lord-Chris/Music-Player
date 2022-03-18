import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/ui/widget/music_bar.dart';
import 'package:provider/provider.dart';

import 'package:musicool/ui/constants/colors.dart';
import 'package:musicool/ui/constants/pref_keys.dart';

import 'app/index.dart';
import 'core/models/track.dart';
import 'core/services/_services.dart';
import 'ui/shared/theme_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await setUpLocator();

  runApp(
    ChangeNotifierProvider<ThemeChanger>(
      create: (__) => locator<ThemeChanger>(),
      builder: (context, child) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return CoreManager(
      child: MaterialApp(
        title: APP_NAME,
        debugShowCheckedModeBanner: false,
        theme: _themeChanger.theme,
        // darkTheme: kdarkTheme,
        navigatorKey: NavigationService.navigatorKey,
        onGenerateRoute: Routes.generateRoute,
        scrollBehavior: const CupertinoScrollBehavior(),
      ),
    );
  }

  // Stream<Track?> currentSongStream() async* {
  //   while (true) {
  //     await Future.delayed(const Duration(milliseconds: 300));
  //     yield _controls.getCurrentTrack();
  //   }
  // }
}

class CoreManager extends StatefulWidget {
  final Widget child;
  const CoreManager({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<CoreManager> createState() => _CoreManagerState();
}

class _CoreManagerState extends State<CoreManager> with WidgetsBindingObserver {
  final _appAudioService = locator<IAppAudioService>();
  final _playerService = locator<IPlayerService>();
  final _handler = locator<AudioHandler>();
  late StreamSubscription<AppPlayerState> stateSub;

  // final List _services = [
  //   locator<IPlayerService>(),
  //   locator<IAppAudioService>(),
  // ];

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    _setUp();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('APP STATE = $state');
    if (state == AppLifecycleState.inactive) {
      _appAudioService.pause();
      stateSub.pause();
    } else if (state == AppLifecycleState.resumed) {
      _appAudioService.resume();
      stateSub.resume();
    }
  }

  _setUp() {
    stateSub =
        _appAudioService.playerStateController.stream.listen((data) async {});
    stateSub.onData((data) async {
      // print("CHANGE OCCUREEDDDD");
      List<Track> list;
      if (data != _appAudioService.playerState) {
        list = _appAudioService.currentTrackList;

        if (data == AppPlayerState.Finished) {
          if (_playerService.repeatState == Repeat.One) {
            await _handler.play();
          } else if (_playerService.repeatState == Repeat.All) {
            await _handler.skipToNext();
          } else if (_playerService.repeatState == Repeat.Off &&
              _appAudioService.currentTrack!.index! != list.length - 1) {
            await _handler.skipToNext();
          }
        }
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Track?>.value(
      value: _appAudioService.currentTrackController.stream,
      initialData: _appAudioService.currentTrack,
      builder: (context, _) => AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.darkMain,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.darkMain,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: widget.child,
      ),
    );
  }
}