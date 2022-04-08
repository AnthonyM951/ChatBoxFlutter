import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projetfinal/dashboard.dart';
import 'package:projetfinal/myWidgets/myDrawer.dart';
import 'package:projetfinal/settings.dart';
import 'package:projetfinal/functions/FirestoreHelper.dart';

import 'Model/Utilisateur.dart';
import 'library/lib.dart';


class contact extends StatefulWidget {
  final String receiver;

  contact({Key? key, required this.receiver}) : super(key: key);


  @override
  State<StatefulWidget> createState() {

    // TODO: implement createState
    return contactState(receiver);
  }
}

class contactState extends State<contact> {
  String receiver = "";
  final Utilisateur? profileInfo= myProfil;
  contactState(receiver) {
    this.receiver = receiver;
  }

  void navigateToDashboard() async {
    Navigator.push(context, MaterialPageRoute(
        builder: (context){
          return dashboard(user:myProfil!.prenom);
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
        title: Text('Contact List'),
      ),
      body: bodyPage(),
      persistentFooterButtons: <Widget>[

        ],
    );
  }
  String message = '';
  Widget bodyPage() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreHelper().fire_user.snapshots(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }
          else
          {
            //List documents = snapshot.data!.docs;
            return Column(children: [
              Container(height: 200,
                width: 200,
                  child: Text(receiver),
              ),
              TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a message',
              suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: ()async {FirestoreHelper().CreateMsg('fesf',profileInfo!.id, receiver,  message);},
                ),
          ),
              onChanged:(value)=>setState((){
          message=value;
          }),

              ),

            ],);


            /*ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context,index){
                  Utilisateur user = Utilisateur(documents[index]);
                  return Card(

                    elevation: 5.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child:  ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context){
                              return dashboard();
                            }
                        ));
                      },
                      leading: (user.avatar==null)?Container(
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
                                image: NetworkImage(user.avatar!),
                                fit: BoxFit.fill
                            )
                        ),
                      ),
                      title: Text("${user.prenom} ${user.nom}"),

                    ),
                  );
                }
            );*/
          }
        }
    );
  }

}

