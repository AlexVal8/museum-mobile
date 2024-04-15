import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:museum/theme/dark_theme.dart';
import 'package:museum/theme/light_theme.dart';
import 'l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
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
      home: const MyHomePage(title: 'Главная страница'),

      theme: lightTheme,
      darkTheme: darkTheme,

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(widget.title, style: TextStyle(color: Colors.blue),),
      ),
      body: Center(
        child: Text(
              AppLocalizations.of(context)!.project_name,
          style: TextStyle(
            fontSize: 50
          ),
            ),
      ),
    );
  }
}
