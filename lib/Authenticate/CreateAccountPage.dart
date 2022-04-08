import 'package:finishedchatbox/Authenticate/functions.dart';
import 'package:flutter/material.dart';

import '../Screens/HomeScreen.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override

  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("Inscription"),
          centerTitle: true,
        ),
        body: Container(
          child: bodyPage(),
          padding: EdgeInsets.all(20),
        )

    );
  }



  Widget bodyPage(){
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
        child: field(size, "Name", Icons.account_box, _name),
        ),
        SizedBox(height: 10,),
        SizedBox(height: 50,
          child: field(size, "email", Icons.account_box, _email),),
        SizedBox(height: 10,),
        SizedBox(height: 50,
          child: field(size, "password", Icons.lock, _password),),

        SizedBox(height: 10,),

        customButton(size),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text(
              "Login",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_name.text.isNotEmpty &&
            _email.text.isNotEmpty &&
            _password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          createAccount(_name.text, _email.text, _password.text).then((user) {
            if (user != null) {
              setState(() {
                isLoading = false;
              });
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HomeScreen()));
              print("Account Created Sucessfull");
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
            color: Colors.red,
          ),
          alignment: Alignment.center,
          child: Text(
            "Create Account",
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