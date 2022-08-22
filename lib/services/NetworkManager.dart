import 'dart:convert' as convert;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/crypto.dart';

class NetworkManager {
  Future<CryptoData> getData(
      {cryptoAbbrev = 'BTC', currencyAbbrev = 'USD'}) async {
    Uri uri = Uri.https(
      dotenv.env['API_URL'],
      'indices/global/ticker/$cryptoAbbrev$currencyAbbrev',
    );

    dynamic response = await http.get(
      uri,
      headers: {
        'x-ba-key': dotenv.env['API_KEY'],
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      double cryptoPrice = data['last'];

      return CryptoData(cryptoPrice);
    }

    print('Request failed with status: ${response.statusCode}.');
    return CryptoData(0);
  }
}
