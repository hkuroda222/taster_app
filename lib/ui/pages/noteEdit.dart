import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import './noteList.dart';

class NoteEdit extends StatefulWidget {
  const NoteEdit({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _NoteEdit createState() => _NoteEdit(id);
}

class _NoteEdit extends State<NoteEdit> {
  _NoteEdit(this.id);
  String id;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String imagePath = "";
  String pickedImagePath = "";
  String distilleryName = "";
  String aging = "";
  String region = "";
  Timestamp date = Timestamp.now();
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

  // Future getData() async {
  //   DocumentSnapshot docSnapshot =
  //       await FirebaseFirestore.instance.collection('note').doc(id).get();
  //
  //   docSnapshot;
  //
  //   return docSnapshot.data['date'];
  // }

  @override
  void initState() {
    super.initState();
    dateinput.text = "";
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('編集'),
        backgroundColor: Colors.grey,
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('note')
                .doc(id)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              return SingleChildScrollView(
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
                          ),
                        );
                      } else if (snapshot.data!['image_path'] != null) {
                        return GestureDetector(
                          onTap: () {
                            getImageFromGallery();
                          },
                          child: SizedBox(
                            height: 300,
                            width: 300,
                            child: Image.network(
                              snapshot.data!['image_path'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
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
                          initialValue: snapshot.data!['distillery_name'],
                          onChanged: (String value) {
                            distilleryName = value;
                          },
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "熟成年数"),
                        initialValue: snapshot.data!['aging'],
                        onChanged: (String value) {
                          aging = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "地域"),
                        initialValue: snapshot.data!['region'],
                        onChanged: (String value) {
                          region = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                      child: TextFormField(
                        // controller: dateinput,
                        decoration: const InputDecoration(labelText: "飲んだ日付"),
                        readOnly: true,
                        initialValue: DateFormat('yyyy年MM月dd日')
                            .format(snapshot.data!['date'].toDate()),
                        onTap: () async {
                          var pickedDate = await showDatePicker(
                              context: context,
                              locale: const Locale("ja"),
                              initialDate: snapshot.data!['date'].toDate(),
                              firstDate: DateTime(2010),
                              lastDate: DateTime(2030),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme:
                                        const ColorScheme.light().copyWith(
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
                            final convertedDate =
                                Timestamp.fromDate(pickedDate);
                            date = convertedDate;
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
                          padding:
                              const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 3,
                            initialValue: snapshot.data!['nose'],
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
                          padding:
                              const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 3,
                            initialValue: snapshot.data!['taste'],
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
                          padding:
                              const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 3,
                            initialValue: snapshot.data!['finish'],
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
                          padding:
                              const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 3,
                            initialValue: snapshot.data!['comment'],
                            onChanged: (String value) {
                              comment = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 310,
                          child: ElevatedButton(
                              child: const Text(
                                '保存',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey,
                              ),
                              onPressed: () async {
                                try {
                                  await uploadFile();
                                  Map<String, dynamic> insertData = {
                                    'distillery_name': distilleryName != ''
                                        ? distilleryName
                                        : snapshot.data!['distillery_name'],
                                    'aging': aging != ''
                                        ? aging
                                        : snapshot.data!['aging'],
                                    'region': region != ''
                                        ? region
                                        : snapshot.data!['region'],
                                    'date': date != Timestamp.now()
                                        ? date
                                        : snapshot.data!['date'],
                                    'nose': nose != ''
                                        ? nose
                                        : snapshot.data!['nose'],
                                    'taste': taste != ''
                                        ? taste
                                        : snapshot.data!['taste'],
                                    'finish': finish != ''
                                        ? finish
                                        : snapshot.data!['finish'],
                                    'comment': comment != ''
                                        ? comment
                                        : snapshot.data!['comment'],
                                    'image_path': imagePath != ''
                                        ? imagePath
                                        : snapshot.data!['image_path'],
                                  };
                                  FirebaseFirestore.instance
                                      .collection('note')
                                      .doc(id)
                                      .update(insertData);

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
                  ],
                ),
              );
            }),
      ),

      // 画面下にボタンの配置
      // bottomNavigationBar:
    );
  }
}
