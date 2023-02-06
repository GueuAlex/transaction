import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app2/login_screen.dart';
import 'package:flutter_demo_app2/model/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //firebase instance
  User? user = FirebaseAuth.instance.currentUser;
  //initialize user
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Welcome',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // SizedBox(
            //height: 150,
            //child: Image.asset("assets/logo.png", fit: BoxFit.contain),
            //),
            Text('Welcome back',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("${loggedInUser.firstName} ${loggedInUser.lastName}"),
            SizedBox(height: 5),
            Text(
              "You logged as ${loggedInUser.email}",
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.blueAccent),
            ),
            SizedBox(height: 40),
            IconButton(
              onPressed: () {
                logout(context);
              },
              icon: Icon(Icons.logout),
              color: Colors.blueAccent,
              iconSize: 35,
            )
          ],
        ),
      )),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
    Fluttertoast.showToast(msg: 'Logged out');
  }
}
