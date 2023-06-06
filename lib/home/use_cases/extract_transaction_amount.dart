class ExtractTransactionAmount {
  final _amountRegex1 = RegExp(r"aed\.?\s*([\d,.]+)");
  final _amountRegex2 = RegExp(r"\.?\s*([\d,.]+).aed");
  final keepDigitsOnlyRegex = RegExp(r'[^0-9|.]');

  double? call(String? string) {
    if(string != null) {
      final match1 = _amountRegex1.firstMatch(string.toLowerCase());
      final match2 = _amountRegex2.firstMatch(string.toLowerCase());
      if (match1 != null) {
        var amountString = match1.group(1)!;
        return double.tryParse(amountString.replaceAll(keepDigitsOnlyRegex,''));
      }
      if (match2 != null) {
        var amountString = match2.group(1)!;
        return double.tryParse(amountString.replaceAll(keepDigitsOnlyRegex,''));
      }
    }
    return null;
  }
}