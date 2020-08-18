import 'package:get/get.dart';

import './ar.dart';
import './en.dart';

///To help Getx packege to tanslate the app
//if you want to add new word or sentens add it to both english and arabic maps
class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': englishMap,
        'ar': arabicMap,
      };
}
