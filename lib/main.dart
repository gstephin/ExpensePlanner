import 'package:expense_planner/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import 'db_expense.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft
  ]);
  runApp(MyApp());
}

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

  @override
  void initState() {
    super.initState();
  }

  void _addTxn(String txTitle, int txAmount, int dateTime) {
    setState(() {});
  }

  void _deleteTxn(int id) {
    setState(() {
      DatabaseHelper.instance.deleteTx(id);
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
    var mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text('Expense Planner'),
      actions: <Widget>[
        IconButton(
          onPressed: () => _addNewTxn(context),
          icon: Icon(Icons.add),
        )
      ],
    );

    return FutureBuilder(
        future: DatabaseHelper.instance.listTx(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Scaffold(
            appBar: appBar,
            body: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: (mediaQuery.size.height -
                        mediaQuery.padding.top -
                            appBar.preferredSize.height) *
                        .3,
                    child: Card(
                      child: Container(
                        child: snapshot.hasData
                            ? Chart(snapshot.data)
                            : Text('No Data'),
                        width: double.infinity,
                      ),
                      elevation: 30,
                      color: Colors.blue,
                    ),
                  ),
                  Container(
                      height: (mediaQuery.size.height -
                          mediaQuery.padding.top -
                              appBar.preferredSize.height) *
                          .7,
                      child: TransactionList(snapshot.data, _deleteTxn))
                ],
              ),
            ),
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () => _addNewTxn(context),
              child: Icon(Icons.add),
            ),
          );
        });
  }
}
