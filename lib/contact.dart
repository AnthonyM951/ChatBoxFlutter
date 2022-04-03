import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projetfinal/dashboard.dart';
import 'package:projetfinal/myWidgets/myDrawer.dart';
import 'package:projetfinal/settings.dart';


class contact extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return contactState();
  }
}

class contactState extends State<contact> {

  void navigateToDashboard() async {
    Navigator.push(context, MaterialPageRoute(
        builder: (context){
          return dashboard();
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
        IconButton(icon: const Icon(Icons.wechat_outlined, size: 40,), alignment: Alignment.centerLeft, onPressed: navigateToDashboard),
        IconButton(icon: const Icon(Icons.people, size: 40,), onPressed: (){if (kDebugMode) {
    print("You are already on this page");
    }}),
        IconButton(icon: const Icon(Icons.settings, size: 40,), onPressed: navigateToSettings),
        ],
    );
  }

  Widget bodyPage() {
    return Column(

    );
  }

}

