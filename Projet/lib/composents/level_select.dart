import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../BackEnd/PlayerProgress/player.dart';
import '../button.dart';
import '../player_box.dart';
import 'app_theme.dart';
import 'floating_snackbar.dart';
import 'ui/pressable.dart';

/// Index of each game's progress string in [PlayerProgress.gamesData].
abstract final class GameProgressSlot {
  static const puzzle = 0;
  static const sort = 1;
  static const quiz = 2;
  static const challenges = 3;
}

/// The child currently playing, or null when no profile is selected.
PlayerProgress? currentPlayer() {
  try {
    if (currentProfileIndex == 1 && globalChildKey != -1) {
      return offlineProgress.returnParent().children[globalChildKey];
    }
    if (onlineGlobalChildKey != -1) {
      return onlineProgress.returnParent().children[onlineGlobalChildKey];
    }
  } catch (e) {
    debugPrint('$e');
  }
  return null;
}

/// Games mark level `i` as finished by writing '1' at position `i + 1`.
bool isLevelCompleted(int slot, int index) {
  final progress = currentPlayer()?.gamesData[slot].levelsCompleted;
  return progress != null && index + 1 < progress.length && progress[index + 1] == '1';
}

/// How many of a game's first [levelCount] levels the current child finished.
int completedLevelCount(int slot, int levelCount) {
  var count = 0;
  for (int i = 0; i < levelCount; i++) {
    if (isLevelCompleted(slot, i)) count++;
  }
  return count;
}

/// The classic level-selection screen: happy bags for open levels, sad bags
/// for locked ones, joined by a dotted trail, alternating high and low.
class ClassicLevelSelect extends StatelessWidget {
  const ClassicLevelSelect({
    super.key,
    required this.title,
    required this.levelCount,
    required this.isLocked,
    required this.isCompleted,
    required this.onOpen,
  });

  final String title;
  final int levelCount;
  final bool Function(int index) isLocked;
  final bool Function(int index) isCompleted;
  final void Function(int index) onOpen;

