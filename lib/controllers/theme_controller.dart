// we use provider to manage the app state

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class SettingsController extends GetxController {
  ///to use SettingsController.to instead Get.find<SettingsController>()
  static SettingsController get to => Get.find();

  @override
  // ignore: type_annotate_public_apis
  onInit() {
    super.onInit();
    settings = await Hive.openBox('settings');
    //To indicate if it is the first time the user opens the app
    _firstTime.value = settings.get("firstTime") ?? true;
    print(_firstTime.value);
    //The 3 functions is used when launching the app to get the settings data (theme, prefcolor, locale)
    //from the local database or set the default settings if it's the first time
    _getThemeModeFromDataBase();
    _getlocaleFromDataBase();
    _getPrefColorFromDataBase();
  }

  Box settings;
  final prefColor = '0xFF76DC58'.obs;
  final _themeMode = ThemeMode.system.obs;
  final _locale = const Locale('en').obs;
  final _firstTime = true.obs;
  Locale get locale => _locale.value;
  ThemeMode get themeMode => _themeMode.value;
  bool get firstTime => _firstTime.value;

  Future<void> setThemeMode(ThemeMode themeMode) async {
    Get.changeThemeMode(themeMode);
    _themeMode.value = themeMode;
    update();
    // settings = await Hive.openBox('settings');
    await settings.put('theme', themeMode.toString().split('.')[1]);
  }

  _getThemeModeFromDataBase() async {
    ThemeMode themeMode;
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
    // settings = await Hive.openBox('settings');
    await settings.put('languageCode', newLocale.languageCode);
  }

  _getlocaleFromDataBase() async {
    Locale locale;
    String languageCode =
        settings.get('languageCode') ?? Get.locale.languageCode;
    try {
      locale = Locale(languageCode);
    } catch (e) {
      locale = const Locale('en');
    }
    setLocale(locale);
  }

  Future<void> setPrefColor(String newPrefColor) async {
    prefColor.value = newPrefColor;
    // settings = await Hive.openBox('settings');
    await settings.put('prefrencesColor', newPrefColor);
  }

  _getPrefColorFromDataBase() async {
    String prefColor;
    String dbPrefColor = settings.get('prefrencesColor') ??
        (Get.isDarkMode ? '0xFF76DC58' : '0xFFCC6462');
    try {
      prefColor = dbPrefColor;
    } catch (e) {
      prefColor = '0xFF76DC58';
    }
    setPrefColor(prefColor);
  }

  static ThemeData themeData({bool isLightTheme = true}) {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primarySwatch: Colors.grey,
      primaryColor: isLightTheme ? Colors.white : const Color(0xFF494A67),
      brightness: isLightTheme ? Brightness.light : Brightness.dark,
      backgroundColor:
          isLightTheme ? const Color(0xFFFFFFFF) : const Color(0xFF424360),
      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: Color(0xFF737373)),
      scaffoldBackgroundColor:
          isLightTheme ? const Color(0xFFFFFFFF) : const Color(0xFF424360),
      canvasColor: isLightTheme ? Colors.white : const Color(0xFF494A67),
      cardColor: isLightTheme ? Colors.white : const Color(0xFF494A67),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:
            isLightTheme ? Colors.grey[100] : const Color(0xFF494A67),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: const Color(0xffC5C3E3),
      ),
      appBarTheme: AppBarTheme(
          color: isLightTheme ? Colors.grey[100] : const Color(0xFF494A67)),
    );
  }
}
