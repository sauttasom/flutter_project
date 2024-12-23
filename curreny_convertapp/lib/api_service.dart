import 'dart:convert';
import 'package:curreny_convertapp/conversion_result.dart';
import 'package:curreny_convertapp/currency_model';
import 'package:http/http.dart' as http;


class FastforexAPIService{
   String  apikey = '252049105a-bd103fdd97-sc4vyq';
   
  Future<ConversionResult> convertCurrencyFunction(String? from, String? to , double amount  ) async {

    var url = Uri.parse('https://api.fastforex.io/convert?from=${from}&to=${to}&amount=${amount}&api_key=${apikey}');

    var response = await http.get(url, headers: {'accept': 'application/json'});

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var res = ConversionResult.fromJson(jsonResponse);
      return res;
    } else {
      throw Exception('Failed to load data from API');
    }
  }
 Future<CurrencyList> FetchCurrencies() async {

    var url = Uri.parse('https://api.fastforex.io/currencies?api_key=${apikey}');

    var response = await http.get(url, headers: {'accept': 'application/json'});

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var result = CurrencyList.fromJson(jsonResponse);
      return result;
    } else {
      throw Exception('Failed to load data from API');
    }
  }
}
