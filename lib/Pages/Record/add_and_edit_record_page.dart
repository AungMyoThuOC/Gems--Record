// ignore_for_file: must_be_immutable, library_private_types_in_public_api, non_constant_identifier_names, prefer_final_fields, deprecated_member_use, avoid_print, sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gems_record/Database/create_database.dart';
import 'package:gems_record/Database/record_map.dart';
import 'package:gems_record/Pages/Home/home_page.dart';
import 'package:gems_record/classes/language_constants.dart';
import 'package:gems_record/common.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class AddAndEditRecordPage extends StatefulWidget {
  int id;
  int type;
  AddAndEditRecordPage({
    Key? key,
    required this.type,
    required this.id,
  }) : super(key: key);

  @override
  _AddAndEditRecordPageState createState() => _AddAndEditRecordPageState();
}

class _AddAndEditRecordPageState extends State<AddAndEditRecordPage> {
  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _priceControoler = TextEditingController();
  final TextEditingController _fromWhomController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _remarkControoler = TextEditingController();
  bool checkType = false;
  bool checkWeight = false;
  bool checkPrice = false;
  bool checkFromWhom = false;
  bool checkPhone = false;
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageList;
  List record_image_list = [];
  File? _video;
  List video_path = [];
  List<VideoPlayerController>? _videoPlayerController = [];
  List<ChewieController>? _chewieController = [];
  Uint8List? imageBytes;
  bool loading = false;
  final _db = CreateDatabase.instance;
  String checkZero = "";

