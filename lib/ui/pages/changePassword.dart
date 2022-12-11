import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './home.dart';

import '../../bloc/firebase.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);
  @override
  _ChangePassword createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  final _auth = FirebaseAuth.instance;
  String currentPass = "";
  String newPass = "";

  // Firebase Authentication用インスタンス
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('パスワード変更'),
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
                  decoration: const InputDecoration(labelText: "現在のパスワード"),
                  onChanged: (String value) {
                    currentPass = value;
                  },
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
              child: TextFormField(
                decoration: const InputDecoration(labelText: "確認用パスワード"),
                obscureText: true,
                onChanged: (String value) {
                  newPass = value;
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
                    if (currentPass == '' || newPass == '') {
                      await showDialog<int>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const SizedBox(
                              height: 80,
                              width: 300,
                              child: Text('パスワードを入力してください。'),
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
                    } else if (currentPass == newPass) {
                      await showDialog<int>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const SizedBox(
                              height: 80,
                              width: 300,
                              child: Text('パスワードを変更しました。再度ログインしてください。'),
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
                                    updatePassword(newPass),
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
                    } else {
                      await showDialog<int>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const SizedBox(
                              height: 80,
                              width: 300,
                              child: Text('パスワードが異なっています。'),
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
