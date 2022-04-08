import 'package:finishedchatbox/Authenticate/functions.dart';
import 'package:finishedchatbox/Screens/ChatRoom.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:finishedchatbox/Model/Utilisateur.dart';



import '../settings.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  bool isLoading = false;

  final fire_user = FirebaseFirestore.instance.collection("users");
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    statusState("Online");

  }

  void statusState(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      statusState("Online");
    } else {
      // offline
      statusState("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void research() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }
  void goToSettings() async {
    Navigator.push(context, MaterialPageRoute(
        builder: (context){
          return settings();
        }
    ));
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      //drawer: myDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Home Screen"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => logout(context))
        ],
      ),
      body: Container(
        // Use ListView.builder
        child: ListView(
          shrinkWrap: true,
          children: [
        isLoading
        ?

            Container(
              height: size.height / 20,
              width: size.height / 20,
              child: CircularProgressIndicator(),
            ):



        SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.15,
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                        hintText: "Recherche",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                ElevatedButton(
                  onPressed: research,
                  child: Text("Chercher"),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),

                          side: BorderSide(color: Colors.red)
                      )
                  )),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                userMap != null
                    ? ListTile(
                  onTap: () {
                    String roomId = chatRoomId(
                        _auth.currentUser!.displayName!,
                        userMap!['name']);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatRoom(
                          chatRoomId: roomId,
                          userMap: userMap!,
                        ),
                      ),
                    );
                  },
                  leading: Icon(Icons.account_box, color: Colors.black),
                  title: Text(
                    userMap!['name'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(userMap!['email']),
                  trailing: Icon(Icons.chat, color: Colors.black),
                ):
                Container(),
            //listAccount(),

          ],
          padding: EdgeInsets.all(10),
        )
      ),
      persistentFooterButtons: <Widget>[


    IconButton(icon: const Icon(Icons.settings, size: 40,), onPressed: () {
      goToSettings();
    if (kDebugMode) {
    print("You are already on this page");
    }
    }),
    ],

    );
  }

}