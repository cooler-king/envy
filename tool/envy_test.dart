import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Serves the app.
void main() {
  serve();
}

/// Starts `pub run build_runner test -- -pchrome`.
Future<int> serve() async {
  final  process = await Process.start(
      'pub',
      <String>[
        'run',
        'build_runner',
        'test',
        '--',
        '-pchrome',
      ],
      runInShell: true);
  process.stdout.transform(utf8.decoder).listen(print);
  process.stderr.transform(utf8.decoder).listen(print);
  return process.exitCode;
}
