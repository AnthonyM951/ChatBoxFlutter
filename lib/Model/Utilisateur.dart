
import 'package:cloud_firestore/cloud_firestore.dart';

class Utilisateur{
  //Attributs
  String id="";
  String? avatar;
  String nom="";
  String uid="";
  String mail="";

  bool isConnected = false;
  DateTime birthDay = DateTime.now();



  //Contructeur
  Utilisateur(DocumentSnapshot snapshot){
    id = snapshot.id;
    Map<String,dynamic> map = snapshot.data() as Map<String,dynamic>;
    nom = map["name"];

    mail = map["email"];
    avatar = map["AVATAR"];
    uid=map["uid"];


  }

  Utilisateur.vide();






//Méthodes

}