import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

//サインアップ
Future<void> signUpByMailAndPass(email, password) async {
  await auth.createUserWithEmailAndPassword(email: email, password: password);
}

//ログイン
Future signInByMailAndPass(email, password) async {
  final user =
      await auth.signInWithEmailAndPassword(email: email, password: password);
  return user;
}
