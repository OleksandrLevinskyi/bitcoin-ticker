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
  int btcRate = 0;
  int ethRate = 0;
  int ltcRate = 0;

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
              children: [
                StatCard(
                  cryptoAbbrev: 'BTC',
                  cryptoRate: btcRate,
                  currencyAbbrev: selectedCurrency,
                ),
                StatCard(
                  cryptoAbbrev: 'ETH',
                  cryptoRate: ethRate,
                  currencyAbbrev: selectedCurrency,
                ),
                StatCard(
                  cryptoAbbrev: 'LTC',
                  cryptoRate: ltcRate,
                  currencyAbbrev: selectedCurrency,
                ),
              ],
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

  Future<void> updateCurrencyStats() async {
    Iterable<Future<int>> networkCalls = kCryptoList.map((cryptoAbbrev) async {
      return await NetworkManager().getData(
          cryptoAbbrev: cryptoAbbrev, currencyAbbrev: selectedCurrency);
    });

    List<int> cryptoRates = await Future.wait(networkCalls);

    setState(() {
      btcRate = cryptoRates[0];
      ethRate = cryptoRates[1];
      ltcRate = cryptoRates[2];
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
