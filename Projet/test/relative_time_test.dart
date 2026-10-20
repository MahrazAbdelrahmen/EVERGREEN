import 'package:flutter_test/flutter_test.dart';
import 'package:sorttrash/StartPage/choose_children/profile_widgets.dart';

void main() {
  final now = DateTime(2026, 10, 19, 22, 0);

  test('relativeTimeFr describes the last game in French', () {
    expect(relativeTimeFr(now, now: now), "Joué à l'instant");
    expect(relativeTimeFr(now.subtract(const Duration(minutes: 5)), now: now), 'Joué il y a 5 min');
    expect(relativeTimeFr(now.subtract(const Duration(hours: 3)), now: now), 'Joué il y a 3 h');
    expect(relativeTimeFr(now.subtract(const Duration(days: 1)), now: now), 'Joué hier');
    expect(relativeTimeFr(now.subtract(const Duration(days: 4)), now: now), 'Joué il y a 4 jours');
    expect(relativeTimeFr(DateTime(2026, 9, 2), now: now), 'Joué le 02/09/2026');
  });
}
