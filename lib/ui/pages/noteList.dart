import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';

import '../../bloc/firebase.dart';

import './home.dart';
import './addNote.dart';
import './noteDetail.dart';
import './changeEmail.dart';
import './changePassword.dart';

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
        automaticallyImplyLeading: false,
      ),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 64,
              child: DrawerHeader(
                child: Text('Profile'),
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage("images/user.jpg"))),
            ),
            SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: const Text('ユーザー名'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Text('test2'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: const Text('生年月日'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 24),
                    child: const Text('1994/04/05'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: const Text('性別'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 53),
                    child: const Text('男性'),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 64,
              child: DrawerHeader(
                child: Text('Menu'),
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
              ),
            ),
            ListTile(
                leading: const Icon(Icons.mail),
                title: const Text("メールアドレス変更"),
                onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangeEmail(),
                          ))
                    }),
            ListTile(
                leading: const Icon(Icons.enhanced_encryption),
                title: const Text("パスワード変更"),
                onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePassword(),
                          ))
                    }),
            ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("ログアウト"),
                onTap: () => {
                      signOut(),
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Home(),
                          ),
                          (_) => false)
                    }),
          ],
        ),
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
