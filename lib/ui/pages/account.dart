import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';

import '../../bloc/firebase.dart';

import './home.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント情報'),
        backgroundColor: Colors.grey,
        centerTitle: true,
        automaticallyImplyLeading: true,
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
            // ListTile(
            //     leading: const Icon(Icons.account_circle),
            //     title: const Text("アカウント情報"),
            //     onTap: () => print('test')),
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
        child: ListView(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage("images/user.jpg"))),
            ),
          ],
        ),
      ), // Thi
    );
  }
}
