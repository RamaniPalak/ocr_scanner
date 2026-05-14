import '../models/bank_details.dart';

class PassbookParser {
  /// Parses raw OCR text from a passbook or bank document.
  static BankDetails parsePassbook(String rawText) {
    String accountNumber = _extractAccountNumber(rawText);
    String? ifscCode = _extractIfscCode(rawText);
    String accountHolderName = _extractAccountHolderName(rawText);

    return BankDetails(
      accountHolderName: accountHolderName,
      accountNumber: accountNumber,
      ifscCode: ifscCode,
    );
  }

  static String _extractAccountNumber(String text) {
    // Look for lines containing "Account" or "A/c" and extract digits nearby
    List<String> lines = text.split('\n');
    RegExp accNoPattern = RegExp(r'(?:acc(?:ount)?(?:\s?no)?)[:\s]+(\d{9,18})', caseSensitive: false);
    
    for (String line in lines) {
      Match? match = accNoPattern.firstMatch(line);
      if (match != null) {
        return match.group(1)!;
      }
    }

    // Fallback: search for any sequence of 9-18 digits that isn't the IFSC (IFSC can't be all digits anyway)
    RegExp digitSequence = RegExp(r'\b\d{9,18}\b');
    Iterable<Match> matches = digitSequence.allMatches(text);
    if (matches.isNotEmpty) {
      return matches.first.group(0)!;
    }

    return "Not Found";
  }

  static String? _extractIfscCode(String text) {
    // IFSC Pattern: 4 alphabets, 0, then 6 alphanumeric characters
    RegExp ifscRegExp = RegExp(r'[A-Z]{4}0[A-Z0-9]{6}', caseSensitive: false);
    Match? match = ifscRegExp.firstMatch(text);
    return match?.group(0)?.toUpperCase();
  }

  static String _extractAccountHolderName(String text) {
    List<String> lines = text.split('\n');
    RegExp namePattern = RegExp(r'(?:name|holder|a/c holder)[:\s]+([a-zA-Z\s]{3,})', caseSensitive: false);

    for (String line in lines) {
      Match? match = namePattern.firstMatch(line);
      if (match != null) {
        return match.group(1)!.trim();
      }
    }

    // Heuristic fallback: The first line that is capitalized and contains 2-3 words
    for (String line in lines) {
      String trimmed = line.trim();
      if (trimmed.length > 5 && 
          !trimmed.contains(RegExp(r'\d')) && 
          trimmed == trimmed.toUpperCase() &&
          trimmed.split(' ').length >= 2) {
        return trimmed;
      }
    }

    return "Not Found";
  }
}
