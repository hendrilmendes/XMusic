import 'dart:convert';
import 'dart:developer';

void pprint(dynamic data) {
  const JsonEncoder encoder = JsonEncoder.withIndent('  ');
  final jsonString = encoder.convert(data);
  log(jsonString);
}
