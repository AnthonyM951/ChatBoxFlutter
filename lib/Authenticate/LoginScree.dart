import 'dart:io';
import 'package:finishedchatbox/Authenticate/CreateAccount.dart';
import 'package:finishedchatbox/Screens/HomeScreen.dart';
import 'package:finishedchatbox/Authenticate/Methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatefulWidget {
  @override


  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Chatbox"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
          padding: EdgeInsets.all(20),
          child: bodyPage(),
        ),

      ),

    );
  }
  PopUp(){
    showDialog(
        context: context,
        builder: (context){
          if(Platform.isIOS){
            return CupertinoAlertDialog(
              title: Text("Erreur"),
              actions: [
                ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("Ok")
                )

              ],
            );
          }
          else
          {
            return AlertDialog(
              title: Text("Erreur"),
              actions: [
                ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);

                    },
                    child: Text("Ok")
                )

              ],
            );
          }
        }
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
          height: 50,child: field(size, "email", Icons.account_box, _email),
        ),
        //Entrer une adresse mail
        SizedBox(height: 10,),
        SizedBox(
          height: 50,
          child: field(size, "password", Icons.lock, _password),
        ),
        //Entrer un mot de passe

        SizedBox(
          height: 10,
        ),
        customButton(size),

        // Cliquer sur le bouton connexion
        SizedBox(
          height: 10,
        ),


        //Cliquer sur un lien qui envoie sur l'inscription
        InkWell(
          child: Text("Inscription",style: TextStyle(color: Colors.blue),),
          onTap: (){
            print("J'ai tapé une fois");
            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context){
                  return CreateAccount();
                }
            ));
          },

        ),

      ],
    );


  }
  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          logIn(_email.text, _password.text).then((user) {
            if (user != null) {
              print("Login Sucessfull");
              setState(() {
                isLoading = false;
              });
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HomeScreen()));
            } else {
              print("Login Failed");
              setState(() {
                isLoading = false;
              });
            }
          });
        } else {
          print("Please fill form correctly");
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
            "Login",
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