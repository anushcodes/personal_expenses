import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function? deleteTx;
  TransactionList({required this.transactions,this.deleteTx});
  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty? LayoutBuilder(builder: (context,constraints){
      return Column(
        children: [
          Text("No Transactions yet",style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.bold),),
          SizedBox(height: 50,),
          Container(height:constraints.maxHeight*0.6,child: Image.asset('assets/images/waiting.png',fit: BoxFit.cover,)),
        ],
      ); 
    })
    :ListView.builder( 
        //ListView loads all list items at once. So we might face performance issues whereas ListView.builder uses lazy loading
        //mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        itemBuilder: (context, index) {
          // return Card(
          //   child: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Container(
          //           padding: EdgeInsets.all(10),
          //           margin: EdgeInsets.symmetric(
          //             horizontal: 15,
          //             vertical: 10,
          //           ),
          //           decoration: BoxDecoration(
          //               border:
          //                   Border.all(color: Theme.of(context).primaryColorLight, width: 2)),
          //           child: Text(
          //             "₹${transactions[index].amount!.toStringAsFixed(2)}",
          //             style: TextStyle(
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: 20,
          //                 color: Theme.of(context).primaryColorDark),
          //           ),
          //         ),
          //         Column(
          //           //mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               transactions[index].title!,
          //               style: TextStyle(
          //                   fontSize: 16, fontWeight: FontWeight.bold),
          //             ),
          //             Text(
          //               DateFormat().format(transactions[index].date!), //
          //               style: TextStyle(color: Colors.grey),
          //             ),
          //           ],
          //         )
          //       ]),
          // );

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8,horizontal: 5),
            elevation: 5,
            child: ListTile(
              leading: CircleAvatar(radius: 30,child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: FittedBox(child: Text('₹${transactions[index].amount!.toStringAsFixed(2)}')),
              ),),
              title: Text(transactions[index].title!,style:TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.bold),),
              subtitle: Text(DateFormat.yMMMd().format(transactions[index].date!)),
              trailing: IconButton(icon: Icon(Icons.delete),onPressed: ()=>deleteTx!(transactions[index].id),color: Theme.of(context).errorColor,),
            ),
          );
        },
        itemCount: transactions.length,
    );
  }
}
