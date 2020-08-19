import 'dart:core';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

const apiKey = '8AEF9BA4-3907-4B41-9183-78A3F91533E7';
const link = 'https://rest.coinapi.io/v1/exchangerate';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<dynamic> getCoinData(
      String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      Response response = await get(
          '$link/$crypto/$selectedCurrency?apikey=$apiKey');
      if (response.statusCode == 200) {
        String data = response.body;
        var money = jsonDecode(data)['rate'];
        cryptoPrices[crypto]=money.toStringAsFixed(0);
      } else {
        print(response.statusCode);
      }
    }
    return cryptoPrices;
  }
}
