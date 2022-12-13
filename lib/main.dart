import 'package:flutter/material.dart';
import './widgets/textInput.dart';
import './models/transaction.dart';
import './widgets/transactionList.dart';
import './widgets/chart.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'OpenSans',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // String titleInput="";
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: "t1", title: "New Shoes", amount: 2000, date: DateTime.now()),
    // Transaction(
    //     id: "t2", title: "New Shirt", amount: 1000, date: DateTime.now()),
  ];

  List<Transaction> get _recentTransactions{
    return _userTransactions.where((tx){
      return tx.date!.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList(); // can use as List<Transactions> or .toList(); .toList() is better if type casted to List<Object>
    //getter is just like functions that return something and no parameters passed but the variables used are static-scoped variables
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final tx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: chosenDate);
    setState(() {
      //_userTransactions.add(tx); Adds at the end
      _userTransactions.insert(0, tx); //adds at the front
    });
  }

  void _deleteTransaction(String id){
    setState(() {
      _userTransactions.removeWhere((tx){
        return tx.id == id;
      });
    });
  }
  void _startAddNewTransaction(BuildContext ctx) {
    // Shows a bottom to up modal sheet
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: TextInput(addTransaction: _addNewTransaction),
            onTap: () => {},//Tapping on the modal screen should not close the modal
            behavior: HitTestBehavior.opaque, 
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Personal Expenses",
          style:
              TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () => _startAddNewTransaction(context),
              icon: Icon(Icons.add)),
        ],
      ),
      body: Column(
        children: [
          Chart(recentTransactions: _recentTransactions),
          TransactionList(transactions: _userTransactions, deleteTx: _deleteTransaction,),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
