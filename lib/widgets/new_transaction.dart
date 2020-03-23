import 'package:expense_planner/model/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../db_expense.dart';

// ignore: must_be_immutable
class NewTransaction extends StatefulWidget {
  final Function handler;

  NewTransaction(this.handler);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();
  DateTime _dateTime;
  final dbHelper = DatabaseHelper.instance;

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((selectedDate) {
      if (selectedDate == null) {
        return;
      }
      setState(() {
        _dateTime = selectedDate;
      });
    });
  }

  void _submit() {
    final title = _titleController.text;
    final amount = int.parse(_amountController.text);
    if (title.isEmpty || amount < 1) {
      return;
    }

    widget.handler(title, amount, _dateTime.millisecondsSinceEpoch);
    _insert(TransactionExpense(
        id: _dateTime.millisecondsSinceEpoch,
        amount: amount,
        date: _dateTime.millisecondsSinceEpoch,
        title: title));
    Navigator.of(context).pop();
  }

  void _insert(TransactionExpense expense) async {
    // row to insert
    int id = await dbHelper.insertTx(expense);
    Fluttertoast.showToast(
        msg: "Transaction inserted..!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                controller: _titleController,
              ),
              TextField(
                keyboardType: TextInputType.numberWithOptions(),
                onSubmitted: (_) {
                  _submit();
                },
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
                controller: _amountController,
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Text(_dateTime == null
                        ? 'No Date Chosen'
                        : DateFormat.yMd('en_US').format(_dateTime)),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: _showDatePicker,
                    )
                  ],
                ),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text(
                  'Add Transaction',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () => _submit(),
              )
            ],
          ),
        ),
        elevation: 10,
      ),
    );
  }
}
