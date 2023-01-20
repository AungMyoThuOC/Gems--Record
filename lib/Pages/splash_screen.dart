// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gems_record/Database/create_database.dart';
import 'package:gems_record/Pages/Login/login_page.dart';
import 'package:gems_record/Pages/Login/register_or_login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StartState();
  }
}

class StartState extends State<SplashScreen> {
  final _db = CreateDatabase.instance;

  startTimer() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, route);
  }

  route() async {
    List data = await _db.getAcc();
    List accountList = [];
    accountList = data;
    if (accountList.isEmpty) {
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterOrLoginPage(),
        ),
      );
    } else {
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginAccountPage(),
        ),
      );
    }
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "images/gems.jpg",
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
