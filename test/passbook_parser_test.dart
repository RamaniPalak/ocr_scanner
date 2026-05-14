import 'package:flutter_test/flutter_test.dart';
import 'package:ocr_scanner_app/core/parsers/passbook_parser.dart';

void main() {
  group('PassbookParser Tests', () {
    test('Should extract bank details correctly', () {
      const rawText = '''
        STATE BANK OF INDIA
        A/c Holder: RAJESH KUMAR
        Account No: 12345678901
        IFSC: SBIN0001234
        BRANCH: MUMBAI
      ''';
      
      final details = PassbookParser.parsePassbook(rawText);
      
      expect(details.accountHolderName, 'RAJESH KUMAR');
      expect(details.accountNumber, '12345678901');
      expect(details.ifscCode, 'SBIN0001234');
    });

    test('Should handle noisy text with heuristic fallback', () {
      const rawText = '''
        SOME BANK
        RANDOM TEXT 123
        JANE SMITH
        123456789012
      ''';
      
      final details = PassbookParser.parsePassbook(rawText);
      
      expect(details.accountHolderName, 'JANE SMITH');
      expect(details.accountNumber, '123456789012');
    });
  });
}
