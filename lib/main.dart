import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app/index.dart';
import 'core/managers/core_manager.dart';
import 'core/services/_services.dart';
import 'ui/shared/theme_model.dart';

final SentryClient _sentry = SentryClient(SentryOptions(
  dsn:
      "https://96fa259faede4385a21bd53f3985f836@o417686.ingest.sentry.io/5318792",
));

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  // SystemChrome.

  /// This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      /// In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      /// In production mode report to the application zone to report to Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  runZonedGuarded(() async {
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://b8933a69d5614bf490cbab24b174e0f4@o510533.ingest.sentry.io/6266908';
        options.tracesSampleRate = 1.0;
      },
      appRunner: () async {
        await setUpLocator();

        runApp(
          DevicePreview(
            enabled: !kReleaseMode,
            builder: (_) => ChangeNotifierProvider<ThemeChanger>(
              create: (__) => locator<ThemeChanger>(),
              builder: (context, child) => const MyApp(),
            ),
          ),
        );
      },
    );
  }, (error, stackTrace) async {
    // Whenever an error occurs,c all the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
    await _reportError(error, stackTrace);
  });
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  // Print the exception to the console.
  debugPrint('Caught error: $error');
  if (isInDebugMode) {
    // Print the full stacktrace in debug mode.
    debugPrint(stackTrace);
  } else {
    // Send the Exception and Stacktrace to Sentry in Production mode.
    Sentry.addBreadcrumb(Breadcrumb(
      category: 'data.media',
      message: error.toString(),
      level: SentryLevel.debug,
      data: locator<IAppAudioService>().logData(),
      timestamp: DateTime.now(),
    ));
    _sentry.captureException(error, stackTrace: stackTrace);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: () {
        return CoreManager(
          child: MaterialApp(
            title: APP_NAME,
            debugShowCheckedModeBanner: false,
            theme: klightTheme,
            navigatorKey: NavigationService.navigatorKey,
            onGenerateRoute: Routes.generateRoute,
            scrollBehavior: const CupertinoScrollBehavior(),
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            navigatorObservers: [
              SentryNavigatorObserver(),
            ],
          ),
        );
      },
    );
  }
}

// playing slide down
// shadow for the playing screen
