// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:gems_record/Pages/Home/home_page.dart';
import 'package:gems_record/Pages/about_page.dart';
import 'package:gems_record/Pages/language.dart';
import 'package:gems_record/Pages/not_found_page.dart';
// import 'package:gems_records/page/new_rec_page.dart';
// import 'package:gems_records/page/view_record_page.dart';
import 'package:gems_record/router/route_constants.dart';

class CustomRouter {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        var widget;
        return MaterialPageRoute(
            builder: (_) => HomePage(
                  id: widget.id,
                ));
      case languageRoute:
        var widget;
        return MaterialPageRoute(
            builder: (_) => LanguagePage(
                  id: widget.id,
                ));
      // case changpassRout:
      //   return MaterialPageRoute(builder: (_) => const Change_Password());
      case aboutRoute:
        var widget;
        return MaterialPageRoute(
            builder: (_) => About(
                  id: widget.id,
                ));
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }
}
