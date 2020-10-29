import 'package:flutter/cupertino.dart';
import 'network_helper.dart';

const kBaseUrl = 'https://rest.coinapi.io/v1/exchangerate/';
const kAPIKey = '8EB544E2-4DF0-44FF-8EBC-7E70C27C7744';//'BFA3EF9D-14DA-42F1-A7C3-BA7741700608';

class Network {
  final String currencyName;
  final String cryptoCurrencyType;

  Network({@required this.currencyName, @required this.cryptoCurrencyType});

  Future getCryptoCurrencyRate() async{
    String url = kBaseUrl + cryptoCurrencyType + '/' + currencyName + '?apikey=' + kAPIKey;
    NetworkHelper networkHelper = NetworkHelper(url: url);
    var data = await networkHelper.getCurrentCryptoValue();
    return data['rate'].toStringAsFixed(1);
  }

}

/*
Map<String, dynamic> dict;
  if(data['asset_id_base'] == 'BTC') {
  dict['BTC'] = data['rate'].toStringAsFixed(2);
  } else if (data['asset_id_base'] == 'ETH') {
  dict['ETH'] = data['rate'].toStringAsFixed(2);
  } else if (data['asset_id_base'] == 'LTC') {
  dict['LTC'] = data['rate'].toStringAsFixed(2);
  }
  return dict;
 */