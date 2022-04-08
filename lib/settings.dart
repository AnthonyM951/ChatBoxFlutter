import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:finishedchatbox/Screens/HomeScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:finishedchatbox/Authenticate/Methods.dart';
import 'package:finishedchatbox/Model/Utilisateur.dart';
import 'Model/Utilisateur.dart';
import 'package:finishedchatbox/settings.dart';

import 'edit.dart';


class settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return settingsState();
  }
}

class settingsState extends State<settings> {

  //Varibale
  late Utilisateur myProfil;
  String? nameFile;
  String? urlFile;
  Uint8List? bytesFile;

  void navigateToDashboard() async {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return HomeScreen();
        }
    ));
  }

  void navigateToContact() async {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return HomeScreen();
        }
    ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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

  Widget bodyPage() {
    popImage() {
      print("afficher popUp");
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Souhaitez enregister cette image ? "),
              content: Image.memory(bytesFile!, width: 250, height: 250,),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      //Stocker dans la base de donnée
                      stockageImage(nameFile!, bytesFile!)
                          .then((String url) {
                        setState(() {
                          //Récupérer le lien  dans la base donnée
                          urlFile = url;
                        });
                        //Mettre à jour les infos de l'utilisateur
                        Map<String, dynamic> map = {
                          "AVATAR": urlFile
                        };
                        updatedUser(myProfil.id, map);
                        Navigator.pop(context);
                      });
                    },
                    child: Text("Enregistrement")
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Annuler"),
                ),
              ],
            );
          }
      );
    }

    getIdentifiant().then((String monId) {
      getUtilisateur(monId).then((Utilisateur monUser) {
        setState(() {
          myProfil = monUser;
        });
      });
    });

    return Container(
        color: Colors.white,
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: Column(
            children: [
              SizedBox(height: 100,),
              InkWell(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: (myProfil.avatar == null)
                              ? NetworkImage(
                              "https://voitures.com/wp-content/uploads/2017/06/Kodiaq_079.jpg.jpg")
                              : NetworkImage(myProfil.avatar!)

                      )
                  ),
                ),
                onTap: () async {
                  print("j'ai l'image cliquable");
                  FilePickerResult? resultat = await FilePicker.platform
                      .pickFiles(
                    withData: true,
                    type: FileType.image,
                  );
                  if (resultat != null) {
                    setState(() {
                      nameFile = resultat.files.first.name;
                      bytesFile = resultat.files.first.bytes;
                    });
                    //Affichage de l'image
                    popImage();
                  }
                },
              ),

              SizedBox(height: 20,),
              Text("${myProfil.nom}"),
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Increase volume by 10',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return edit();
                      }
                  ));
                },
              ),
              SizedBox(height: 10,),
            ])
    );
  }
}