extension StringExtensions on String {
  // Formats a string to a number format (e.g. 1000000 -> 1,000,000)
  String toNumberFormat() {
    return parseToNumberFormat(this);
  }

  String parseToNumberFormat(String text) {
    return text.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }
}
