import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String quote = 'USD';
  final cryptoRateList = cryptoList.map((e) => '?').toList();

  CupertinoPicker iosPicker() => CupertinoPicker(
        itemExtent: 32,
        onSelectedItemChanged: (value) =>
            setState(() => setQuote(currenciesList[value])),
        children: currenciesList.map((e) => Text(e)).toList(),
      );

  DropdownButton<String> androidDropdown() => DropdownButton(
        value: quote,
        items: currenciesList
            .map((e) => DropdownMenuItem(child: Text(e), value: e))
            .toList(),
        onChanged: (value) => setQuote(value),
      );

  void setQuote(String quote) {
    this.quote = quote;
    getData();
  }

  void getData() {
    final coinData = CoinData();
    cryptoList.asMap().entries.forEach((crypto) async {
      var data = await coinData.getCoinData(crypto.value, quote);
      if (data != null) {
        setState(() => cryptoRateList[crypto.key] =
            '${(double.tryParse(data['rate'].toString()) ?? 0.0).round()}');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: cryptoList
                .asMap()
                .entries
                .map((crypto) => Padding(
                      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                      child: Card(
                        color: Colors.lightBlueAccent,
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 28.0),
                          child: Text(
                            '1 ${crypto.value} = ${cryptoRateList[crypto.key]} $quote',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
