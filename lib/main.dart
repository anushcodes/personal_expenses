import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './widgets/textInput.dart';
import './models/transaction.dart';
import './widgets/transactionList.dart';
import './widgets/chart.dart';
import 'package:flutter/services.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // Preferred Orientation must be followed.
  runApp(const MyApp());
}
// Uncomment the platform check code to use in IOS
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
  bool _showChart = false;
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
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

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
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
            child: TextInputs(addTransaction: _addNewTransaction),
            onTap: () =>
                {}, //Tapping on the modal screen should not close the modal
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = /*Platform.isIOS? CupertinoNavigationBar(
      middle: const Text(
        "Personal Expenses",
        style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
        GestureDetector(
          child: Icon(CupertinoIcons.add),
          onTap: ()=> _startAddNewTransaction(context),
        )
      ]),
    )as PreferredSizeWidget:*/AppBar(
      title: const Text(
        "Personal Expenses",
        style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: Icon(Icons.add)),
      ],
    )as PreferredSizeWidget;
    final transactionListWidget = Container(
      height:
          (MediaQuery.of(context).size.height - appBar.preferredSize.height) *
              0.7,
      child: TransactionList(
        transactions: _userTransactions,
        deleteTx: _deleteTransaction,
      ),
    );

    final appBody = SafeArea(child:Column(
        children: [
          if (isLandscape)
            Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height) *
                  0.2,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Show Chart",style: Theme.of(context).textTheme.titleMedium,),
                Switch.adaptive(   //adaptive will use the platform available ui (IOS or Android Specific)
                    activeColor: Theme.of(context).accentColor,
                    value: _showChart,
                    onChanged: (value) {
                      setState(() {
                        _showChart = value;
                      });
                    })
              ]),
            ),
          if (!isLandscape)
            Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height) *
                    0.3,
                child: Chart(recentTransactions: _recentTransactions)),
          if (!isLandscape) transactionListWidget,
          if (isLandscape)
            _showChart
                ? Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height) *
                        0.7,
                    child: Chart(recentTransactions: _recentTransactions))
                : transactionListWidget,
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ));
    return /*Platform.isIOS? CupertinoPageScaffold(
      child: appBody,
      navigationBar: appBar as ObstructingPreferredSizeWidget?,
    ):*/Scaffold(
      appBar: appBar,
      body: appBody,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      // Use the platform check while testing in physical devices and emulators. It doesn't work while using in chrome.
      floatingActionButton: /*Platform.isIOS? Container() :*/ FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
