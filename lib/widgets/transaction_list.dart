import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/Transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> list;

  TransactionList(this.list);

/*  */
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: list.isEmpty
          ? Column(
              children: <Widget>[
                SizedBox(height: 10),
                Text(
                  'No Transactions',
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(
                      'assets/images/ic_empty.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              ],
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8,horizontal: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(child: Text('\$${list[index].amount}')),
                      ),
                    ),
                    title: Text(
                      list[index].title,
                      style: Theme.of(ctx).textTheme.title,
                    ),
                    subtitle:
                        Text(DateFormat.yMMMMd('en_US').format(list[index].date)),
                  ),
                );
              },
              itemCount: list.length,
            ),
    );
  }
}
