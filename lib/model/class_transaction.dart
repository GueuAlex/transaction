import 'package:flutter/foundation.dart';

class My_Transaction {
  String? uid;
  final String? id;
  final String? title;
  final double? amount;
  final DateTime date;

  My_Transaction(
      {@required this.id,
      @required this.title,
      @required this.amount,
      required this.date,
      @required this.uid});

  My_Transaction.average(
      {this.id, this.title, this.amount, required this.date, this.uid});
  //receiving from server
  factory My_Transaction.fromMap(map) {
    return My_Transaction(
        id: map['id'],
        title: map['title'],
        amount: map['amount'],
        date: map['date'],
        uid: map['uid']);
  }

  //sending data to our server
  Map<String, dynamic> toMap() {
    return ({
      'id': id,
      'uid': uid,
      'title': title,
      'amount': amount,
      'date': date
    });
  }
}
