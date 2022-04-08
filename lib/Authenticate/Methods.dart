import 'dart:typed_data';

import 'package:finishedchatbox/Authenticate/LoginScree.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:finishedchatbox/Authenticate/Methods.dart';
import 'package:finishedchatbox/Model/Utilisateur.dart';

Future<User?> createAccount(String name, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCrendetial = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    print("Account created Succesfull");

    userCrendetial.user!.updateDisplayName(name);

    await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
      "name": name,
      "email": email,
      "status": "Unavailable",
      "uid": _auth.currentUser!.uid,
    });

    return userCrendetial.user;
  } catch (e) {
    print(e);
    return null;
  }
}
Future <String> getIdentifiant() async{
  FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = _auth.currentUser!.uid;
  return uid;
}
Future<User?> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    print("Login Sucessfull");
    _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) => userCredential.user!.updateDisplayName(value['name']));

    return userCredential.user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  } catch (e) {
    print("error");
  }
}
Future <String> stockageImage(String nameFile,Uint8List datas) async{
  final fireStorage = FirebaseStorage.instance;
  TaskSnapshot snapshot = await fireStorage.ref("image/$nameFile").putData(datas);
  String urlChemin = await snapshot.ref.getDownloadURL();
  return urlChemin;


}
updatedUser(String uid,Map<String,dynamic>map) async{
final fire_user = FirebaseFirestore.instance.collection("users");
  fire_user.doc(uid).update(map);

}
Future <Utilisateur> getUtilisateur(String uid) async {
  final fire_user = FirebaseFirestore.instance.collection("users");
  DocumentSnapshot  snapshot = await fire_user.doc(uid).get();
  return Utilisateur(snapshot);

}
modifyMail(String uid,String mail,Map<String,dynamic>map) async {
  final fire_user = FirebaseFirestore.instance.collection("users");
  fire_user.doc(uid).update(map);
}
modifyPassword(String uid,String mail,Map<String,dynamic>map) async {
  final fire_user = FirebaseFirestore.instance.collection("users");
  fire_user.doc(uid).update(map);
}
deleteUser() async{
  FirebaseAuth _auth = FirebaseAuth.instance;
   final user = _auth.currentUser;
   print(user?.email);
  user?.delete();
}

