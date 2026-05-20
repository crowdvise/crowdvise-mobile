import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomMoneyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove all non-digits
    final cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Parse the number
    final number = int.tryParse(cleanText) ?? 0;

    // Format with commas using NumberFormat
    final formatted = NumberFormat('#,###').format(number);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
