import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class NewTransaction extends StatefulWidget {
  //const NewTransaction({super.key});
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  //firebase instance
  User? user = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;
  //initialize user

  //generating unique id
  var uuid = Uuid();
  var _selectedDate;

  void _submiData() {
    if (amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);
    if (enteredAmount <= 0 || enteredTitle.isEmpty || _selectedDate == null) {
      _essai2;
      return;
    }
    widget.addTx(
      titleController.text,
      double.parse(amountController.text),
      _selectedDate,
    );
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
              keyboardType: TextInputType.text,
              onSubmitted: (_) => _essai2(),
              //autofocus: true,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _essai2(),
            ),
            Container(
              height: 70,
              child: Row(children: <Widget>[
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'Acune date selectionnée !'
                        : DateFormat.yMd().format(_selectedDate),
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                    onPressed: _presentDatePicker,
                    child: Text(
                      'Ajouter date',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.purple),
                    ))
              ]),
            ),
            ElevatedButton(
              onPressed: _essai2,
              child: Text('Add transaction',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  _essai2() async {
    //final List tab = [];
    final data = <String, dynamic>{
      'id': uuid.v4(),
      'uid': user!.uid,
      'title': titleController.text,
      'amount': amountController.text,
      'date': DateFormat.yMMMMd().format(_selectedDate)
    };
    final docRef = db.collection("depenses");
    await docRef.add(data).then((event) {
      _submiData();
      Fluttertoast.showToast(msg: 'Transaction ajouter');
    }).onError((er, _) {
      print("Error updating document ${er}");
    });
  }
}
