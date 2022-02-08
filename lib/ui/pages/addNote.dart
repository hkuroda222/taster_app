import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import './noteList.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  _AddNote createState() => _AddNote();
}

class _AddNote extends State<AddNote> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String imagePath = "";
  String pickedImagePath = "";
  String distilleryName = "";
  String aging = "";
  // String vintage = "";
  // String bottled = "";
  String region = "";
  // String bottlers = "";
  Timestamp date = Timestamp.now();
  // String howToDrink = "";
  String nose = "";
  String taste = "";
  String finish = "";
  String comment = "";

  File? _image;
  final picker = ImagePicker();

  TextEditingController dateinput = TextEditingController();

  //ギャラリーから画像を選択
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
      pickedImagePath = pickedFile.path;
    });
  }

  //storageに画像をアップロード
  Future<void> uploadFile() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    File file = File(pickedImagePath);
    const uuid = Uuid();
    Reference ref = storage.ref().child("images").child(uuid.v4());

    final storedImage = await ref.putFile(file);
    final imageURL = await storedImage.ref.getDownloadURL();

    imagePath = imageURL;
  }

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
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              (() {
                if (_image != null) {
                  return GestureDetector(
                      onTap: () {
                        getImageFromGallery();
                      },
                      child: SizedBox(
                        height: 300,
                        width: 300,
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                      ));
                } else {
                  return InkWell(
                      onTap: () {
                        getImageFromGallery();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        height: 300,
                        width: 300,
                        child: const Icon(
                          Icons.add_a_photo,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ));
                }
              })(),
              const SizedBox(
                height: 10,
              ),
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
                    final pickedDate = await showDatePicker(
                        context: context,
                        locale: const Locale("ja"),
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2030),
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
                      });
                      //timestamp型に変換
                      final test = Timestamp.fromDate(pickedDate);
                      final test2 =
                          DateFormat('yyyy年MM月dd日').format(test.toDate());
                      date = test;
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
                    await uploadFile();
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
                        .doc()
                        .set(insertData);

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
