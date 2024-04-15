import 'package:flutter/material.dart';

class L10n {
  static final allLocale = [
    const Locale('en'),
    const Locale('ru'),
  ];

  static const supportedLanguages = ['ru', 'be', 'uk', 'kk', 'ky'];

  static Locale localeResolutionCallback(Locale locale, Iterable<Locale> supportedLocales) {
    if (!supportedLanguages.contains(locale.languageCode)) {
      return Locale('en');
    }

    return locale;
  }
}
