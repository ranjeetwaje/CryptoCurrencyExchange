import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {

  final String url;
  
  NetworkHelper({@required this.url});

  Future getCurrentCryptoValue() async {
    http.Response response = await http.get(url);

    if(response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.body);
    }
  }
}