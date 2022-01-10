import 'package:flutter/material.dart';

import './signup.dart';
import './login.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Image.asset(
          "images/home.jpg",
          fit: BoxFit.cover,
        ),
        Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          SizedBox(
            width: 300,
            child: ElevatedButton(
                child: const Text(
                  'メールアドレスでログイン',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                ),
                // 遷移処理
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) => const Login(),
                    ),
                  );
                }),
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
                child: const Text(
                  '新規登録',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                ),
                // 遷移処理
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) => const SignupPage(),
                    ),
                  );
                }),
          )
        ]),
      ], fit: StackFit.expand),
    );
  }
}
