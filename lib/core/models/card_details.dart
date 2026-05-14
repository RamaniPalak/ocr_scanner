class CardDetails {
  final String cardNumber;
  final String expiryDate;
  final String? cardHolderName;
  final bool isValid;

  CardDetails({
    required this.cardNumber,
    required this.expiryDate,
    this.cardHolderName,
    this.isValid = false,
  });

  @override
  String toString() {
    return 'CardDetails(cardNumber: $cardNumber, expiryDate: $expiryDate, name: $cardHolderName, isValid: $isValid)';
  }
}
