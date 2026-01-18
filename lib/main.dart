import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/main_view.dart';
import 'providers/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final pubspec = Pubspec.parse(await rootBundle.loadString('pubspec.yaml'));
  final version = pubspec.version;
  debugPrint('version from pubspec.yaml: $version');
  await sharedPreferences.setString('appVersion', version.toString());
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
//    observers: [AsyncErrorLogger()],
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Custom dark theme with lighter surfaces for better usability
    final darkTheme = MacosThemeData.dark().copyWith(
      // Lighter canvas background (default is RGB 40,40,40)
      canvasColor: const Color.fromRGBO(56, 56, 56, 1.0),
      // Lighter popup menus
      popupButtonTheme: const MacosPopupButtonThemeData(
        popupColor: Color.fromRGBO(50, 50, 50, 1.0),
      ),
      // Lighter pulldown menus
      pulldownButtonTheme: const MacosPulldownButtonThemeData(
        pulldownColor: Color.fromRGBO(50, 50, 50, 1.0),
      ),
      // Lighter search results background
      searchFieldTheme: const MacosSearchFieldThemeData(
        resultsBackgroundColor: Color.fromRGBO(50, 50, 50, 1.0),
      ),
    );

    return MacosApp(
      title: 'Flutter Cleaner',
      theme: MacosThemeData.light(),
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const MainView(),
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
    );
  }
}
