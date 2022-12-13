import 'package:flutter/material.dart';
import './chartBar.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  Chart({required this.recentTransactions});
  List<Map<String, Object>> get groupedTransactionsValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date!.day == weekDay.day &&
            recentTransactions[i].date!.month == weekDay.month &&
            recentTransactions[i].date!.year == weekDay.year) {
          totalSum += recentTransactions[i].amount as double;
        }
      }
      // print(DateFormat.E().format(weekDay));
      // print(totalSum);
      return {'day': DateFormat.E().format(weekDay), 'amount': totalSum};
    }).reversed.toList();
    //This getter is used to update the weekly expense.
    // List.generate is used to generate n items by using a function.
  }

  double get totalSpending {
    return groupedTransactionsValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
    //initial value is 0.0 and sum holds 0.0 and at every updation. sum = sum+item['amount']
  }

  @override
  Widget build(BuildContext context) {
    // print(groupedTransactionsValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: groupedTransactionsValues.map((data) {
          //return Text('${data['day']}: ${data['amount']}');
          return Flexible(
            fit: FlexFit.tight,
            child: ChartBar(
                label: data['day'] as String,
                spendingAmount: data['amount'] as double,
                spendingPercentage: totalSpending == 0
                    ? 0
                    : (data['amount'] as double) / totalSpending),
          );
                  // If the spending amount is 0 and totalSpending is 0 (occurs only before the first entry of the week.), Runtime error is faced. So use 0% if spending amount is 0;
        }).toList()),
      ),
    );
  }
}
