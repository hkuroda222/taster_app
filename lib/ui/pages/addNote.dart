import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';

import './noteList.dart';

// Future<String> selectImage(BuildContext context) async {
//   const String SELECT_ICON = "アイコンを選択";
//   const List<String> SELECT_ICON_OPTIONS = ["写真から選択", "写真を撮影"];
//   const int GALLERY = 0;
//   const int CAMERA = 1;
//
//   var _select_type = await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return SimpleDialog(
//           title: Text(SELECT_ICON),
//           children: SELECT_ICON_OPTIONS.asMap().entries.map((e) {
//             return SimpleDialogOption(
//               child: ListTile(
//                 title: Text(e.value),
//               ),
//               onPressed: () => Navigator.of(context).pop(e.key),
//             );
//           }).toList(),
//         );
//       });
//
//   final picker = ImagePicker();
//   var _img_src;
//
//   if (_select_type == null) {
//     return '';
//   }
// //カメラで撮影
//   else if (_select_type == CAMERA) {
//     _img_src = ImageSource.camera;
//   }
// //ギャラリーから選択
//   else if (_select_type == GALLERY) {
//     _img_src = ImageSource.gallery;
//   }
//
//   final pickedFile = await picker.getImage(source: _img_src);
//
//   if (pickedFile == null) {
//     return '';
//   } else {
//     return pickedFile.path;
//   }
// }

// Future<void> uploadFile(String sourcePath, String uploadFileName) async {
//   final FirebaseStorage storage = FirebaseStorage.instance;
//   Reference ref = storage.ref().child("images"); //保存するフォルダ
//
//   io.File file = io.File(sourcePath);
//   UploadTask task = ref.child(uploadFileName).putFile(file);
//
//   try {
//     var snapshot = await task;
//   } catch (e) {
//     //エラー処理
//     print(e);
//   }
// }

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  _AddNote createState() => _AddNote();
}

class _AddNote extends State<AddNote> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String imagePath = "";
  String distilleryName = "";
  String aging = "";
  // String vintage = "";
  // String bottled = "";
  String region = "";
  // String bottlers = "";
  String date = "";
  // String howToDrink = "";
  String nose = "";
  String taste = "";
  String finish = "";
  String comment = "";

  // late File _image;
  // final picker = ImagePicker();
  //
  // //カメラ用
  // Future getImageFromCamera() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.camera);
  //
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }
  //
  // //写真ライブラリの読み込み用
  // Future _getImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  final ImagePicker _picker = ImagePicker();
  File? _file;

  TextEditingController dateinput = TextEditingController();

  @override
  void initState() {
    dateinput.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('新規登録'),
        backgroundColor: Colors.grey,
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              OutlinedButton(
                  onPressed: () async {
                    final XFile? _image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    _file = File(_image!.path);
                    setState(() {});
                  },
                  child: const Text('画像を選択')),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     FloatingActionButton(
              //       heroTag: "btn2",
              //       onPressed: () async {
              //         final XFile? _image =
              //             await _picker.pickImage(source: ImageSource.gallery);
              //         _file = File(_image!.path);
              //         setState(() {});
              //       },
              //       child: const Icon(Icons.image),
              //     ),
              //   ],
              // ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: "蒸留所名"),
                    onChanged: (String value) {
                      distilleryName = value;
                    },
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "熟成年数"),
                  onChanged: (String value) {
                    aging = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "地域"),
                  onChanged: (String value) {
                    region = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                child: TextField(
                  controller: dateinput,
                  decoration: const InputDecoration(labelText: "飲んだ日付"),
                  readOnly: true,
                  onTap: () async {
                    var pickedDate = await showDatePicker(
                        context: context,
                        locale: const Locale("ja"),
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light().copyWith(
                                primary: Colors.grey,
                              ),
                            ),
                            child: child!,
                          );
                        });
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy年MM月dd日').format(pickedDate);
                      setState(() {
                        dateinput.text = formattedDate;
                        print(pickedDate);
                      });
                    }
                  },
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    width: 270,
                    child: Text(
                      '香り',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 3,
                      onChanged: (String value) {
                        nose = value;
                      },
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(
                    width: 270,
                    child: Text(
                      '味わい',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 3,
                      onChanged: (String value) {
                        taste = value;
                      },
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(
                    width: 270,
                    child: Text(
                      '余韻',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 3,
                      onChanged: (String value) {
                        finish = value;
                      },
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(
                    width: 270,
                    child: Text(
                      '総評',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 3,
                      onChanged: (String value) {
                        comment = value;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // 画面下にボタンの配置
      bottomNavigationBar:
          Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 310,
            child: ElevatedButton(
                child: const Text(
                  '登録',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                ),
                onPressed: () async {
                  try {
                    Map<String, dynamic> insertData = {
                      'distillery_name': distilleryName,
                      'aging': aging,
                      'region': region,
                      'date': date,
                      'nose': nose,
                      'taste': taste,
                      'finish': finish,
                      'comment': comment,
                      'image_path': imagePath,
                    };
                    FirebaseFirestore.instance
                        .collection('note')
                        .add(insertData);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NoteList(),
                        ));
                  } catch (e) {
                    print(e);
                  }
                }),
          ),
        ),
      ]),
    );
  }
}
