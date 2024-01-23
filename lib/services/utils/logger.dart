// ignore_for_file: depend_on_referenced_packages

import 'package:logger/logger.dart';

/// ```dart
/// logger.v("Verbose log");
/// logger.d("Debug log");
/// logger.i("Info log");
/// logger.w("Warning log");
/// logger.e("Error log");
/// logger.wtf("What a terrible failure log");
/// ```
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 50,
  ),
);
