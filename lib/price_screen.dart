import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'network.dart';


class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedCurrency = 'AUD';
  String currentPrice = '?';
  Network network;
  Map<String, String> rateDict = {};
  bool isWaiting = false;

  void getData(String cryptoCurrencyType) async{
    network =  Network(currencyName: selectedCurrency, cryptoCurrencyType: cryptoCurrencyType);
    try {
      String rate = await network.getCryptoCurrencyRate();
      setState(() {
        currentPrice = rate;
      });
    } catch(e) {
      print(e.toString());
    }
  }

  DropdownButton androidDropDown() {
    List<DropdownMenuItem<String>> dropDownMenuItemList = [];

    for (String item in currenciesList) {
      var dropDownItem = DropdownMenuItem(
        child: Text(item),
        value: item,
      );
      dropDownMenuItemList.add(dropDownItem);
    }
    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropDownMenuItemList,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value;
            getCryptoRate();
          });
        });
  }

  CupertinoPicker iOSPicker() {
    List<Widget> children = [];
    for (String item in currenciesList) {
      children.add(Text(item));
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getCryptoRate();
        });
      },
      children: children,
    );
  }

  @override
  void initState(){
    super.initState();
    getCryptoRate();
  }

  void getCryptoRate() async {
    isWaiting = true;
    for (String cryptoCurrency in cryptoList) {
      getData(cryptoCurrency);
      network =  Network(currencyName: selectedCurrency, cryptoCurrencyType: cryptoCurrency);
      try {
        String rate = await network.getCryptoCurrencyRate();
        setState(() {
          isWaiting = false;
          rateDict[cryptoCurrency] = rate;
        });
      } catch(e) {
        print(e.toString());
      }
    }
  }

  Column makeCards() {
    List<CryptoCard> cards = [];
    for (String cryptoCurrency in cryptoList) {
      cards.add(
        CryptoCard(rate: isWaiting ? '?' : rateDict[cryptoCurrency], cryptoCurrency: cryptoCurrency, selectedCurrency: selectedCurrency)
      );
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: cards
    );
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
            child: makeCards(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS? iOSPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {

  CryptoCard({
    @required this.rate,
    @required this.cryptoCurrency,
    @required this.selectedCurrency,
  });

  final String rate;
  final String cryptoCurrency;
  final String selectedCurrency;

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
        child: Text(
          '1 $cryptoCurrency = $rate $selectedCurrency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
