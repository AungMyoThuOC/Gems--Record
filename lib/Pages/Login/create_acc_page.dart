// ignore_for_file: must_be_immutable, non_constant_identifier_names, sized_box_for_whitespace

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gems_record/Database/create_acc_map.dart';
import 'package:gems_record/Database/create_database.dart';
import 'package:gems_record/Pages/Home/home_page.dart';
import 'package:gems_record/Pages/Login/register_or_login_page.dart';
import 'package:gems_record/classes/language_constants.dart';
import 'package:gems_record/common.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

class CreateAccountPage extends StatefulWidget {
  int checkPage;
  int id;
  CreateAccountPage({Key? key, required this.checkPage, required this.id})
      : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool checkName = false;
  bool checkPhone = false;
  bool checkPassword = false;
  bool checkObscureText = true;
  final _db = CreateDatabase.instance;
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageList;
  List getAccountList = [];
  String image_path = "";
  String checkZero = "";

  Future<void> _selectImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 100,
      maxHeight: 100,
      imageQuality: 100,
    );
    setState(() {
      _setImageFileListFromFile(pickedFile);
    });
  }

  void _setImageFileListFromFile(XFile? value) {
    _imageList = value == null ? null : <XFile>[value];
    if (_imageList != null) {
      image_path = _imageList![0].path.toString();
    }
    setState(() {});
  }

  Future<void> _createAccount() async {
    if (_phoneNoController.text.startsWith("0")) {
      checkZero = "true";
    } else {
      checkZero = "false";
    }
    var acc_map = AccMap(
      _nameController.text,
      int.parse(_phoneNoController.text),
      _passwordController.text,
      image_path,
      checkZero,
    );
    _db.createAcc(acc_map);
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: HomePage(
          id: 1,
        ),
      ),
    );
    setState(() {});
  }

  Future<void> _editAccount() async {
    if (_phoneNoController.text.startsWith("0")) {
      checkZero = "true";
    } else {
      checkZero = "false";
    }
    var acc_map = AccMap(
      _nameController.text,
      int.parse(_phoneNoController.text),
      _passwordController.text,
      image_path,
      checkZero,
    );
    _db.editAcc(acc_map, getAccountList[0]["AutoID"]);
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: HomePage(
          id: 1,
        ),
      ),
    );
    setState(() {});
  }

  _checkPage() async {
    if (widget.checkPage == 1) {
      List data = await _db.getAcc();
      getAccountList = data;
      // print(">>>>>>>>>>>>>>>> $getAccountList");
      _nameController.text = getAccountList[0]["name"];
      _phoneNoController.text = getAccountList[0]["checkZero"] == "true"
          ? "0${getAccountList[0]["phonenum"]}"
          : getAccountList[0]["phonenum"].toString();
      _passwordController.text = getAccountList[0]["password"].toString();
      image_path = getAccountList[0]["image"];
    }
    setState(() {});
  }

  @override
  void initState() {
    _checkPage();
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
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRight,
                  child: widget.id == 2
                      ? const RegisterOrLoginPage()
                      : HomePage(id: widget.id),
                ),
              );
              setState(() {});
            },
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.leftToRight,
                child: widget.id == 2
                    ? const RegisterOrLoginPage()
                    : HomePage(id: widget.id),
              ),
            );
            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _selectImage();
                      setState(() {});
                    },
                    child: _imageList == null
                        ? widget.checkPage == 1 && image_path != ""
                            ? Container(
                                width: 100,
                                height: 100,
                                child: CircleAvatar(
                                  backgroundImage: FileImage(
                                    File(image_path),
                                  ),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                        : Container(
                            width: 100,
                            height: 100,
                            child: CircleAvatar(
                              backgroundImage: FileImage(
                                File(_imageList![0].path),
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _nameController,
                        onChanged: (value) {
                          setState(() {
                            if (_nameController.text != "") {
                              checkName = false;
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "Name",
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
                      checkName
                          ? errorTextWidget(
                              // "Enter name"
                              translation(context).ent_name,
                            )
                          : Container(),
                    ],
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
                              checkPhone = false;
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
                      checkPhone
                          ? errorTextWidget(
                              // "Enter phone number"
                              translation(context).ent_ph,
                            )
                          : Container(),
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
                          hintStyle: const TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                  child: GestureDetector(
                    onTap: () {
                      if (_nameController.text == "" &&
                          _phoneNoController.text == "" &&
                          _passwordController.text == "") {
                        checkName = true;
                        checkPhone = true;
                        checkPassword = true;
                      } else if (_nameController.text == "") {
                        checkName = true;
                        if (_phoneNoController.text == "") {
                          checkPhone = true;
                        } else {
                          checkPhone = false;
                        }
                        if (_passwordController.text == "") {
                          checkPassword = true;
                        } else {
                          checkPassword = false;
                        }
                      } else if (_phoneNoController.text == "") {
                        checkPhone = true;
                        if (_nameController.text == "") {
                          checkName = true;
                        } else {
                          checkName = false;
                        }
                        if (_passwordController.text == "") {
                          checkPassword = true;
                        } else {
                          checkPassword = false;
                        }
                      } else if (_passwordController.text == "") {
                        checkPassword = true;
                        if (_phoneNoController.text == "") {
                          checkPhone = true;
                        } else {
                          checkPhone = false;
                        }
                        if (_nameController.text == "") {
                          checkName = true;
                        } else {
                          checkName = false;
                        }
                      } else {
                        checkName = false;
                        checkPhone = false;
                        checkPassword = false;
                        if (_passwordController.text.length < 4) {
                          showToast(context,
                              "Password must have at least 4 charactor!");
                        } else if (_phoneNoController.text.length < 7) {
                          showToast(context,
                              "Phone number must have at least 7 charactor!");
                        } else {
                          if (widget.checkPage == 0) {
                            _createAccount();
                          } else {
                            _editAccount();
                          }
                        }
                      }
                      setState(() {});
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      child: Center(
                        child: Text(
                          widget.checkPage == 0
                              // ? "Create"
                              ? translation(context).create
                              // : "Save",
                              : translation(context).save,
                          style: const TextStyle(
                            color: Colors.white,
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
