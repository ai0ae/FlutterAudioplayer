// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String LAGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';
const String KAZAKH = 'kk';
const String RUSSIAN = 'ru';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? languageCode = prefs.getString(LAGUAGE_CODE);

  if (languageCode == null) {
    //frist launch
    String sysLang = PlatformDispatcher.instance.locale.languageCode; //Language selection
// should work as follows: By default, the app
// should automatically set the language based
// on the system language. 

    languageCode = isLanguageSupported(sysLang) ? sysLang : KAZAKH;
  }
  return _locale(languageCode);
}

bool isLanguageSupported(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return true;
    case KAZAKH:
      return true;
    case RUSSIAN:
      return true;
    default:
      return false;
  }
}
Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, '');
    case KAZAKH:
      return const Locale(KAZAKH, "");
    case RUSSIAN:
      return const Locale(RUSSIAN, "");
    default:
      return const Locale(KAZAKH, '');
  }
}

AppLocalizations translation(BuildContext context) {
  return AppLocalizations.of(context)!;
}
