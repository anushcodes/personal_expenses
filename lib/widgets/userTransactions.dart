import 'package:flutter/material.dart';
import './textInput.dart';
import './transactionList.dart';
import '../models/transaction.dart';
class UserTransactions extends StatefulWidget {
  const UserTransactions({super.key});

  @override
  State<UserTransactions> createState() => _UserTransactionsState();
}

class _UserTransactionsState extends State<UserTransactions> {
  final List<Transaction> _userTransactions = [
    Transaction(
        id: "t1", title: "New Shoes", amount: 2000, date: DateTime.now()),
    Transaction(
        id: "t2", title: "New Shirt", amount: 1000, date: DateTime.now()),
  ];

  void _addNewTransaction(String title,double amount){
    final tx = Transaction(id:DateTime.now().toString(),title: title, amount: amount,date: DateTime.now());
    setState(() {
      //_userTransactions.add(tx); Adds at the end
      _userTransactions.insert(0, tx); //adds at the front
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextInput(addTransaction: _addNewTransaction),
          TransactionList(transactions:_userTransactions),
        ],
      ),
    );
  }
}