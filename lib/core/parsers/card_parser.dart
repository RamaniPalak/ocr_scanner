import '../models/card_details.dart';
import '../utils/luhn_validator.dart';

class CardParser {
  /// Parses raw OCR text to extract card details.
  /// 
  /// Handles:
  /// - Misreads (O -> 0, I -> 1)
  /// - Spacing/Dashes
  /// - Various expiry formats
  static CardDetails parseCard(String rawText) {
    // 1. Pre-process text: Fix common OCR misreads for digits
    String processedText = _fixOcrMisreads(rawText);
    
    // 2. Extract Card Number
    String cardNumber = _extractCardNumber(processedText);
    bool isValid = LuhnValidator.isValid(cardNumber);
    
    // 3. Extract Expiry Date
    String expiryDate = _extractExpiryDate(processedText);
    
    // 4. Extract Card Holder Name
    String? cardHolderName = _extractCardHolderName(rawText); // Use raw text for name to avoid digit substitution

    return CardDetails(
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cardHolderName: cardHolderName,
      isValid: isValid,
    );
  }

  static String _fixOcrMisreads(String text) {
    // Replace common OCR errors in digits context
    // This is sensitive; we only want to replace when it's likely a number
    return text.replaceAll('O', '0')
               .replaceAll('o', '0')
               .replaceAll('I', '1')
               .replaceAll('|', '1')
               .replaceAll('l', '1');
  }

  static String _extractCardNumber(String text) {
    // Look for 13-19 digits, possibly separated by spaces or dashes
    final RegExp cardRegExp = RegExp(r'(?:\d[ -]*?){13,19}');
    Iterable<Match> matches = cardRegExp.allMatches(text);
    
    for (var match in matches) {
      String potential = match.group(0)!.replaceAll(RegExp(r'[ -]'), '');
      if (potential.length >= 13 && potential.length <= 19) {
        // If it passes Luhn, we found it!
        if (LuhnValidator.isValid(potential)) {
          return potential;
        }
      }
    }
    
    // If no valid Luhn number found, return the longest sequence of digits found
    String longest = "";
    for (var match in matches) {
      String potential = match.group(0)!.replaceAll(RegExp(r'[ -]'), '');
      if (potential.length > longest.length) {
        longest = potential;
      }
    }
    return longest;
  }

  static String _extractExpiryDate(String text) {
    // Patterns: MM/YY, MM-YY, MMYY
    final RegExp expiryRegExp = RegExp(r'(0[1-9]|1[0-2])\s?[\/-]?\s?([2-9][0-9])');
    Match? match = expiryRegExp.firstMatch(text);
    
    if (match != null) {
      return "${match.group(1)}/${match.group(2)}";
    }
    
    // Fallback for 4 digit sequence like 1225
    final RegExp fourDigitRegExp = RegExp(r'\b(0[1-9]|1[0-2])([2-9][0-9])\b');
    match = fourDigitRegExp.firstMatch(text);
    if (match != null) {
       return "${match.group(1)}/${match.group(2)}";
    }

    return "Not Found";
  }

  static String? _extractCardHolderName(String text) {
    // Simple heuristic: Name is usually in ALL CAPS, 2-3 words, 
    // and doesn't contain digits or common card brand names.
    List<String> lines = text.split('\n');
    List<String> cardBrands = ['VISA', 'MASTERCARD', 'MAESTRO', 'AMEX', 'AMERICAN EXPRESS', 'DISCOVER', 'RUPAY'];

    for (String line in lines) {
      String trimmed = line.trim();
      // Skip short lines or lines with digits
      if (trimmed.length < 3 || RegExp(r'\d').hasMatch(trimmed)) continue;
      
      // Check if it's all uppercase and has at least one space (First Last)
      if (trimmed == trimmed.toUpperCase() && trimmed.contains(' ')) {
        // Skip if it's a card brand
        bool isBrand = false;
        for (var brand in cardBrands) {
          if (trimmed.contains(brand)) {
            isBrand = true;
            break;
          }
        }
        if (!isBrand) return trimmed;
      }
    }
    return null;
  }
}
