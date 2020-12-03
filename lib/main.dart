import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import './controllers/pomodoro_controller.dart';

import './ui/pages/home_page.dart';
import './localization/localizations.dart';
import './controllers/theme_controller.dart';
import './controllers/task_controller.dart';

//TODO: things to be done
//1- Comlete the notfication functionality
//2- Link pomodoro to notification and add the ability to stop the alarm
//3- Notify the user when the task reaches it's due date
//4- Add the app icon and splash screen
//5- Add multi select feature to remove multiple tasks at once
//future stuff:
//1- Add the abbility to repeat the task
//2- add note-taking functionality

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  //initialize setting & Task controller lazily
  Get.lazyPut<SettingsController>(() => SettingsController());
  Get.put<TaskController>(TaskController());
  Get.put<PomodoroController>(PomodoroController());
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
            theme: SettingsController.themeData()
                .copyWith(accentColor: Color(int.parse(_.prefColor.value))),
            darkTheme: SettingsController.themeData(isLightTheme: false)
                .copyWith(accentColor: Color(int.parse(_.prefColor.value))),
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
