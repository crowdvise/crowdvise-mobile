import 'package:flutter/services.dart';

class CustomPhoneFormatter extends TextInputFormatter {
  final String? countryCode;

  CustomPhoneFormatter({this.countryCode});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (countryCode != '1') {
      return newValue;
    }

    // Remove non-digits
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      return const TextEditingValue(text: '');
    }

    final buffer = StringBuffer();

    for (int i = 0; i < digits.length && i < 10; i++) {
      if (i == 3) buffer.write(' (');
      if (i == 6) buffer.write(')-');

      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
