import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import './addNote.dart';

const testData = [
  {
    'distilleryName': "ラフロイグ",
    'aging': "33",
    'region': "アイラ",
    'date': "2021.12.31",
    'nose': "",
    'taste': "",
    'finish': "",
    'comment': "",
    'imagePath': 'images/sample2.jpg'
  },
  {
    'distilleryName': "ダルユーイン",
    'aging': "21",
    'region': "スペイサイド",
    'date': "2021.12.05",
    'nose': "",
    'taste': "",
    'finish': "",
    'comment': "",
    'imagePath': 'images/sample3.jpg'
  },
  {
    'distilleryName': "タリスカー",
    'aging': "19",
    'region': "アイランズ",
    'date': "2021.08.15",
    'nose': "",
    'taste': "",
    'finish': "",
    'comment': "",
    'imagePath': 'images/sample4.jpg'
  },
  {
    'distilleryName': "ダルユーイン",
    'aging': "46",
    'region': "スペイサイド",
    'date': "2021.04.05",
    'nose': "",
    'taste': "",
    'finish': "",
    'comment': "",
    'imagePath': 'images/sample1.jpg'
  },
];

class NoteList extends StatefulWidget {
  const NoteList({Key? key}) : super(key: key);

  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<NoteList> {
  List documentList = [];

  @override
  void initState() {
    //アプリ起動時に一度だけ実行される
    getNotes();
  }

  void getNotes() async {
    final snapshot = await FirebaseFirestore.instance.collection('note').get();
    setState(() {
      documentList = snapshot.docs;
    });
    print(documentList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ノート一覧'),
        backgroundColor: Colors.grey,
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        ],
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: testData.length,
        itemBuilder: (BuildContext context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            // padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.asset(
                    '${testData[index]['imagePath']}',
                    fit: BoxFit.cover,
                  ),
                ),
                Column(children: <Widget>[
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    height: 40,
                    width: 120,
                    child: Text(
                        '${testData[index]["distilleryName"]} ${testData[index]["aging"]}年'),
                  ),
                  Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      height: 20,
                      width: 120,
                      child: Text('${testData[index]["date"]}',
                          textAlign: TextAlign.left)),
                ]),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNote(),
              ));
        },
        tooltip: '記録する',
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add),
      ), // Thi
    );
  }
}
