import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:flutter/foundation.dart';
import '../model/class_transaction.dart';

class TransactionList extends StatelessWidget {
  final List<My_Transaction> transactions;
  final Function deleteTx;

  TransactionList({required this.transactions, required this.deleteTx});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 460,
      child: transactions.isEmpty
          ? Container(
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
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        child: FittedBox(
                            child: Text('\$${transactions[index].amount}')),
                        padding: EdgeInsets.all(5),
                      ),
                    ),
                    title: Text(
                      '${transactions[index].title}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      DateFormat.yMMMMd().format(transactions[index].date),
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deleteTx(transactions[index].id),
                      color: Colors.red,
                    ),
                  ),
                );
              },
              itemCount: transactions.length,
            ),
    );
  }
}
