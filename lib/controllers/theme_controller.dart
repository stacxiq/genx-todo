// we use provider to manage the app state

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

// Provider finished
class SettingsController extends GetxController {
  ///to use SettingsController.to instead Get.find<SettingsController>()
  static SettingsController get to => Get.find();

  @override
  onInit() {
    //The 3 functions is used when launching the app to get the settings data (theme, prefcolor, locale)
    //from the local database or set the default settings if it's the first time
    getThemeModeFromDataBase();
    getlocaleFromDataBase();
    getPrefColorFromDataBase();
  }

  Box settings;
  final prefColor = '0xFF76DC58'.obs;
  final _themeMode = ThemeMode.system.obs;
  final _locale = Locale('en').obs;
  Locale get locale => _locale.value;
  ThemeMode get themeMode => _themeMode.value;

  Future<void> setThemeMode(ThemeMode themeMode) async {
    Get.changeThemeMode(themeMode);
    _themeMode.value = themeMode;
    update();
    settings = await Hive.openBox('settings');
    await settings.put('theme', themeMode.toString().split('.')[1]);
  }

  getThemeModeFromDataBase() async {
    ThemeMode themeMode;
    settings = await Hive.openBox('settings');
    String themeText = settings.get('theme') ?? 'system';
    try {
      if (themeText == 'system') {
        themeMode = Get.isDarkMode ? ThemeMode.dark : ThemeMode.light;
      } else {
        themeMode =
            ThemeMode.values.firstWhere((e) => describeEnum(e) == themeText);
      }
    } catch (e) {
      themeMode = ThemeMode.system;
    }
    setThemeMode(themeMode);
  }

  Future<void> setLocale(Locale newLocale) async {
    Get.updateLocale(newLocale);
    _locale.value = newLocale;
    update();
    settings = await Hive.openBox('settings');
    await settings.put('languageCode', newLocale.languageCode);
  }

  getlocaleFromDataBase() async {
    Locale locale;
    settings = await Hive.openBox('settings');
    String languageCode =
        settings.get('languageCode') ?? Get.locale.languageCode;
    try {
      locale = Locale(languageCode);
    } catch (e) {
      locale = Locale('en');
    }
    setLocale(locale);
  }

  Future<void> setPrefColor(String newPrefColor) async {
    prefColor.value = newPrefColor;
    settings = await Hive.openBox('settings');
    await settings.put('prefrencesColor', newPrefColor);
  }

  getPrefColorFromDataBase() async {
    String prefColor;
    settings = await Hive.openBox('settings');
    String dbPrefColor = settings.get('prefrencesColor') ??
        (Get.isDarkMode ? '0xFF76DC58' : '0xFF000000');
    try {
      prefColor = dbPrefColor;
    } catch (e) {
      prefColor = '0xFF76DC58';
    }
    setPrefColor(prefColor);
  }

  static ThemeData themeData(bool isLightTheme) {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primarySwatch: Colors.grey,
      primaryColor: isLightTheme ? Colors.white : Color(0xFF494A67),
      brightness: isLightTheme ? Brightness.light : Brightness.dark,
      backgroundColor: isLightTheme ? Color(0xFFFFFFFF) : Color(0xFF424360),
      scaffoldBackgroundColor:
          isLightTheme ? Color(0xFFFFFFFF) : Color(0xFF424360),
      canvasColor: isLightTheme ? Colors.white : Color(0xFF494A67),
      cardColor: isLightTheme ? Colors.white : Color(0xFF494A67),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isLightTheme ? Colors.grey[100] : Color(0xFF494A67),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: const Color(0xffC5C3E3),
      ),
      appBarTheme: AppBarTheme(
          color: isLightTheme ? Colors.grey[100] : Color(0xFF494A67)),
    );
  }
}
