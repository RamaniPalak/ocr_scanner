import 'package:flutter_test/flutter_test.dart';
import 'package:ocr_scanner_app/core/parsers/card_parser.dart';

void main() {
  group('CardParser Tests', () {
    test('Should parse card with spacing and misreads', () {
      const rawText = '''
        VISA
        4532 O151 1283 0361
        EXPIRY 12/25
        JOHN DOE
      ''';
      
      final details = CardParser.parseCard(rawText);
      
      expect(details.cardNumber, '4532015112830361');
      expect(details.expiryDate, '12/25');
      expect(details.cardHolderName, 'JOHN DOE');
      expect(details.isValid, true);
    });

    test('Should handle 4-digit expiry format', () {
      const rawText = 'CARD 1225';
      final details = CardParser.parseCard(rawText);
      expect(details.expiryDate, '12/25');
    });

    test('Should handle lowercase misreads', () {
      const rawText = '4532 o151 1283 0361';
      final details = CardParser.parseCard(rawText);
      expect(details.cardNumber, '4532015112830361');
    });
  });
}
