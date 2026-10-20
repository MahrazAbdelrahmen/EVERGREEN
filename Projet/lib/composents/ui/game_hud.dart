import 'package:flutter/material.dart';

import '../app_theme.dart';

/// Top bar shown during a game: progress through the level, the points earned
/// so far, an optional timer and trailing actions (usually the pause button).
class GameHud extends StatelessWidget {
  const GameHud({
    super.key,
    required this.done,
    required this.total,
    required this.score,
    this.secondsLeft,
    this.trailing,
  });

  final int done;
  final int total;
  final int score;
  final int? secondsLeft;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : done / total;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
      child: Row(
        children: [
          Expanded(
            child: _Pill(
              child: Row(
                children: [
                  const Icon(Icons.flag_rounded, color: AppColors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(end: progress),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        builder: (context, value, _) => LinearProgressIndicator(
                          value: value,
                          minHeight: 12,
                          color: AppColors.green,
                          backgroundColor: Colors.black12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('$done / $total', style: _labelStyle),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          _Pill(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/coin_img.png', height: 22),
                const SizedBox(width: 6),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Text('$score', key: ValueKey(score), style: _labelStyle),
                ),
              ],
            ),
          ),
          if (secondsLeft != null) ...[
            const SizedBox(width: 12),
            _Pill(
              color: secondsLeft! <= 10 ? Colors.red.shade50 : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer_rounded,
                      size: 20,
                      color: secondsLeft! <= 10 ? Colors.redAccent : AppColors.lightBlue),
                  const SizedBox(width: 6),
                  Text('${secondsLeft}s',
                      style: _labelStyle.copyWith(
                          color: secondsLeft! <= 10 ? Colors.redAccent : null)),
                ],
              ),
            ),
          ],
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }

  static const _labelStyle = TextStyle(
    fontFamily: 'Digital',
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.black87,
  );
}

class _Pill extends StatelessWidget {
  const _Pill({required this.child, this.color});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: color ?? Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}
