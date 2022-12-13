import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextInput extends StatefulWidget {
  final Function addTransaction;
  TextInput({required this.addTransaction});

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  final _titleController = TextEditingController();
  //Text Editing Controller is used to access Input text from user
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(Duration(days: 1)); // late is used to initialise the variable as null. Otherwise specify that the var can't be null at any point using ?.
  // void submitData(){

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
        //User pressed cancel or back button
      }
      setState(() {
        _selectedDate=pickedDate;
      });
    });
    //showDatePicker must return a date when a date is selected but we don't know when the user selects the date after clicking CHOOSE DATE.
    //So a future has to be used as return type as it listens to the date select event and returns the value when the date is actually selected and not immediately return a junk after the function is called.
    // Future is non blocking. So even there's an independent statement below the future, it will be excuted.
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end,
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Enter Title"),
                controller: _titleController,
                onSubmitted: (_) => widget.addTransaction(_titleController.text,
                    double.parse(_amountController.text)),
                // onChanged: (val){
                //   titleInput = val;
                // },
              ),
              TextField(
                decoration: InputDecoration(labelText: "Enter Amount"),
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => widget.addTransaction(
                  _titleController.text,
                  double.parse(_amountController.text),
                ),

                // onChanged: (val){
                //   amountInput = val;
                // },
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Flexible(fit: FlexFit.tight,flex: 1,child: Text(_selectedDate.isAfter(DateTime.now())?"No date chosen": "Picked Date : ${DateFormat.yMd().format(_selectedDate)}")),
                    // Date to String conversion is done using format() constructor of DateFormat.
                    TextButton(
                      onPressed: _presentDatePicker,
                      child: Text(
                        "Choose Date",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  //print(titleController.text);
                  //print(enteredTitle);
                  //print(enteredAmount);
                  //print(amountController.text);
                  widget.addTransaction(_titleController.text,
                      double.parse(_amountController.text),_selectedDate);
                  Navigator.of(context).pop();
                },
                child: Container(
                  child: Text(
                    "Add Transaction",
                  ),
                  margin: EdgeInsets.all(20),
                ),
              ),
            ]),
      ),
    );
  }
}
