import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './note.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  @override
  _SignupPage createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage> {
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
                  '会員登録',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey, //ボタンの背景色
                ),
                onPressed: () async {
                  try {
                  // メール・パスワードでユーザー登録
                    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                  //遷移処理(現状はホームへ遷移)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Note(title: ''),
                      ));
                  } catch (e) {
                  // ログインに失敗した場合
                  print(e);
                  }
                }),
          ),
        ),
      ]),
    );
  }
}
