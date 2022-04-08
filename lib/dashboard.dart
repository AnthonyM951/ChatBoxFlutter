
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projetfinal/Model/Utilisateur.dart';
import 'package:projetfinal/detail.dart';
import 'package:projetfinal/functions/FirestoreHelper.dart';
import 'package:projetfinal/myWidgets/myDrawer.dart';
import 'package:projetfinal/settings.dart';

import 'contact.dart';

class dashboard extends StatefulWidget{
  final String user;
  dashboard({Key? key, required this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return dashboardState(user);
  }
}



class dashboardState extends State<dashboard>{
  String user= "";
  dashboardState(user) {
    this.user = user;
  }
  void navigateToContact() async {
    Navigator.push(context, MaterialPageRoute(
        builder: (context){
          print(this.user);
          return dashboard(user:this.user);
       }
   ));
  }

  void navigateToSettings() async {
    Navigator.push(context, MaterialPageRoute(
        builder: (context){
          return settings();
        }
    ));
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversations"),
      ),
      body: bodyPage(),
      persistentFooterButtons: <Widget>[
        IconButton(icon: const Icon(Icons.wechat_outlined, size: 40,), alignment: Alignment.centerLeft, onPressed: (){if (kDebugMode) {
          print("You are already on this page");
        }}),
        IconButton(icon: const Icon(Icons.people, size: 40,), onPressed: navigateToContact),
        IconButton(icon: const Icon(Icons.settings, size: 40,), onPressed: navigateToSettings,),
      ],

    );
    // get the text in the TextField and start the Second Screen

  }
  void _sendDataToSecondScreen(BuildContext context,String name) {

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => contact(receiver: name),
        ));
  }
  Widget bodyPage(){
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreHelper().fire_user.snapshots(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }
          else
          {
            List documents = snapshot.data!.docs;
            return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context,index){
                  Utilisateur receiver = Utilisateur(documents[index]);
                  return Card(

                    elevation: 5.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child:  ListTile(
                      onTap: (){
                        _sendDataToSecondScreen(context, receiver.prenom);
                      },
                      leading: (receiver.avatar==null)?Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage("https://voitures.com/wp-content/uploads/2017/06/Kodiaq_079.jpg.jpg"),
                                fit: BoxFit.fill
                            )
                        ),
                      ):Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(receiver.avatar!),
                                fit: BoxFit.fill
                            )
                        ),
                      ),
                      title: Text("${receiver.prenom} ${receiver.nom}"),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: (){
                          print("modification");
                        },
                      ),
                    ),
                  );
                }
            );
          }
        }
    );
  }
}