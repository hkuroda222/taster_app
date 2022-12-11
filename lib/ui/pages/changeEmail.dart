import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './noteList.dart';
import './home.dart';

import '../../bloc/firebase.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);
  @override
  _ChangeEmail createState() => _ChangeEmail();
}

class _ChangeEmail extends State<ChangeEmail> {
  final _auth = FirebaseAuth.instance;
  String email = "";
  String confirmEmail = "";

  // Firebase Authentication用インスタンス
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メールアドレス変更'),
        backgroundColor: Colors.grey,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "メールアドレス"),
                  onChanged: (String value) {
                    email = value;
                  },
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
              child: TextFormField(
                decoration: const InputDecoration(labelText: "確認用メールアドレス"),
                onChanged: (String value) {
                  confirmEmail = value;
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 310,
            child: ElevatedButton(
                child: const Text(
                  '変更する',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                ),
                onPressed: () async {
                  try {
                    if (email == '' || confirmEmail == '') {
                      await showDialog<int>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const SizedBox(
                              height: 80,
                              width: 300,
                              child: Text('メールアドレスを入力してください。'),
                            ),
                            actions: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  child: const Text('閉じる'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.grey,
                                  ),
                                  onPressed: () => {
                                    Navigator.of(context).pop(1),
                                  },
                                ),
                              )
                            ],
                          );
                        },
                      );
                    } else if (email == confirmEmail) {
                      updateEmail(email);
                      await showDialog<int>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const SizedBox(
                              height: 80,
                              width: 300,
                              child: Text('メールアドレスを変更しました。再度ログインしてください。'),
                            ),
                            actions: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  child: const Text('ログイン画面へ'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.grey,
                                  ),
                                  onPressed: () => {
                                    Navigator.of(context).pop(1),
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Home(),
                                        )),
                                    signOut(),
                                  },
                                ),
                              )
                            ],
                          );
                        },
                      );
                    }
                  } catch (e) {
                    print('---------------------');
                    print(e);
                    print('---------------------');
                  }
                }),
          ),
        ),
      ]),
    );
  }
}
