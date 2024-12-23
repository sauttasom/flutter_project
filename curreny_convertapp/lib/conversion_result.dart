
import 'dart:ffi';

class ConversionResult {
  String base;
  int amount;
  double total;
  int ms;

  ConversionResult({
    required this.base,
    required this.amount,
     required this.total,
    required this.ms,
  });

  factory ConversionResult.fromJson(Map<String, dynamic> json) {
    var data = json['result'] as Map<String, dynamic>;

    return ConversionResult(
      base: json['base'],
      amount: json['amount'],
      total: data.values.first , // Result.fromJson(json['result']),
      ms: json['ms'],
    );
  }
}
