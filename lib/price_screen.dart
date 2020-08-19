import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coinData = CoinData();
  String selectedCurrency = 'USD';
  Map<String, String> coinValues = {};
  bool isWaiting = false;

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String element in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(element),
        value: element,
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getdata();
        });
      },
    );
  }

  CupertinoPicker IOSPicker() {
    List<Text> dropdownItems = [];
    for (String element in currenciesList) {
      var newItem = Text(element);
      dropdownItems.add(newItem);
    }
    CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (int value) {
        selectedCurrency = value as String;
        getdata();
      },
      children: dropdownItems,
    );
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  void getdata() async {
    isWaiting = true;
    try {
      var data = await coinData.getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
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
          BitCard(
            money: isWaiting ? '?' : coinValues['BTC'],
            selectedCurrency: selectedCurrency,
            cryptoCurrency: 'BTC',
          ),
          BitCard(
            money: isWaiting ? '?' : coinValues['ETH'],
            selectedCurrency: selectedCurrency,
            cryptoCurrency: 'ETH',
          ),
          BitCard(
            money: isWaiting ? '?' : coinValues['LTC'],
            selectedCurrency: selectedCurrency,
            cryptoCurrency: 'LTC',
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? IOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class BitCard extends StatelessWidget {
  const BitCard({
    Key key,
    @required this.money,
    @required this.selectedCurrency,
    @required this.cryptoCurrency,
  }) : super(key: key);

  final String money;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $money $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
