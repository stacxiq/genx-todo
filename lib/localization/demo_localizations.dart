import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DemoLocalizations {
  DemoLocalizations(this.locale);

  final Locale locale;

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  static Map<String, String> _localizedValues;

  Future load() async {
    String jasonStringValues =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');

    Map<String, dynamic> mappedJson = json.decode(jasonStringValues);
    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  static const LocalizationsDelegate<DemoLocalizations> delegate =
      _DemoLocalizationsDelegate();

  String translate(String key) {
    return _localizedValues[key] ?? key;
  }
}

class _DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalizations> {
  const _DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) async {
    DemoLocalizations localizations = DemoLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(old) => false;
}
