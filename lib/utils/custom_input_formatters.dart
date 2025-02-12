import "package:flutter/services.dart";
import 'package:intl/intl.dart';

class CreditCardInputFormattor extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text =
        newValue.text.replaceAll(RegExp(r"\s"), ""); // Remove existing spaces
    String result = "";

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        result += " "; // Add a space after every four characters
      }
      result += text[i];
    }

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

class AadhaarInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final formattedText = _formatPhoneNumber(newValue.text);
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatPhoneNumber(String input) {
    input = input.replaceAll(RegExp(r'\D'), ''); // Remove non-digit characters

    if (input.length <= 4) {
      return input;
    } else if (input.length <= 8) {
      return '${input.substring(0, 4)}-${input.substring(4)}';
    } else {
      return '${input.substring(0, 4)}-${input.substring(4, 8)}-${input.substring(8)}';
    }
  }
}

class CreditCardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueString = newValue.text;
    String valueToReturn = "";

    for (int i = 0; i < newValueString.length; i++) {
      if (newValueString[i] != "/") valueToReturn += newValueString[i];
      if (newValueString.length == 2 &&
          (int.tryParse(newValueString) ?? 0) > 12) {
        valueToReturn = "12/";
      }
      var nonZeroIndex = i + 1;
      final contains = valueToReturn.contains(RegExp(r"\/"));
      if (nonZeroIndex % 2 == 0 &&
          nonZeroIndex != newValueString.length &&
          !(contains)) {
        valueToReturn += "/";
      }
    }
    return newValue.copyWith(
      text: valueToReturn,
      selection: TextSelection.fromPosition(
        TextPosition(offset: valueToReturn.length),
      ),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  final int maxDecimalPlaces;

  DecimalTextInputFormatter(this.maxDecimalPlaces);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove non-digit characters
    String cleanedText = newValue.text.replaceAll(RegExp(r"[^\d.]"), "");

    // Split the cleaned text into whole and decimal parts
    List<String> parts = cleanedText.split(".");

    if (parts.length > 2) {
      // There can only be at most one decimal point
      return oldValue;
    }

    if (parts.length == 2) {
      // Ensure there are at most two decimal places
      String decimalPart = parts[1];
      if (decimalPart.length > maxDecimalPlaces) {
        return oldValue;
      }
    }

    return TextEditingValue(
      text: cleanedText,
      selection: TextSelection.collapsed(offset: cleanedText.length),
    );
  }
}

class IFSCCodeInputFormatter extends TextInputFormatter {
  IFSCCodeInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Apply the regular expression to validate the input
    if (RegExp(r"^[A-Z]{4}0\d{6}$").hasMatch(newValue.text)) {
      return newValue; // Input is valid, allow it.
    } else {
      // Input is invalid, do not allow it.
      return oldValue;
    }
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      TextEditingValue(
        text: newValue.text.toUpperCase(),
        selection: newValue.selection,
      );
}

class AmountLimitFormatter extends TextInputFormatter {
  final double limit;

  AmountLimitFormatter(this.limit);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final double enteredAmount = double.tryParse(newValue.text) ?? 0.0;
    if (enteredAmount > limit) {
      // Limit the input to the specified maximum value
      // text: oldValue.text,
      //   selection: oldValue.selection,
      return TextEditingValue(
        text: limit.toStringAsFixed(2),
        selection:
            TextSelection.collapsed(offset: limit.toStringAsFixed(2).length),
      );
    }
    return newValue;
  }
}

String formatTimestamp(String timestamp) {
  DateTime dateTime = DateTime.parse(timestamp);
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = today.subtract(const Duration(days: 1));
  DateTime beforeYesterday = today.subtract(const Duration(days: 2));

  if (dateTime.isAfter(now.subtract(const Duration(minutes: 1)))) {
    return "now";
  } else if (dateTime.isAfter(today)) {
    return "today";
  } else if (dateTime.isAfter(yesterday) && dateTime.isBefore(today)) {
    return "yesterday";
  } else if (dateTime.isAfter(beforeYesterday) &&
      dateTime.isBefore(yesterday)) {
    return "before yesterday";
  } else {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }
}
