import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Serves the app on port 3689.
void main() {
  serve();
}

/// Starts pub run build_runner serve.
Future<int> serve() async {
  final Process process = await Process.start(
      'pub',
      <String>[
        'run',
        'build_runner',
        'serve',
        'example:8888',
        '--hostname=0.0.0.0',
        '--config=gallery',
      ],
      runInShell: true);
  process.stdout.transform(utf8.decoder).listen(print);
  process.stderr.transform(utf8.decoder).listen(print);
  return await process.exitCode;
}
