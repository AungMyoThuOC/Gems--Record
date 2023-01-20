// ignore_for_file: must_be_immutable, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:gems_record/Pages/Home/home_page.dart';
import 'package:gems_record/Pages/language.dart';
import 'package:gems_record/classes/language_constants.dart';
import 'package:page_transition/page_transition.dart';

class About extends StatefulWidget {
  int id;
  About({Key? key, required this.id}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context).about),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: _drawerList(),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/gems.jpg",
                    width: 200,
                    height: 200,
                  ),
                ],
              ),
              Text(
                // "Gems Recore",
                translation(context).gem_record,
              ),
              Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Text("What includes :"),
                  Text(translation(context).w_i),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text("-  Can save 8 photos of each gem stone."),
                      Text(translation(context).c_s_8_p_o_e_g_s),
                      const SizedBox(
                        height: 10,
                      ),
                      // const Text(
                      //     "-  Can record the name and the phone number\n  of seller."),
                      Text(translation(context).c_r_t_n_a_t_p_n_o_s),
                      const SizedBox(
                        height: 10,
                      ),
                      // const Text(
                      //     "-  Can record type, weight, accepted date of the\n   gem stone as well as the facts about\n  that stone."),
                      Text(translation(context)
                          .c_r_t_w_a_d_o_t_g_s_a_w_a_t_f_a_t_s),
                      const SizedBox(
                        height: 10,
                      ),
                      // const Text(
                      //     "-  Can search for recorded gem stones with date,\n   seller's name and gem stone's type."),
                      Text(translation(context).c_s_f_r_g_s_w_d_s_n_a_g_s_t),
                      const SizedBox(
                        height: 10,
                      ),
                      // const Text("-  Can edit delete the recorded gem stones.")
                      Text(translation(context).c_e_a_d_t_r_g_s)
                    ],
                  )
                ],
              )
            ],
          )),
        ),
      ),
    );
  }

  Container _drawerList() {
    TextStyle _textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 15,
    );
    // ignore: avoid_unnecessary_containers
    return Container(
      // color: selected ? Colors.grey[300] : Colors.transparent,
      // color: Theme.of(context).primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
                color: Colors.red,
                width: double.infinity,
                height: 90,
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 70,
                      child: Text(
                        translation(context).menu,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    )
                  ],
                )
                // Text(translation(context).menu)
                ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home_outlined,
              color: Colors.red,
              size: 20,
            ),
            title: Text(
              translation(context).home,
              style: _textStyle,
            ),
            onTap: () {
              // To close the Drawer
              // Navigator.pop(context);
              // // Navigating to Home Page
              // Navigator.pushNamed(context, homeRoute);
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: HomePage(
                        id: 1,
                      )));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.g_translate_outlined,
              color: Colors.red,
              size: 20,
            ),
            title: Text(
              translation(context).language,
              style: _textStyle,
            ),
            onTap: () {
              // Navigator.pop(context);
              // Navigator.pushNamed(context, languageRoute);
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: LanguagePage(
                        id: 1,
                      )));
            },
          ),
          const Divider(),
          // ListTile(
          //   leading: const Icon(
          //     Icons.lock_reset_outlined,
          //     color: Colors.red,
          //     size: 20,
          //   ),
          //   title: Text(
          //     translation(context).chg_pass,
          //     style: _textStyle,
          //   ),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.pushNamed(context, changpassRout);
          //   },
          // ),
          // const Divider(),
          ListTile(
            leading: const Icon(
              Icons.info_outline,
              color: Colors.red,
              size: 20,
            ),
            title: Text(
              translation(context).about,
              style: _textStyle,
            ),
            onTap: () {
              // Navigator.pop(context);
              // Navigator.pushNamed(context, aboutRoute);
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: About(
                        id: 1,
                      )));
            },
          ),
        ],
      ),
    );
  }
}
