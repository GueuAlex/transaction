//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class DbTransaction extends StatelessWidget {
  //const DbTransaction({super.key});

  //firebase instance
  User? user = FirebaseAuth.instance.currentUser;

  //final List bdTransaction;
  var ddd = FirebaseFirestore.instance.collection('depenses');

  DbTransaction();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 460,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("depenses")
              .where("uid", isEqualTo: user!.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //print(snapshot.data!.docs.length);
            //print(cheick("uid", user!.uid));
            if (snapshot.data!.docs.isEmpty) {
              //print(snapshot.hasData);
              return Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Aucun suivi de depense trouvé !',
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                        height: 100,
                        child: Image.asset(
                          'assets/images/money.png',
                          fit: BoxFit.cover,
                        ))
                  ],
                ),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((data) {
                return Card(
                  elevation: 1,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: FittedBox(
                          child: Text(
                            "\$${data['amount']}",
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      '${data['title']}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      data['date'],
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        /* var jobskill_query = FirebaseFirestore.instance.collection('depenses').doc().id;
                        jobskill_query.get().then((querySnapshot) {
                          querySnapshot.docs((doc) {
                            doc.ref.delete();
                          });
                        }); */

                        FirebaseFirestore.instance
                            .collection("depenses")
                            .doc(data.id)
                            .delete()
                            .then(
                                (doc) =>
                                    {Fluttertoast.showToast(msg: 'Supprimé')},
                                onError: (e) => Fluttertoast.showToast(
                                    msg: 'Erreur de suppression !'));
                      },
                      color: Colors.red,
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ));
  }

  Future cheick(String userid, String uid) async {
    FirebaseFirestore.instance
        .collection("depenses")
        .where(userid, isEqualTo: uid)
        .get()
        .then((value) {
      return value.docs.length;
    });
  }
}