  _pickVideo() async {
    final video = await _picker.getVideo(
      source: ImageSource.gallery,
    );
    _video = File(video!.path);
    // print(">>>>>>>>>>>>>>> video path ${_video!.path}");
    if (_video != null) {
      // print(">>>>>>>>>>> start");
      video_path.add(video.path);
      // _videoPlayerController = VideoPlayerController.file(_video!);
      // print(">>>>>>>>>>> middle");
      _videoPlayerController!.add(VideoPlayerController.file(_video!));
      // print(">>>>>>>>>>>>>> middle start");
      _chewieController!.add(ChewieController(
          videoPlayerController: _videoPlayerController!.last,
          autoInitialize: true,
          looping: false,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }));
      // print(">>>>>>>>>>>>>>>>>>>>>>>>> done");
    }
    Future.delayed(const Duration(seconds: 1)).then(
      (value) {
        setState(() {});
      },
    );
  }

  _takeVideo() async {
    final video = await _picker.getVideo(
      source: ImageSource.camera,
    );
    _video = File(video!.path);
    if (_video != null) {
      video_path.add(video.path);
      _videoPlayerController!.add(VideoPlayerController.file(_video!));
      _chewieController!.add(ChewieController(
          videoPlayerController: _videoPlayerController!.last,
          autoInitialize: true,
          looping: false,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }));
    }
    Future.delayed(const Duration(seconds: 1)).then(
      (value) {
        setState(() {});
      },
    );
  }

  Future<void> _selectMultiImage() async {
    final List<XFile>? pickedFileList = await _picker.pickMultiImage(
      maxWidth: 100000000000,
      maxHeight: 100000000000,
      imageQuality: 100,
    );
    setState(() {
      _imageList = pickedFileList;
      try {
        for (var i = 0; i < _imageList!.length; i++) {
          record_image_list.add(_imageList![i].path);
        }
      } catch (e) {
        print('">>>>>>>>> enpty');
      }
      print(">>>>>>>>>>>>>>>> record_image_list $record_image_list");
    });
  }

  Future<void> _takePhoto() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 100000000000,
      maxHeight: 100000000000,
      imageQuality: 100,
    );
    setState(() {
      try {
        record_image_list.add(pickedFile!.path);
      } catch (e) {
        print('">>>>>>>>> enpty');
      }
      print(">>>>>>>>>>>>>>>> record_image_list $record_image_list");
    });
  }

  _date() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        date = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  _addRecord() async {
    String firstImage = "";
    String secondImage = "";
    if (record_image_list.isNotEmpty) {
      firstImage = record_image_list[0];
    }
    if (record_image_list.length > 1) {
      secondImage = record_image_list[1];
    }
    ////
    if (_phoneController.text.startsWith("0")) {
      checkZero = "true";
    } else {
      checkZero = "false";
    }
    var record_map = RecordMap(
      date,
      _typeController.text,
      _weightController.text,
      int.parse(_priceControoler.text),
      _fromWhomController.text,
      int.parse(_phoneController.text),
      _remarkControoler.text,
      jsonEncode(record_image_list),
      firstImage,
      jsonEncode(video_path),
      secondImage,
      checkZero,
    );
    _db.createRecord(record_map).then((value) {
      loading = false;
    });
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: HomePage(
          id: widget.id,
        ),
      ),
    );
    setState(() {});
  }

  void _showDialog(int id) async {
    setState(() {
      showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      if (id == 0) {
                        _takePhoto();
                      } else {
                        _takeVideo();
                      }
                      setState(() {});
                    },
                    child: Container(
                      color: Colors.white30,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(
                              id == 0
                                  ? Icons.camera_alt_outlined
                                  : Icons.video_camera_back_outlined,
                              size: 30,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              id == 0
                                  // ? "Take Photo" : "Take Video",
                                  ? translation(context).take_photo
                                  : translation(context).take_vid,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: ubuntuFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      if (id == 0) {
                        _selectMultiImage();
                      } else {
                        _pickVideo();
                      }
                      setState(() {});
                    },
                    child: Container(
                      color: Colors.white30,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Image.asset(
                              "images/gallary.png",
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              id == 0
                                  // ? "Choose Image" : "Choose Video",
                                  ? translation(context).cho_img
                                  : translation(context).cho_vid,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: ubuntuFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  _editItem() async {
    String firstImage = "";
    String secondImage = "";
    if (record_image_list.isNotEmpty) {
      firstImage = record_image_list[0];
    }
    if (record_image_list.length > 1) {
      secondImage = record_image_list[1];
    }
    if (_phoneController.text.startsWith("0")) {
      checkZero = "true";
    } else {
      checkZero = "false";
    }
    var record_map = RecordMap(
      date,
      _typeController.text,
      _weightController.text,
      int.parse(_priceControoler.text),
      _fromWhomController.text,
      int.parse(_phoneController.text),
      _remarkControoler.text,
      jsonEncode(record_image_list),
      firstImage,
      jsonEncode(video_path),
      secondImage,
      checkZero,
    );
    _db.editRecord(record_map, widget.type).then((value) {
      loading = false;
    });
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: HomePage(
          id: widget.id,
        ),
      ),
    );
    setState(() {});
  }

  getEditData() async {
    List data = await _db.getRecord(widget.type);
    print(">>>>>>>>>>>>>>>> data $data");
    setState(() {
      date = DateFormat("yyyy-MM-dd")
          .format(DateTime.parse(data[0]["record_date"]));
      _typeController.text = data[0]["record_type"].toString();
      _weightController.text = data[0]["record_weight"].toString();
      _priceControoler.text = data[0]["record_price"].toString();
      _fromWhomController.text = data[0]["record_fromWhom"];
      _phoneController.text = data[0]["checkZero"] == "true"
          ? "0${data[0]["record_phoneNum"]}"
          : data[0]["record_phoneNum"].toString();
      _remarkControoler.text = data[0]["record_remark"].toString();
      record_image_list = jsonDecode(data[0]["record_image_list"]);
      ////
      print(">>>>>>>>>>>>>>");
      video_path = jsonDecode(data[0]["video"]);
      print(">>>>>>>>>>>>>> $video_path");
      if (video_path.isNotEmpty) {
        print(">>>>>>>>>>>>>> video_path $video_path");
        print(">>>>>>>>>>>>>> video_path length ${video_path.length}");
        for (var i = 0; i < video_path.length; i++) {
          _videoPlayerController!
              .add(VideoPlayerController.file(File(video_path[i])));
          _chewieController!.add(ChewieController(
              videoPlayerController: _videoPlayerController![i],
              autoInitialize: true,
              looping: false,
              errorBuilder: (context, errorMessage) {
                return Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              }));
        }
        print(
            ">>>>>>>>>>>>>>> video controller length ${_videoPlayerController!.length}");
        print(
            ">>>>>>>>>>>>>>> _chewieController length ${_chewieController!.length}");
        setState(() {});
      }
    });
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {});
    });
  }

  _titleTextWidget(title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 16, left: 16),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 15,
          fontFamily: ubuntuFamily,
        ),
      ),
    );
  }

  @override
  void initState() {
    getEditData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) =>
          FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          title: Text(
            widget.type == -1
                // ? "New Item" : "Edit Item",
                ? translation(context).new_item
                : translation(context).edit_item,
            style: TextStyle(
              color: Colors.black,
              fontFamily: ubuntuFamily,
            ),
          ),
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRight,
                  child: HomePage(
                    id: widget.id,
                  ),
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
                child: HomePage(
                  id: widget.id,
                ),
              ),
            );
            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _titleTextWidget(
                  // "Date"
                  translation(context).date,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
                  child: GestureDetector(
                    onTap: () => _date(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            DateFormat("dd-MM-yyyy")
                                .format(DateTime.parse(date)),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 0.7,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                _titleTextWidget(
                    // "Type"
                    translation(context).type),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _typeController,
                        onChanged: (value) {
                          setState(() {
                            if (_typeController.text != "") {
                              checkType = false;
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                        ),
                      ),
                      checkType == true ? errorTextWidget(
                          // "Enter type"
                          translation(context).ent_typ) : Container(),
                    ],
                  ),
                ),
                _titleTextWidget(
                    // "Weight"
                    translation(context).weight),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _weightController,
                        onChanged: (value) {
                          setState(() {
                            if (_weightController.text != "") {
                              checkWeight = false;
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                        ),
                      ),
                      checkWeight ? errorTextWidget(
                          // "Enter weight"
                          translation(context).ent_wei) : Container(),
                    ],
                  ),
                ),
                _titleTextWidget(
                    // "Price"
                    translation(context).price),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _priceControoler,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp('[0-9]'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            if (_priceControoler.text != "") {
                              checkPrice = false;
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                        ),
                      ),
                      checkPrice ? errorTextWidget(
                          // "Enter price"
                          translation(context).ent_pri) : Container(),
                    ],
                  ),
                ),
                _titleTextWidget(
                  // "From Whom"
                  translation(context).from_whom,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _fromWhomController,
                        onChanged: (value) {
                          setState(() {
                            if (_fromWhomController.text != "") {
                              checkFromWhom = false;
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                        ),
                      ),
                      checkFromWhom ? errorTextWidget(
                          // "Enter from whom"
                          translation(context).ent_froWho) : Container(),
                    ],
                  ),
                ),
                _titleTextWidget(
                    // "Phone"
                    translation(context).phone),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp('[0-9]'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            if (_phoneController.text != "") {
                              checkPhone = false;
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                        ),
                      ),
                      checkPhone ? errorTextWidget(
                          // "Enter phone number"
                          translation(context).ent_ph) : Container(),
                    ],
                  ),
                ),
                _titleTextWidget(
                    // "Remark"
                    translation(context).remark),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: TextField(
                    controller: _remarkControoler,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black26),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black26),
                      ),
                    ),
                  ),
                ),
                record_image_list.isEmpty
                    ? Container()
                    : GridView.count(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        crossAxisCount: 2,
                        children:
                            List.generate(record_image_list.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => PreviewImageDialog(
                                        imagePath: record_image_list[index],
                                      ),
                                    );
                                    setState(() {});
                                  },
                                  child: Image.file(
                                    File(record_image_list[index]),
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 0.1,
                                  top: 0.1,
                                  child: GestureDetector(
                                    onTap: () {
                                      record_image_list.removeAt(index);
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      color: Colors.transparent,
                                      child: const Icon(
                                        Icons.close,
                                        size: 25,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                video_path.isEmpty
                    ? Container()
                    : ListView.builder(
                        itemCount: _chewieController!.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                  child: Chewie(
                                    controller: _chewieController![index],
                                  ),
                                ),
                                Positioned(
                                  left: 0.1,
                                  top: 0.1,
                                  child: GestureDetector(
                                    onTap: () {
                                      _chewieController!.removeAt(index);
                                      video_path.removeAt(index);
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      color: Colors.transparent,
                                      child: const Icon(
                                        Icons.close,
                                        size: 25,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showDialog(0);
                          setState(() {});
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.43,
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                spreadRadius: 0.5,
                                blurRadius: 2,
                                offset: Offset(0, 2),
                                color: Color.fromARGB(66, 53, 52, 52),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      GestureDetector(
                        onTap: () {
                          _showDialog(1);
                          setState(() {});
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.43,
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                spreadRadius: 0.5,
                                blurRadius: 2,
                                offset: Offset(0, 2),
                                color: Color.fromARGB(66, 53, 52, 52),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.video_camera_back_outlined,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    child: GestureDetector(
                      onTap: () {
                        loading = true;
                        if (_typeController.text == "" &&
                            _weightController.text == "" &&
                            _priceControoler.text == "" &&
                            _fromWhomController.text == "" &&
                            _phoneController.text == "") {
                          checkType = true;
                          checkWeight = true;
                          checkPrice = true;
                          checkFromWhom = true;
                          checkPhone = true;
                          loading = false;
                        } else if (_typeController.text == "") {
                          checkType = true;
                          if (_weightController.text == "") {
                            checkWeight = true;
                          } else {
                            checkWeight = false;
                          }
                          if (_priceControoler.text == "") {
                            checkPrice = true;
                          } else {
                            checkPrice = false;
                          }
                          if (_fromWhomController.text == "") {
                            checkFromWhom = true;
                          } else {
                            checkFromWhom = false;
                          }
                          if (_phoneController.text == "") {
                            checkPhone = true;
                          } else {
                            checkPhone = false;
                          }
                          loading = false;
                        } else if (_weightController.text == "") {
                          checkWeight = true;
                          if (_typeController.text == "") {
                            checkType = true;
                          } else {
                            checkType = false;
                          }
                          if (_priceControoler.text == "") {
                            checkPrice = true;
                          } else {
                            checkPrice = false;
                          }
                          if (_fromWhomController.text == "") {
                            checkFromWhom = true;
                          } else {
                            checkFromWhom = false;
                          }
                          if (_phoneController.text == "") {
                            checkPhone = true;
                          } else {
                            checkPhone = false;
                          }
                          loading = false;
                        } else if (_priceControoler.text == "") {
                          checkPrice = true;
                          if (_typeController.text == "") {
                            checkType = true;
                          } else {
                            checkType = false;
                          }
                          if (_weightController.text == "") {
                            checkWeight = true;
                          } else {
                            checkWeight = false;
                          }
                          if (_fromWhomController.text == "") {
                            checkFromWhom = true;
                          } else {
                            checkFromWhom = false;
                          }
                          if (_phoneController.text == "") {
                            checkPhone = true;
                          } else {
                            checkPhone = false;
                          }
                          loading = false;
                        } else if (_fromWhomController.text == "") {
                          checkFromWhom = true;
                          if (_typeController.text == "") {
                            checkType = true;
                          } else {
                            checkType = false;
                          }
                          if (_priceControoler.text == "") {
                            checkPrice = true;
                          } else {
                            checkPrice = false;
                          }
                          if (_weightController.text == "") {
                            checkWeight = true;
                          } else {
                            checkWeight = false;
                          }
                          if (_phoneController.text == "") {
                            checkPhone = true;
                          } else {
                            checkPhone = false;
                          }
                          loading = false;
                        } else if (_phoneController.text == "") {
                          checkPhone = true;
                          if (_typeController.text == "") {
                            checkType = true;
                          } else {
                            checkType = false;
                          }
                          if (_priceControoler.text == "") {
                            checkPrice = true;
                          } else {
                            checkPrice = false;
                          }
                          if (_fromWhomController.text == "") {
                            checkFromWhom = true;
                          } else {
                            checkFromWhom = false;
                          }
                          if (_weightController.text == "") {
                            checkWeight = true;
                          } else {
                            checkWeight = false;
                          }
                          loading = false;
                        } else {
                          checkType = false;
                          checkWeight = false;
                          checkPrice = false;
                          checkFromWhom = false;
                          checkPhone = false;
                          if (widget.type == -1) {
                            _addRecord();
                          } else {
                            _editItem();
                          }
                        }
                        setState(() {});
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black,
                        child: Center(
                          child: loading == true
                              ? const SizedBox(
                                  width: 23,
                                  height: 23,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  // "Save Item",
                                  translation(context).sav_item,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: ubuntuFamily,
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
