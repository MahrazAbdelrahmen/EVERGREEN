import 'package:flutter_test/flutter_test.dart';
import 'package:sorttrash/Puzzle/jigsaw.dart';

void main() {
  for (final n in [3, 4, 5]) {
    test('jigsaw cut of $n×$n interlocks and has flat borders', () {
      final cut = JigsawCut(n, 42);
      for (int r = 0; r < n; r++) {
        for (int c = 0; c < n; c++) {
          final e = cut.edgesOf(r, c);
          expect(e.top == 0, r == 0);
          expect(e.left == 0, c == 0);
          expect(e.bottom == 0, r == n - 1);
          expect(e.right == 0, c == n - 1);
          if (c < n - 1) expect(e.right, -cut.edgesOf(r, c + 1).left, reason: 'right of ($r,$c)');
          if (r < n - 1) expect(e.bottom, -cut.edgesOf(r + 1, c).top, reason: 'below ($r,$c)');
        }
      }
    });
  }

  test('the same seed gives the same cut', () {
    final a = JigsawCut(4, 7), b = JigsawCut(4, 7);
    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        expect(a.edgesOf(r, c), b.edgesOf(r, c));
      }
    }
  });
}
