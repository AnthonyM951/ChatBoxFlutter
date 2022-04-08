import 'dart:developer';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:finishedchatbox/Model/Utilisateur.dart';
import 'package:finishedchatbox/Authenticate/Methods.dart';

class myDrawer extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return myDrawerState();
  }

}

class myDrawerState extends State<myDrawer>{
  //Varibale
  late Utilisateur myProfil;
  String? nameFile;
  String? urlFile;
  Uint8List? bytesFile;

  @override
  Widget build(BuildContext context) {
//Construire mon Utilsateur
    getIdentifiant().then((String monId){
      getUtilisateur(monId).then((Utilisateur monUser){
        setState(() {
          myProfil = monUser;
          print(myProfil.id);
        });

      });
    });
    // TODO: implement build
    //Méthode
    popImage(){
      print("afficher popUp");
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Souhaitez enregister cette image ? "),
              content: Image.memory(bytesFile!,width: 250,height: 250,),
              actions: [
                ElevatedButton(
                    onPressed: (){
                      //Stocker dans la base de donnée
                      stockageImage(nameFile!, bytesFile!).then((String url){
                        setState(() {
                          //Récupérer le lien  dans la base donnée
                          urlFile = url;
                        });
                        //Mettre à jour les infos de l'utilisateur
                        Map<String,dynamic> map = {
                          "AVATAR": urlFile
                        };
                        updatedUser(myProfil.id, map);
                        Navigator.pop(context);



                      });






                    },
                    child: Text("Enregistrement")
                ),
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);

                  },
                  child: Text("Annuler"),
                ),



              ],
            );
          }
      );
    }




    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width/2,
      height:MediaQuery.of(context).size.height,
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
                      image: (myProfil.avatar == null)?NetworkImage("https://voitures.com/wp-content/uploads/2017/06/Kodiaq_079.jpg.jpg"):NetworkImage(myProfil.avatar!)
                  )
              ),
            ),
            onTap: () async {
              print("j'ai l'image cliquable");
              FilePickerResult? resultat = await FilePicker.platform.pickFiles(
                withData: true,
                type: FileType.image,
              );

              if(resultat != null){
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
          Text("${myProfil.nom}")
        ],
      ),
    );
  }

}