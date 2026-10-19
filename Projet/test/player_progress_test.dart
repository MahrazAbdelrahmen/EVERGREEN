import 'package:flutter_test/flutter_test.dart';
import 'package:sorttrash/BackEnd/DataBaseService/local_data_base_service.dart';
import 'package:sorttrash/BackEnd/PlayerProgress/PlayerUtil/new_player.dart';
import 'package:sorttrash/BackEnd/PlayerProgress/PlayerUtil/player_stats.dart';
import 'package:sorttrash/BackEnd/PlayerProgress/player.dart';

void main() {
  PlayerProgress samplePlayer({DateTime? lastChallengeDate}) => PlayerProgress(
        120,
        [
          LevelsCompleted(1, '1100'),
          LevelsCompleted(2, '1000'),
          LevelsCompleted(3, '1110'),
          LevelsCompleted(4, '1000'),
        ],
        DateTime.utc(2024, 1, 2),
        0,
        'Lina',
        'Lina-1234abcd',
        'assets/profiles/3.png',
        lastChallengeDate,
      );

  group('PlayerProgress JSON', () {
    test('round-trips all fields', () {
      final original = samplePlayer(lastChallengeDate: DateTime.utc(2024, 1, 1));
      final copy = PlayerProgress.fromJson(original.toJson());

      expect(copy.score, 120);
      expect(copy.childsName, 'Lina');
      expect(copy.avatarProfileName, 'assets/profiles/3.png');
      expect(copy.lastTimeToJoin, original.lastTimeToJoin);
      expect(copy.lastChallengeDate, original.lastChallengeDate);
      expect(copy.gamesData.map((g) => g.levelsCompleted),
          ['1100', '1000', '1110', '1000']);
    });

    test('accepts a missing lastChallengeDate', () {
      final copy = PlayerProgress.fromJson(samplePlayer().toJson());
      expect(copy.lastChallengeDate, isNull);
    });

    test('Parent serializes children as a List for Firestore', () {
      final parent = Parent([samplePlayer()], 1, 'uuid');
      final json = {
        'children': parent.children.map((e) => e.toJson()).toList(),
        'childrenNumber': parent.numberOfChildren,
        'parentUUID': parent.parentUUID,
      };
      final copy = Parent.fromJson(json);
      expect(copy.children.single.childsName, 'Lina');
      expect(copy.numberOfChildren, 1);
    });
  });

  test('new players do not share progress with the template', () {
    final player = NewPlayerUtil.returnNewPlayer();
    player.gamesData[0].levelsCompleted = '1111';

    expect(DataBaseService.newGameDataPlayer[0].levelsCompleted,
        startsWith('10000'));
    expect(NewPlayerUtil.returnNewPlayer().gamesData[0].levelsCompleted,
        startsWith('10000'));
  });

  test('PlayerStatsUtil counts completed levels', () {
    final stats = PlayerStatsUtil(playerProgress: samplePlayer());
    expect(stats.countNumberOfOnesInAString(2), 3);
    expect(stats.countNumberOfOnesInAString(9), 0);
    expect(stats.calculateTotal(), 2 + 1 + 3);
  });
}
