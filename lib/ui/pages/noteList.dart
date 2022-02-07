import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';

import './addNote.dart';
import './noteDetail.dart';

class NoteList extends StatefulWidget {
  const NoteList({Key? key}) : super(key: key);

  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<NoteList> {
  List documentList = [];

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  void getNotes() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('note')
        .orderBy('date', descending: true)
        .get();
    setState(() {
      documentList = snapshot.docs;
    });
  }

  //日付を変換
  String convertToString(Timestamp timestamp) {
    final datetime = timestamp.toDate();
    final date = DateFormat('yyyy年MM月dd日').format(datetime);
    return date;
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
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('note')
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (BuildContext context, snapShot) {
            return ListView.builder(
              itemCount: documentList.length,
              itemBuilder: (BuildContext context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NoteDetail(documentList[index].id),
                        ));
                  },
                  child: Container(
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
                          child: Image.network(
                            '${documentList[index]['image_path']}',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Column(children: <Widget>[
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            height: 40,
                            width: 200,
                            child: Text(
                                '${documentList[index]["distillery_name"]} ${documentList[index]["aging"]}年'),
                          ),
                          Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              height: 20,
                              width: 200,
                              child: Text(
                                  convertToString(documentList[index]["date"]),
                                  textAlign: TextAlign.left)),
                        ]),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
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
