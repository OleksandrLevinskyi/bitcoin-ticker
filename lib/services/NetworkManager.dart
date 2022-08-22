import 'dart:convert' as convert;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NetworkManager {
  final cryptoAbbrev = 'BTC';
  final currencyAbbrev = 'USD';

  // NetworkManager(this.cryptoAbbrev, this.currencyAbbrev);

  void getData() async {
    Uri uri = Uri.https(
      dotenv.env['API_URL'],
      'indices/global/ticker/$cryptoAbbrev$currencyAbbrev',
    );
    print(uri);

    dynamic response = await http.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      double cryptoPrice = data['last'];
      print(cryptoPrice);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
