import 'package:flutter_test/flutter_test.dart';
import 'package:sorttrash/conseils/conseils.dart';

void main() {
  test('every page of the book has an existing audio file name pattern', () {
    final pages = Conseils().cons;
    expect(pages.where((p) => p.SoundPath.contains('CONSEIL09')), isEmpty);
    expect(pages.map((p) => p.titre).where((t) => t.startsWith('CONSEIL')).toSet().length,
        pages.where((p) => p.titre.startsWith('CONSEIL')).length,
        reason: 'tip numbers are unique');
  });
}
