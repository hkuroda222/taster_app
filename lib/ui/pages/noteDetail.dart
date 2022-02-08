import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './noteEdit.dart';

import './home.dart';
import '../../model/noteModel.dart';

import '../../bloc/firebase.dart';

final StateNotifierProvider taskListProvider =
    StateNotifierProvider((ref) => NoteList());

class NoteDetail extends StatelessWidget {
  NoteDetail(this.id, {Key? key}) : super(key: key);
  String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('ノート詳細'),
        backgroundColor: Colors.grey,
        centerTitle: true,
        // actions: [
        //   IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        // ],
      ),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                child: Text('Menu'),
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
              ),
            ),
            ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text("アカウント情報"),
                onTap: () => print('test')),
            ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("ログアウト"),
                onTap: () => {
                      signOut(),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Home(),
                          ))
                    }),
          ],
        ),
      ),
      body: Container(
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
                    SizedBox(
                      height: 320,
                      width: 320,
                      child: Image.network(
                        snapshot.data!['image_path'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        width: double.infinity,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('銘柄', textAlign: TextAlign.left),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Text(snapshot.data!['distillery_name'] +
                                    snapshot.data!['aging'] +
                                    '年'),
                              ),
                            ])),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                        width: 320,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 2, color: Colors.grey),
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('地域', textAlign: TextAlign.left),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Text(snapshot.data!['region']),
                              ),
                            ])),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                        width: 320,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 2, color: Colors.grey),
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('飲んだ日付', textAlign: TextAlign.left),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Text(DateFormat('yyyy年MM月dd日')
                                    .format(snapshot.data!['date'].toDate())),
                              ),
                            ])),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                        width: 320,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 2, color: Colors.grey),
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('香り', textAlign: TextAlign.left),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Text(snapshot.data!['nose']),
                              ),
                            ])),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                        width: 320,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 2, color: Colors.grey),
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('味わい', textAlign: TextAlign.left),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Text(snapshot.data!['taste']),
                              ),
                            ])),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                        width: 320,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 2, color: Colors.grey),
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('余韻', textAlign: TextAlign.left),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Text(snapshot.data!['finish']),
                              ),
                            ])),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
                        width: 320,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 2, color: Colors.grey),
                            bottom: BorderSide(width: 2, color: Colors.grey),
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('総評', textAlign: TextAlign.left),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Text(snapshot.data!['comment']),
                              ),
                            ])),
                  ],
                ),
              );
            }),
      ),
      bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                    child: const Text(
                      '削除',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    onPressed: () async {
                      deleteData('note', id);
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                    child: const Text(
                      '編集',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                    ),
                    onPressed: () async {
                      try {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoteEdit(id: id),
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
