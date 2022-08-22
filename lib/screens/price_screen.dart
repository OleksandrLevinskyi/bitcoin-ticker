import 'dart:io' show Platform;
import 'package:bitcoin_ticker/constants.dart';
import 'package:bitcoin_ticker/services/NetworkManager.dart';
import 'package:bitcoin_ticker/widgets/StatCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Map<String, int> cryptoRates = {};

  @override
  void initState() {
    super.initState();

    updateCurrencyStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: getStatCards(),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getDropdown(),
          ),
        ],
      ),
    );
  }

  List<StatCard> getStatCards() {
    return cryptoRates.entries.map((entry) {
      return StatCard(
        cryptoAbbrev: entry.key,
        cryptoRate: entry.value,
        currencyAbbrev: selectedCurrency,
      );
    }).toList();
  }

  Future<void> updateCurrencyStats() async {
    Map<String, int> rates = {};

    for (String cryptoAbbrev in kCryptoList) {
      rates.addEntries([
        MapEntry(
          cryptoAbbrev,
          await NetworkManager().getData(
            cryptoAbbrev: cryptoAbbrev,
            currencyAbbrev: selectedCurrency,
          ),
        ),
      ]);
    }

    setState(() {
      cryptoRates = rates;
    });
  }

  Widget getDropdown() {
    if (Platform.isAndroid) {
      return getAndroidDropdown();
    }

    return getAppleDropdown();
  }

  CupertinoPicker getAppleDropdown() {
    List<Text> dropdownMenuItems =
        kCurrenciesList.map((currency) => Text(currency)).toList();

    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedIdx) {
        selectNewCurrency(kCurrenciesList[selectedIdx]);
        updateCurrencyStats();
      },
      children: dropdownMenuItems,
    );
  }

  DropdownButton<String> getAndroidDropdown() {
    List<DropdownMenuItem<String>> dropdownMenuItems =
        kCurrenciesList.map((currency) {
      return DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
    }).toList();

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownMenuItems,
      onChanged: (value) {
        selectNewCurrency(value);
        updateCurrencyStats();
      },
    );
  }

  void selectNewCurrency(value) {
    setState(() {
      selectedCurrency = value;
    });
  }
}
