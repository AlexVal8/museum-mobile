import 'package:museum/pages/login_register_page.dart';
import 'package:museum/pages/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:museum/pages/home_page.dart';
import 'package:museum/pages/register_page.dart';
import 'package:museum/theme/dark_theme.dart';
import 'package:museum/theme/light_theme.dart';
import 'package:museum/utils/service_locator.dart';
import 'classes/navigation_bar.dart';
import 'l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

 void main() {
   setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Locale systemLocale = WidgetsBinding.instance!.window.locale;
    bool isSupportedLanguage = ['ru', 'be', 'uk', 'kk', 'ky'].contains(systemLocale.languageCode);
    Locale locale = isSupportedLanguage ? const Locale('ru') : const Locale('en');
    return MaterialApp(
      title: 'Музеум',
      home: LoginRegisterPage(),

      theme: lightTheme,
      darkTheme: lightTheme, //Временно, пока темная тема не готова

      supportedLocales: L10n.allLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: locale,
    );
  }
}

