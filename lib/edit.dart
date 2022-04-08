import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:finishedchatbox/Screens/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:finishedchatbox/Authenticate/functions.dart';
import 'package:finishedchatbox/Model/Utilisateur.dart';
import 'Model/Utilisateur.dart';
import 'package:finishedchatbox/settings.dart';
class edit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return editState();
  }
}

class editState extends State<edit> {
  late Utilisateur myProfil;
  final TextEditingController _mail = TextEditingController();

  bool isLoading = false;
  void navigateToContact() async {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return HomeScreen();
        }
    ));
  }
  Widget build(BuildContext context) {
    getId().then((String monId){
      getUtilisateur(monId).then((Utilisateur monUser){
        setState(() {
          myProfil = monUser;
          print(myProfil.id);
        });

      });
    });
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: bodyPage(),
      persistentFooterButtons: <Widget>[

        IconButton(icon: const Icon(Icons.people, size: 40,),
            onPressed: navigateToContact),
        IconButton(icon: const Icon(Icons.settings, size: 40,), onPressed: () {
          if (kDebugMode) {
            print("You are already on this page");
          }
        }),
      ],
    );
  }
  Widget bodyPage(){
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        //Afficher mon logo
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage("https://voitures.com/wp-content/uploads/2017/06/gt2017-1024x600.jpg"),
                  fit: BoxFit.fill
              )
          ),
        ),
        SizedBox(
          height: 50,child: field(size, "email", Icons.account_box, _mail),
        ),
        //Entrer une adresse mail
        SizedBox(height: 10,),

        //Entrer un mot de passe

        SizedBox(
          height: 10,
        ),


        // Cliquer sur le bouton connexion
        SizedBox(
          height: 10,
        ),
        customButton(size),


        //Cliquer sur un lien qui envoie sur l'inscription


      ],
    );


  }
  Widget customButton(Size size) {

    return GestureDetector(

      onTap: () {

        if (
            _mail.text.isNotEmpty ) {
          setState(() {
            isLoading = true;
          });

          Map<String,dynamic> map = {
            "email": _mail.text
          };

           modifyMail(myProfil.id,_mail.text,map).then((monUser) {
            if (monUser != null) {
              setState(() {

                isLoading = false;
              });
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HomeScreen()));
              print("Changed successfully");

            } else {

              print("Login Failed");
              setState(() {
                isLoading = false;
              });
            }
          });
        } else {
          print("Please enter Fields");
        }
      },
      child: Container(
          height: size.height / 14,
          width: size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.blue,
          ),
          alignment: Alignment.center,
          child: Text(
            "modify account",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }

  Widget field(
      Size size, String hintText, IconData icon, TextEditingController cont) {
    return Container(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextField(
        controller: cont,

        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }




}