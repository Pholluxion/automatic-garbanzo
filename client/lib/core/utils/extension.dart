import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension FromContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  String formatCurrency(String value) {
    return NumberFormat.decimalPatternDigits(decimalDigits: 0)
        .format(double.parse(value))
        .replaceAll(',', '.');
  }
}

extension FromThemeData on ThemeData {
  ThemeData get getData {
    const dividerThemeData = DividerThemeData(
      color: Colors.transparent,
    );
    const cardTheme = CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );
    final elevatedButtonThemeData = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );

    final inputDecorationTheme = InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );

    return copyWith(
      cardTheme: cardTheme,
      dividerTheme: dividerThemeData,
      elevatedButtonTheme: elevatedButtonThemeData,
      inputDecorationTheme: inputDecorationTheme,
    );
  }
}
