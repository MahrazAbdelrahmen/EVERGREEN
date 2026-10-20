import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../composents/app_theme.dart';
import '../composents/level_select.dart';
import '../composents/navigation.dart';
import '../composents/ui/app_button.dart';
import '../composents/ui/pressable.dart';

/// A trophy is won by finishing a given level of a game.
class Trophy {
  const Trophy({required this.image, required this.level, required this.isBig});

  final String image;

  /// 1-based level to finish. The big trophy needs the last level (all levels).
  final int level;
  final bool isBig;
}

class _GameTrophies {
  const _GameTrophies({
    required this.name,
    required this.slot,
    required this.color,
    required this.trophies,
  });
  final String name;
  final int slot;
  final Color color;
  final List<Trophy> trophies;
}

const _levelsPerGame = 5;

List<Trophy> _trophiesFor(int game) => [
  Trophy(
    image: 'assets/images/trophies/${game * 3 + 1}.png',
    level: 2,
    isBig: false,
  ),
  Trophy(
    image: 'assets/images/trophies/${game * 3 + 2}.png',
    level: 3,
    isBig: false,
  ),
  Trophy(
    image: 'assets/images/trophies/${game * 3 + 3}.png',
    level: _levelsPerGame,
    isBig: true,
  ),
];

final _games = [
  _GameTrophies(
    name: 'Puzzle',
    slot: GameProgressSlot.puzzle,
    color: AppColors.lightPurple,
    trophies: _trophiesFor(0),
  ),
  _GameTrophies(
    name: 'Tri',
    slot: GameProgressSlot.sort,
    color: AppColors.green,
    trophies: _trophiesFor(1),
  ),
  _GameTrophies(
    name: 'Quiz',
    slot: GameProgressSlot.quiz,
    color: AppColors.lightBlue,
    trophies: _trophiesFor(2),
  ),
];

bool _isWon(_GameTrophies game, Trophy trophy) =>
    isLevelCompleted(game.slot, trophy.level - 1);

