import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension FromContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  String formatCurrency(String value) {
    return NumberFormat.decimalPatternDigits(decimalDigits: 0).format(double.parse(value)).replaceAll(',', '.');
  }
}
