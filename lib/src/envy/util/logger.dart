import 'package:logging/logging.dart';

/// Package-wide logger.
Logger logger = Logger('envy')
  ..onRecord.listen((LogRecord record) {
    // ignore: avoid_print
    print('${record.level}: ${record.message}');

    // ignore: avoid_print
    if (record.error != null) print('   ERROR:  ${record.error}');

    // ignore: avoid_print
    if (record.stackTrace != null) print(record.stackTrace);
  });
