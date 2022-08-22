import 'dart:io' show Platform;
import 'package:bitcoin_ticker/constants.dart';
import 'package:bitcoin_ticker/models/crypto.dart';
import 'package:bitcoin_ticker/services/NetworkManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  double btcRate = 0;
  double ethRate = 0;
  double ltcRate = 0;

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
            child: Card(
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
                      '1 BTC = $btcRate $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '1 ETH = $ethRate $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '1 LTC = $ltcRate $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
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
    Iterable<Future<double>> networkCalls =
        kCryptoList.map((cryptoAbbrev) async {
      return await NetworkManager().getData(
          cryptoAbbrev: cryptoAbbrev, currencyAbbrev: selectedCurrency);
    });

    List<double> cryptoRates = await Future.wait(networkCalls);

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
