class LuhnValidator {
  /// Validates a card number using the Luhn algorithm.
  /// 
  /// Mandatory Requirements:
  /// 1. Reverse the card number.
  /// 2. Double every second digit.
  /// 3. If doubling results in a number > 9, subtract 9.
  /// 4. Sum all digits.
  /// 5. Check if sum % 10 == 0.
  static bool isValid(String cardNumber) {
    // Remove all non-digit characters
    String cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');
    
    if (cleanNumber.isEmpty) return false;

    int sum = 0;
    bool shouldDouble = false;

    // Iterate from right to left
    for (int i = cleanNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cleanNumber[i]);

      if (shouldDouble) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      shouldDouble = !shouldDouble;
    }

    return sum % 10 == 0;
  }
}
