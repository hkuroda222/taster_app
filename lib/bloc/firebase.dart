import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

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

//メールアドレス変更
Future<void> updateEmail(email) async {
  final user = auth.currentUser;
  await user?.updateEmail(email);
}

//メールアドレス変更
Future<void> updatePassword(pass) async {
  final user = auth.currentUser;
  await user?.updatePassword(pass);
}

//サインアウト
void signOut() {
  auth.signOut();
}

//ドキュメント削除
void deleteData(String collection, String documentId) {
  firestore.collection(collection).doc(documentId).delete();
}
