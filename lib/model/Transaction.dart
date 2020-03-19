import 'package:flutter/foundation.dart';

class TransactionExpense {
  int id;
  String title;
  int amount;
  int date;

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'amount': amount, 'date': date};
  }

  TransactionExpense({@required this.id, this.title, this.amount, this.date});

  @override
  String toString() {
    return 'Transaction{id: $id, tite: $title, amount: $amount, date:$date}';
  }
}
