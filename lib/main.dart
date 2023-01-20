// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:gems_record/Database/create_database.dart';
import 'package:gems_record/Pages/splash_screen.dart';
import 'package:gems_record/classes/language_constants.dart';
import 'package:gems_record/router/custom_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final _db = CreateDatabase.instance;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findRootAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void deactivate() {
    getLocale().then((locale) => {setLocale(locale)});
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gems Record",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: CustomRouter.generatedRoute,
      home: SplashScreen(),
      locale: _locale,
    );
  }
}