class TrophiesPage extends StatelessWidget {
  const TrophiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final won = [
      for (final game in _games)
        for (final trophy in game.trophies)
          if (_isWon(game, trophy)) trophy,
    ].length;
    final total = _games.fold<int>(0, (sum, g) => sum + g.trophies.length);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg-image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Row(
                  children: [
                    RoundIconButton(
                      icon: Icons.arrow_back_rounded,
                      color: AppColors.darkBeige,
                      tooltip: 'Retour',
                      onTap: () => goBack(context, '/games'),
                    ),
                    const Spacer(),
                    _TitleBadge(won: won, total: total),
                    const Spacer(),
                    const SizedBox(width: 44),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                  child: Row(
                    children: [
                      for (int i = 0; i < _games.length; i++) ...[
                        if (i > 0) const SizedBox(width: 16),
                        Expanded(child: _GameCard(game: _games[i])),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleBadge extends StatelessWidget {
  const _TitleBadge({required this.won, required this.total});
  final int won;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 4, 8, 4),
      decoration: BoxDecoration(
        color: AppColors.darkBeige,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Color.lerp(AppColors.darkBeige, Colors.black, 0.3)!,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'TROPHÉES',
            style: TextStyle(
              fontFamily: 'Digital',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2))],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.darkBeige,
                  size: 22,
                ),
                const SizedBox(width: 4),
                Text(
                  '$won/$total',
                  style: const TextStyle(
                    fontFamily: 'Digital',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.game});
  final _GameTrophies game;

  @override
  Widget build(BuildContext context) {
    final finished = completedLevelCount(game.slot, _levelsPerGame);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: game.color, width: 4),
        boxShadow: [
          BoxShadow(
            color: Color.lerp(game.color, Colors.black, 0.3)!,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: game.color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            child: Text(
              game.name.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Digital',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2))],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // An ascending staircase: one step per trophy, the big one on top.
                  final h = constraints.maxHeight;
                  final stepHeights = [h * 0.2, h * 0.34, h * 0.48];
                  final column = constraints.maxWidth / 3;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (int i = 0; i < game.trophies.length; i++)
                        Expanded(
                          child: _Step(
                            game: game,
                            trophy: game.trophies[i],
                            stepHeight: stepHeights[i],
                            // Trophies may spill over their step a little, like on a real podium.
                            trophySize: game.trophies[i].isBig
                                ? math.min(h * 0.5, column * 1.4)
                                : math.min(h * 0.42, column * 1.1),
                            isFirst: i == 0,
                            isLast: i == game.trophies.length - 1,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            child: Row(
              children: [
                Text(
                  'Niveaux $finished/$_levelsPerGame',
                  style: const TextStyle(
                    fontFamily: 'Digital',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: finished / _levelsPerGame,
                      minHeight: 10,
                      color: game.color,
                      backgroundColor: game.color.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One stair of the podium with its trophy standing on it.
class _Step extends StatelessWidget {
  const _Step({
    required this.game,
    required this.trophy,
    required this.stepHeight,
    required this.trophySize,
    required this.isFirst,
    required this.isLast,
  });

  final _GameTrophies game;
  final Trophy trophy;
  final double stepHeight;
  final double trophySize;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final won = _isWon(game, trophy);
    final stepColor = Color.lerp(game.color, Colors.white, won ? 0.0 : 0.55)!;
    return Pressable(
      onTap: () {
        HapticFeedback.selectionClick();
        _showTrophy(context, game, trophy, won);
      },
      semanticLabel: _trophyTitle(trophy),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: trophySize,
            width: double.infinity,
            child: OverflowBox(
              maxWidth: trophySize * 1.3,
              maxHeight: trophySize,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  if (won)
                    Container(
                      width: trophySize * 1.25,
                      height: trophySize * 1.25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            game.color.withValues(alpha: 0.45),
                            game.color.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  _TrophyImage(image: trophy.image, won: won, size: trophySize),
                  if (!won)
                    Positioned(
                      bottom: 0,
                      right: trophySize * 0.05,
                      child: const CircleAvatar(
                        radius: 11,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.lock_rounded,
                          size: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            height: stepHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: stepColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
                bottomLeft: Radius.circular(isFirst ? 10 : 0),
                bottomRight: Radius.circular(isLast ? 10 : 0),
              ),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Text(
                trophy.isBig
                    ? '$_levelsPerGame/$_levelsPerGame'
                    : 'Niv. ${trophy.level}',
                style: TextStyle(
                  fontFamily: 'Digital',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: won ? Colors.white : Colors.black45,
                  shadows: won
                      ? const [
                          Shadow(color: Colors.black26, offset: Offset(0, 1)),
                        ]
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Trophy picture: in colour with a gentle pop when won, greyed otherwise.
class _TrophyImage extends StatelessWidget {
  const _TrophyImage({required this.image, required this.won, this.size});
  final String image;
  final bool won;
  final double? size;

  // Luminance-only matrix: unlike a blend mode it leaves transparent pixels alone.
  static const _greyscale = ColorFilter.matrix(<double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    0.5,
    0,
  ]);

  @override
  Widget build(BuildContext context) {
    final picture = Image.asset(
      image,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
    if (!won) return ColorFiltered(colorFilter: _greyscale, child: picture);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.6, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.elasticOut,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: picture,
    );
  }
}

String _trophyTitle(Trophy trophy) =>
    trophy.isBig ? 'Grand trophée' : 'Médaille du niveau ${trophy.level}';

void _showTrophy(
  BuildContext context,
  _GameTrophies game,
  Trophy trophy,
  bool won,
) {
  final goal = trophy.isBig
      ? 'Termine les $_levelsPerGame niveaux du ${game.name} pour le gagner.'
      : 'Termine le niveau ${trophy.level} du ${game.name} pour la gagner.';
  showDialog(
    context: context,
    builder: (dialogContext) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              _TrophyImage(image: trophy.image, won: won, size: 96),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _trophyTitle(trophy),
                      style: const TextStyle(
                        fontFamily: 'Digital',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      game.name,
                      style: TextStyle(
                        fontFamily: 'Digital',
                        fontSize: 16,
                        color: game.color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      won ? '🥳 Gagné ! Bravo !' : goal,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 14),
                    AppButton(
                      label: 'OK',
                      icon: Icons.check_rounded,
                      color: AppColors.green,
                      onTap: () => Navigator.pop(dialogContext),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Trophies won by the child currently playing, out of all trophies.
({int won, int total}) trophyCount() {
  var won = 0, total = 0;
  for (final game in _games) {
    for (final trophy in game.trophies) {
      total++;
      if (_isWon(game, trophy)) won++;
    }
  }
  return (won: won, total: total);
}