  int get _nextLevel {
    for (int i = 0; i < levelCount; i++) {
      if (!isLocked(i) && !isCompleted(i)) return i;
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    final done = [for (int i = 0; i < levelCount; i++) isCompleted(i)].where((c) => c).length;
    final next = _nextLevel;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/bg-image.png'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Row(
                  children: [
                    const RoundButton(
                      href: '/games',
                      myIcon: Icons.arrow_back_rounded,
                      couleur: AppColors.darkBeige,
                      shadowColor: AppColors.darkBeige,
                    ),
                    const Spacer(),
                    _TitleBadge(title: title, done: done, total: levelCount),
                    const Spacer(),
                    const RoundButton(
                      href: '/',
                      myIcon: Icons.home_rounded,
                      couleur: AppColors.darkBeige,
                      shadowColor: AppColors.darkBeige,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  const sidePadding = 24.0;
                  const minGap = 30.0;
                  final height = constraints.maxHeight;
                  final usable = constraints.maxWidth - 2 * sidePadding;
                  // As big as the height allows, shrunk so every level fits on screen.
                  final tile = math.min(
                    math.min(140.0, height * 0.42),
                    (usable - minGap * (levelCount - 1)) / levelCount,
                  );
                  final gap = levelCount > 1
                      ? (usable - tile * levelCount) / (levelCount - 1)
                      : 0.0;
                  final tileHeight = tile + 30;
                  final tops = [
                    for (int i = 0; i < levelCount; i++)
                      (height * (i.isEven ? 0.36 : 0.68) - tileHeight / 2)
                          .clamp(26.0, height - tileHeight),
                  ];
                  final lefts = [for (int i = 0; i < levelCount; i++) sidePadding + i * (tile + gap)];
                  // The trail joins the middle of each bag.
                  final anchors = [
                    for (int i = 0; i < levelCount; i++)
                      Offset(lefts[i] + tile / 2, tops[i] + tile * 0.55),
                  ];
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _TrailPainter(
                            anchors: anchors,
                            completed: [for (int i = 0; i < levelCount; i++) isCompleted(i)],
                            gapBetweenBags: tile * 0.42,
                          ),
                        ),
                      ),
                      for (int i = 0; i < levelCount; i++)
                        Positioned(
                          left: lefts[i],
                          top: tops[i],
                          child: ClassicLevelTile(
                            index: i,
                            size: tile,
                            locked: isLocked(i),
                            completed: isCompleted(i),
                            isNext: i == next,
                            onTap: () => onOpen(i),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleBadge extends StatelessWidget {
  const _TitleBadge({required this.title, required this.done, required this.total});
  final String title;
  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 4, 8, 4),
      decoration: BoxDecoration(
        color: AppColors.lightPurple,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [BoxShadow(color: Color.lerp(AppColors.lightPurple, Colors.black, 0.3)!, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
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
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, color: AppColors.darkBeige, size: 22),
                const SizedBox(width: 4),
                Text('$done/$total',
                    style: const TextStyle(fontFamily: 'Digital', fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One level: the happy bag (open) or sad bag (locked) from the classic design.
/// The next level to play bounces with a "Jouer !" bubble; finished levels
/// wear a gold star; locked ones wobble when tapped.
class ClassicLevelTile extends StatefulWidget {
  const ClassicLevelTile({
    super.key,
    required this.index,
    required this.size,
    required this.locked,
    required this.completed,
    required this.isNext,
    required this.onTap,
  });

  final int index;
  final double size;
  final bool locked;
  final bool completed;
  final bool isNext;
  final VoidCallback onTap;

  @override
  State<ClassicLevelTile> createState() => _ClassicLevelTileState();
}

class _ClassicLevelTileState extends State<ClassicLevelTile> with TickerProviderStateMixin {
  late final _bounce = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
  late final _wobble = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));

  @override
  void initState() {
    super.initState();
    if (widget.isNext) _bounce.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(ClassicLevelTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isNext && !_bounce.isAnimating) {
      _bounce.repeat(reverse: true);
    } else if (!widget.isNext && _bounce.isAnimating) {
      _bounce
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _bounce.dispose();
    _wobble.dispose();
    super.dispose();
  }

  void _tap() {
    if (widget.locked) {
      HapticFeedback.heavyImpact();
      _wobble.forward(from: 0);
      FloatingSnackBar(
        message: '🔒 Termine le niveau ${widget.index} pour débloquer celui-ci !',
        context: context,
        duration: const Duration(milliseconds: 1800),
        backgroundColor: Colors.deepPurple,
      );
    } else {
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final label = widget.locked
        ? RectangleButton(
            couleur1: const Color.fromARGB(255, 170, 130, 29),
            couleur2: const Color.fromARGB(255, 141, 104, 12),
            text: 'Niveau ${widget.index + 1}',
          )
        : RectangleButton(
            couleur1: const Color.fromARGB(255, 255, 209, 23),
            couleur2: const Color.fromARGB(255, 255, 209, 23),
            text: 'Niveau ${widget.index + 1}',
          );

    return Pressable(
      onTap: _tap,
      semanticLabel: 'Niveau ${widget.index + 1}${widget.locked ? ', verrouillé' : ''}',
      child: AnimatedBuilder(
        animation: Listenable.merge([_bounce, _wobble]),
        builder: (context, child) {
          final hop = -10 * Curves.easeInOut.transform(_bounce.value);
          final wobble = math.sin(_wobble.value * math.pi * 5) * 0.12 * (1 - _wobble.value);
          return Transform.translate(
            offset: Offset(0, hop),
            child: Transform.rotate(angle: wobble, child: child),
          );
        },
        child: SizedBox(
          width: size,
          height: size + 30,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 0,
                child: Image.asset(
                  widget.locked ? 'assets/images/close-level.png' : 'assets/images/opened-level.png',
                  width: size,
                  height: size,
                ),
              ),
              // "Niveau N" plaque from the classic design.
              Positioned(top: size * 0.78, child: label),
              if (widget.completed)
                Positioned(
                  top: -4,
                  right: size * 0.08,
                  child: const _GoldStar(),
                ),
              if (widget.isNext)
                const Positioned(top: -22, child: _PlayBubble()),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoldStar extends StatelessWidget {
  const _GoldStar();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, t, child) => Transform.scale(scale: t, child: child),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.star_rounded, size: 46, color: Colors.white),
          Icon(Icons.star_rounded, size: 38, color: AppColors.darkBeige),
        ],
      ),
    );
  }
}

class _PlayBubble extends StatelessWidget {
  const _PlayBubble();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 2))],
      ),
      child: const Text(
        'Jouer !',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Digital',
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

/// Footpath-style trail between levels: white dashes with a dark outline so it
/// reads on any background, an arrowhead pointing to the next level, and a
/// solid gold path for the stretch the child has already completed.
class _TrailPainter extends CustomPainter {
  _TrailPainter({required this.anchors, required this.completed, required this.gapBetweenBags});

  final List<Offset> anchors;
  final List<bool> completed;

  /// How far from each bag's centre the trail starts and stops.
  final double gapBetweenBags;

  static const _outline = Color(0xFF6D4C1F);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < anchors.length - 1; i++) {
      final full = _segment(anchors[i], anchors[i + 1]);
      final metric = full.computeMetrics().first;
      final from = math.min(gapBetweenBags, metric.length * 0.3);
      final to = math.max(metric.length - gapBetweenBags, metric.length * 0.7);
      final done = completed[i];

      if (done) {
        final path = metric.extractPath(from, to);
        canvas.drawPath(path, _stroke(_outline, 13));
        canvas.drawPath(path, _stroke(AppColors.darkBeige, 8));
      } else {
        const dash = 14.0, space = 10.0;
        for (double d = from; d < to; d += dash + space) {
          final piece = metric.extractPath(d, math.min(d + dash, to));
          canvas.drawPath(piece, _stroke(_outline, 12));
          canvas.drawPath(piece, _stroke(Colors.white, 7));
        }
      }

      final tangent = metric.getTangentForOffset(to);
      if (tangent != null) {
        _arrowHead(canvas, tangent.position, tangent.vector,
            done ? AppColors.darkBeige : Colors.white);
      }
    }
  }

  Path _segment(Offset a, Offset b) {
    final midX = (a.dx + b.dx) / 2;
    return Path()
      ..moveTo(a.dx, a.dy)
      ..cubicTo(midX, a.dy, midX, b.dy, b.dx, b.dy);
  }

  Paint _stroke(Color color, double width) => Paint()
    ..color = color
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  void _arrowHead(Canvas canvas, Offset tip, Offset direction, Color fill) {
    final dir = direction / direction.distance;
    final normal = Offset(-dir.dy, dir.dx);
    const length = 20.0, halfWidth = 13.0;
    final base = tip - dir * length;
    final head = Path()
      ..moveTo(tip.dx + dir.dx * 4, tip.dy + dir.dy * 4)
      ..lineTo(base.dx + normal.dx * halfWidth, base.dy + normal.dy * halfWidth)
      ..lineTo(base.dx - normal.dx * halfWidth, base.dy - normal.dy * halfWidth)
      ..close();
    canvas.drawPath(
        head,
        Paint()
          ..color = _outline
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..strokeJoin = StrokeJoin.round);
    canvas.drawPath(head, Paint()..color = fill);
  }

  @override
  bool shouldRepaint(_TrailPainter old) =>
      old.gapBetweenBags != gapBetweenBags ||
      old.anchors.length != anchors.length ||
      !_same(old.anchors, anchors) ||
      !_same(old.completed, completed);

  static bool _same<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
