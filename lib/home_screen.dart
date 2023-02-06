import 'package:flutter/material.dart';
import 'package:flutter_demo_app2/widgets/db.transaction.dart';
import 'package:flutter_demo_app2/widgets/loading.dart';
import 'model/class_transaction.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_demo_app2/login_screen.dart';
import 'package:flutter_demo_app2/model/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'widgets/new_transaction.dart';
import 'widgets/transaction_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //firebase instance
  User? user = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;
  //initialize user
  UserModel loggedInUser = UserModel();

  //loading
  bool _isLoading = true;

  //initialize transsaction
  My_Transaction depenses = My_Transaction.average(date: DateTime.now());

  //liste de depense
  final titleController = TextEditingController();

  final amountController = TextEditingController();
  final List<My_Transaction> _userTransactions = [];

  List<My_Transaction> get _recentTransactions {
    return _userTransactions.where((element) {
      return element.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTilte, double txAmount, DateTime chosenDate) {
    final newTx = My_Transaction(
      id: DateTime.now().toString(),
      title: txTilte,
      amount: txAmount,
      date: chosenDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

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

    db.collection("depenses").doc(user!.uid).get().then((value) {
      setState(() {});
    });

    _isLoading = true;
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Suivi de depenses personel',
                style: TextStyle(
                    fontFamily: 'Open Sans', fontWeight: FontWeight.w700),
              ),

              actions: <Widget>[
                IconButton(
                    onPressed: () {
                      _startAddNewTransaction(context);
                    },
                    icon: Icon(Icons.add))
              ],
              //elevation: 5,
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Chart(_recentTransactions),
                  Container(
                      width: double.infinity,
                      //height: 200,
                      child: Card(
                        elevation: 5,
                        // margin: EdgeInsets.only(top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 30,
                                  child: Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  "${loggedInUser.firstName} ${loggedInUser.lastName}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                subtitle: Text("${loggedInUser.email}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                trailing: IconButton(
                                  icon: Icon(Icons.logout_outlined),
                                  onPressed: () {
                                    logout(context);
                                  },
                                  color: Colors.black,
                                )),
                            Card(
                              child: Container(
                                height: 120,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: ExactAssetImage(
                                            'assets/images/currency.jpeg'),
                                        fit: BoxFit.cover,
                                        opacity: 0.4),
                                    color: Colors.blueGrey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      '\$',
                                      style: TextStyle(
                                          fontSize: 100,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Money'.toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Management',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                  //TransactionList(
                  // transactions: _userTransactions, deleteTx: _deleteTransaction),
                  DbTransaction()
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                _startAddNewTransaction(context);
              },
            ),
          );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
    Fluttertoast.showToast(msg: 'Logged out');
  }
}
