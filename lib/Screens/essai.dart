isLoading
?  ListView(
padding: const EdgeInsets.all(8),
children: <Widget>[

Container(
height: size.height / 20,
width: size.height / 20,
child: CircularProgressIndicator(),
),

Column(
children: [

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
onPressed: onSearch,
child: Text("Chercher"),
style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
Container()


],


),
])
persistentFooterButtons: <Widget>[
IconButton(icon: const Icon(Icons.settings, size: 40,), onPressed: navigateToSettings,),
],