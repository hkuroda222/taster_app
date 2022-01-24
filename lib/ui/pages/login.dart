import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './noteList.dart';

import '../../bloc/firebase.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<Login> {
  final _auth = FirebaseAuth.instance;
  String email = "";
  String password = "";

  // Firebase Authentication用インスタンス
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // メールアドレスの入力フォーム
            Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "メールアドレス"),
                  onChanged: (String value) {
                    email = value;
                  },
                )),

            // パスワードの入力フォーム
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
              child: TextFormField(
                decoration: const InputDecoration(labelText: "パスワード"),
                obscureText: true, // パスワードが見えないようにする
                onChanged: (String value) {
                  password = value;
                },
              ),
            ),
          ],
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
                  'ログイン',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                ),
                onPressed: () async {
                  try {
                    final user = await signInByMailAndPass(email, password);
                    if (user != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NoteList(),
                          ));
                    }
                  } catch (e) {
                    // ログインに失敗した場合
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
