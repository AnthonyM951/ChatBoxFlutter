import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class MessageField {
  static final String createdAt = 'createdAt';
}

class Message {
  String idUser="";
  String? urlAvatar="";
  String prenom="";
  String message="";
  DateTime createdAt=DateTime.now();

  //Contructeur
  Message(DocumentSnapshot snapshot){
    idUser = snapshot.id;
    Map<String,dynamic> map = snapshot.data() as Map<String,dynamic>;
    urlAvatar = map["URLAVATAR"];
    prenom = map["PRENOM"];
    message = map["MESSAGE"];

    createdAt = map["DATETIME"];


  }

  Message.vide();


}