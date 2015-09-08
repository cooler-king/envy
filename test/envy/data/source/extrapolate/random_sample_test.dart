@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

main() {
  group('Random Sample', () {
    test('null and empty values', () {
      RandomSample rs = new RandomSample();
      expect(rs.valueAt(0, null), null);
      expect(rs.valueAt(0, []), null);
    });

    test('index >= values.length', () {
      RandomSample rs = new RandomSample();
      expect(rs.valueAt(1, [13]), 13);

      num x = rs.valueAt(2, [13, 54]);
      expect(x == 13 || x == 54, true);

      bool match1 = false;
      bool match2 = false;
      bool match3 = false;
      for (int i = 0; i < 1000; i++) {
        x = rs.valueAt(897, [2, 7, 12]);
        expect(x == 2 || x == 7 || x == 12, true);
        if (x == 2) match1 = true;
        if (x == 7) match2 = true;
        if (x == 12) match3 = true;
        if (match1 && match2 && match3) break;
      }
      expect(match1 && match2 && match3, true);
    });
  });
}
