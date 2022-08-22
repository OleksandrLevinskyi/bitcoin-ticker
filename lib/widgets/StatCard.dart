import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final int cryptoRate;
  final String currencyAbbrev;
  final String cryptoAbbrev;

  const StatCard({this.cryptoRate, this.currencyAbbrev, this.cryptoAbbrev});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Column(
          children: [
            Text(
              '1 $cryptoAbbrev = $cryptoRate $currencyAbbrev',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
