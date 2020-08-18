import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

import './ui/pages/home_page.dart';
import './localization/localizations.dart';
import './controllers/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  //initialize setting controller
  Get.lazyPut<SettingsController>(() => SettingsController());

  runApp(GenxApp());
}

class GenxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<SettingsController>(
        init: SettingsController(),
        builder: (_) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Genx todo',
            theme: SettingsController.themeData(true),
            darkTheme: SettingsController.themeData(false),
            home: GenxTodo(),
            locale: _.locale,
            themeMode: ThemeMode.system,
            translations: MyTranslations(),
            supportedLocales: [
              const Locale('en'),
              const Locale('ar'),
            ],
            localizationsDelegates: [
              // ... app-specific localization delegate[s] here
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        });
  }
}
