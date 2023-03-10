import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gems_record/Pages/Login/create_acc_page.dart';
import 'package:gems_record/Pages/Login/login_page.dart';
import 'package:gems_record/classes/language_constants.dart';
import 'package:page_transition/page_transition.dart';

class RegisterOrLoginPage extends StatefulWidget {
  const RegisterOrLoginPage({Key? key}) : super(key: key);

  @override
  State<RegisterOrLoginPage> createState() => _RegisterOrLoginPageState();
}

class _RegisterOrLoginPageState extends State<RegisterOrLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/gems.jpg",
                width: 200,
                height: 200,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const LoginAccountPage(),
                    ),
                  );
                  setState(() {});
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: const Color.fromARGB(255, 77, 175, 255),
                    color: Colors.black,
                  ),
                  child: Center(
                    child: Text(
                      // "Login",
                      translation(context).login,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: CreateAccountPage(
                        checkPage: 0,
                        id: 2,
                      ),
                    ),
                  );
                  setState(() {});
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Center(
                    child: Text(
                      // "Create Account",
                      translation(context).create_account,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
