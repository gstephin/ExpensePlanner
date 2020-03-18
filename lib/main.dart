import 'package:flutter/material.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import 'model/Transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: MyHomePage(),
      title: 'Expense Planner',
      theme: ThemeData(
          textTheme: ThemeData.light()
              .textTheme
              .copyWith(title: TextStyle(fontSize: 20)),
          primarySwatch: Colors.purple,
          primaryColor: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'QuickSand'),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String titleInput;

  String amountInput;
  final List<Transaction> _list = [
/*    Transaction(id: 't1', title: 'Shopping', amount: 600, date: DateTime.now()),
    Transaction(id: 't2', title: 'Grocery', amount: 500, date: DateTime.now()),*/
  ];

  void _addTxn(String txTitle, double txAmount, DateTime dateTime) {
    final txn = Transaction(
        title: txTitle,
        amount: txAmount,
        date: dateTime == null ? DateTime.now() : dateTime,
        id: dateTime == null ? DateTime.now().toString() : dateTime.toString());
    setState(() {
      _list.add(txn);
    });
  }

  void _deleteTxn(String id) {
    setState(() {
      _list.removeWhere((tx) => tx.id == id);
    });
  }

  void _addNewTxn(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: NewTransaction(_addTxn));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Planner'),
        actions: <Widget>[
          IconButton(
            onPressed: () => _addNewTxn(context),
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              child: Container(
                child: Chart(_list),
                width: double.infinity,
              ),
              clipBehavior: Clip.antiAlias,
              elevation: 30,
              color: Colors.blue,
            ),
            TransactionList(_list, _deleteTxn)
          ],
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewTxn(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
