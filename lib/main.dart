import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:provider/provider.dart';
import 'package:todolist/localization/demo_localizations.dart';
import 'package:todolist/ui/pages/home_page.dart';

import 'models/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await pathProvider.getApplicationDocumentsDirectory();

  Hive.init(appDocumentDirectory.path);

  final settings = await Hive.openBox('settings');
  bool isLightTheme = settings.get('isLightTheme') ?? false;
  String prefrencesColor = settings.get('prefrencesColor') ?? '0xFF76DC58';
  String languageCode = settings.get('languageCode') ?? 'en';

  runApp(ChangeNotifierProvider(
    create: (_) => ThemeProvider(
        isLightTheme: isLightTheme,
        prefrencesColor: prefrencesColor,
        languageCode: languageCode),
    child: GenixApp(),
  ));
}

class GenixApp extends StatefulWidget with WidgetsBindingObserver {
  @override
  _GenixAppState createState() => _GenixAppState();
}

class _GenixAppState extends State<GenixApp> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    Locale _locale = Locale(themeProvider.languageCode);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Light Dark Theme',
      theme: themeProvider.themeData(),
      home: GenixTodo(),
      locale: _locale,
      supportedLocales: [
        const Locale('en'),
        const Locale('ar'),
      ],
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DemoLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (var locale in supportedLocales) {
          if (locale.languageCode == deviceLocale.languageCode) {
            return locale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}
