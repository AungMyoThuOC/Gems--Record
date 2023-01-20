// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gems_record/Database/create_database.dart';
import 'package:gems_record/Pages/Home/home_page.dart';
import 'package:gems_record/Pages/Login/create_acc_page.dart';
import 'package:gems_record/Pages/Login/register_or_login_page.dart';
import 'package:gems_record/classes/language_constants.dart';
import 'package:gems_record/common.dart';
import 'package:page_transition/page_transition.dart';

class LoginAccountPage extends StatefulWidget {
  const LoginAccountPage({Key? key}) : super(key: key);

  @override
  State<LoginAccountPage> createState() => _LoginAccountPageState();
}

class _LoginAccountPageState extends State<LoginAccountPage> {
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool checkObscureText = true;
  final _db = CreateDatabase.instance;
  bool checkLogin = false;
  List accountList = [];
  bool checkPhoneNumber = false;
  bool checkPassword = false;

  void _loginAccount() async {
    setState(() {
      // print(accountList);
      for (var i = 0; i < accountList.length; i++) {
        String phoneNumber = "";
        if (accountList[i]["checkZero"] == "true") {
          phoneNumber = "0${accountList[i]["phonenum"]}";
        } else {
          phoneNumber = accountList[i]["phonenum"].toString();
        }
        if (phoneNumber == _phoneNoController.text &&
            accountList[i]["password"] == _passwordController.text) {
          checkLogin = true;
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: HomePage(
                id: 1,
              ),
            ),
          );
        }
      }
      if (checkLogin == false) {
        showToast(context, "Incorrect password or phone number!");
      }
    });
  }

  _getData() async {
    List data = await _db.getAcc();
    accountList = data;
    setState(() {});
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) =>
          FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: accountList.isEmpty
              ? BackButton(
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: const RegisterOrLoginPage(),
                      ),
                    );
                    setState(() {});
                  },
                )
              : Container(),
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (accountList.isEmpty) {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRight,
                  child: const RegisterOrLoginPage(),
                ),
              );
            } else {
              SystemNavigator.pop();
            }
            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "images/login.png",
                    width: 250,
                    height: 250,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _phoneNoController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp('[0-9]'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            if (_phoneNoController.text != "") {
                              checkPhoneNumber = false;
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "Phone number",
                          hintStyle: TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                        ),
                      ),
                      checkPhoneNumber ? errorTextWidget(
                          // "Enter phone number"
                          translation(context).ent_ph) : Container(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _passwordController,
                        obscureText: checkObscureText,
                        onChanged: (value) {
                          setState(() {
                            if (_passwordController.text != "") {
                              checkPassword = false;
                            }
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Password",
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              checkObscureText = !checkObscureText;
                              setState(() {});
                            },
                            icon: Icon(
                              checkObscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ),
                      checkPassword ? errorTextWidget(
                          // "Enter password"
                          translation(context).ent_pass) : Container(),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: CreateAccountPage(
                                  checkPage: 0,
                                  id: 1,
                                )));
                        setState(() {});
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Center(
                          child: Text(
                            translation(context).create_account,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                  child: Container(
                    color: Colors.black,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: GestureDetector(
                      onTap: () {
                        if (_phoneNoController.text == "" &&
                            _passwordController.text == "") {
                          checkPhoneNumber = true;
                          checkPassword = true;
                        } else if (_phoneNoController.text == "") {
                          checkPhoneNumber = true;
                          if (_passwordController.text == "") {
                            checkPassword = true;
                          } else {
                            checkPassword = false;
                          }
                        } else if (_passwordController.text == "") {
                          checkPassword = true;
                          if (_phoneNoController.text == "") {
                            checkPhoneNumber = true;
                          } else {
                            checkPhoneNumber = false;
                          }
                        } else {
                          checkPhoneNumber = false;
                          checkPassword = false;
                          _loginAccount();
                        }
                        setState(() {});
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            // "Login",
                            translation(context).login,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
