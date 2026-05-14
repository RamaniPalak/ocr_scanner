import 'package:flutter_test/flutter_test.dart';
import 'package:ocr_scanner_app/core/utils/luhn_validator.dart';

void main() {
  group('LuhnValidator Tests', () {
    test('Valid card numbers should return true', () {
      // Common valid numbers for testing (using known patterns)
      expect(LuhnValidator.isValid('4532 0151 1283 0361'), true);
      expect(LuhnValidator.isValid('49927398716'), true);
    });

    test('Invalid card numbers should return false', () {
      expect(LuhnValidator.isValid('4532 0151 1283 0362'), false);
      expect(LuhnValidator.isValid('1234567812345678'), false);
    });

    test('Empty or non-digit strings should return false', () {
      expect(LuhnValidator.isValid(''), false);
      expect(LuhnValidator.isValid('ABC'), false);
    });
  });
}
