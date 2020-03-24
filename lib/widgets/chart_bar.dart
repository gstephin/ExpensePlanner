import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctTotal;

  const ChartBar(this.label, this.spendingAmount, this.spendingPctTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: <Widget>[
            Container(
                height: constraints.maxHeight * .15,
                child: FittedBox(
                    child: Text('\$${spendingAmount.toStringAsFixed(0)}'))),
            SizedBox(
              height: constraints.maxHeight * .05,
            ),
            Container(
                height: constraints.maxHeight * .6,
                width: 10,
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(220, 220, 220, 1),
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    FractionallySizedBox(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      heightFactor: spendingPctTotal,
                    ),
                  ],
                )),
            SizedBox(
              height: constraints.maxHeight * .05,
            ),
            Container(
                height: constraints.maxHeight * .15,
                child: FittedBox(child: Text(label)))
          ],
        );
      },
    );
  }
}
