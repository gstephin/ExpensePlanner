import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import 'db_expense.dart';
import 'model/Transaction.dart';
import 'widgets/chart.dart';

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
  bool _showChart = false;
  List<TransactionExpense> _txnLists = [];

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

  List<Widget> _buildLandScapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txtList) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Show Chart',
                style: Theme.of(context).textTheme.title,
              ),
              Switch.adaptive(
                activeColor: Theme.of(context).accentColor,
                value: _showChart,
                onChanged: (val) {
                  setState(() {
                    _showChart = val;
                  });
                },
              ),
            ],
          )
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      mediaQuery.padding.top -
                      appBar.preferredSize.height) *
                  .3,
              child: Card(
                child: Container(
                  child:
                      _txnLists.isNotEmpty ? Chart(_txnLists) : Text('No Data'),
                  width: double.infinity,
                ),
                elevation: 30,
                color: Colors.blue,
              ),
            )
          : Container(),
      txtList
    ];
  }

  Widget _buildCupertinoAppBar() {
    return CupertinoNavigationBar(
      middle: Text(
        'Personal Expenses',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => _addNewTxn(context),
          ),
        ],
      ),
    );
  }

  Widget _buildScafoldAppBar() {
    return AppBar(
      title: Text('Expense Planner'),
      actions: <Widget>[
        IconButton(
          onPressed: () => _addNewTxn(context),
          icon: Icon(Icons.add),
        )
      ],
    );
  }

  List<Widget> _buildPortraitContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_txnLists),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar =
        Platform.isIOS ? _buildCupertinoAppBar() : _buildScafoldAppBar();

    final txtList = Container(
        height: (mediaQuery.size.height -
                mediaQuery.padding.top -
                appBar.preferredSize.height) *
            .7,
        child: TransactionList(_txnLists, _deleteTxn));
    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isLandscape)
            ..._buildLandScapeContent(mediaQuery, appBar, txtList)
          else
            ..._buildPortraitContent(mediaQuery, appBar, txtList)
        ],
      ),
    ));
    return FutureBuilder(
        future: DatabaseHelper.instance.listTx(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          _txnLists = snapshot.data;
          return Platform.isIOS
              ? CupertinoPageScaffold(
                  child: pageBody,
                  navigationBar: appBar,
                )
              : Scaffold(
                  appBar: appBar,
                  body: pageBody,
                  floatingActionButtonAnimator:
                      FloatingActionButtonAnimator.scaling,
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
