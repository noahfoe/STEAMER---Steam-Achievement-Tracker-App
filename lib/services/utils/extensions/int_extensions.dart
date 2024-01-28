extension IntExtensions on int {
  // Formats a string to a number format (e.g. 1000000 -> 1,000,000)
  int minutesToHours() {
    return parseMinToHourFormat(this);
  }

  int parseMinToHourFormat(int num) {
    return num ~/ 60;
  }
}
