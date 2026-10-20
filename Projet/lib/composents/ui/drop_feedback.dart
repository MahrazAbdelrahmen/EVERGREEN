import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum DropResult { none, correct, wrong }

/// Plays a short animation on [child] each time [tick] changes:
/// a bounce with a green glow for [DropResult.correct], a shake with a red
/// glow for [DropResult.wrong]. While [hovering] the child is slightly enlarged
/// so the player sees where the item will land.
class DropFeedback extends StatelessWidget {
  const DropFeedback({
    super.key,
    required this.result,
    required this.tick,
    required this.child,
    this.hovering = false,
    this.borderRadius = 16,
  });

  final DropResult result;
  final int tick;
  final bool hovering;
  final double borderRadius;
  final Widget child;

  /// Haptics that match [DropFeedback]'s visuals.
  static void haptic(DropResult result) {
    switch (result) {
      case DropResult.correct:
        HapticFeedback.lightImpact();
      case DropResult.wrong:
        HapticFeedback.heavyImpact();
      case DropResult.none:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hovered = AnimatedScale(
      scale: hovering ? 1.08 : 1,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: child,
    );
    if (result == DropResult.none) return hovered;

    final glowColor =
        result == DropResult.correct ? Colors.greenAccent : Colors.redAccent;
    return TweenAnimationBuilder<double>(
      key: ValueKey(tick),
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, t, child) {
        final fade = 1 - t;
        Widget animated = DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: glowColor.withValues(alpha: 0.8 * fade),
                blurRadius: 24 * fade,
                spreadRadius: 4 * fade,
              ),
            ],
          ),
          child: child,
        );
        if (result == DropResult.correct) {
          animated = Transform.scale(
            scale: 1 + 0.15 * math.sin(math.pi * t),
            child: animated,
          );
        } else {
          animated = Transform.translate(
            offset: Offset(math.sin(t * math.pi * 6) * 10 * fade, 0),
            child: animated,
          );
        }
        return animated;
      },
      child: hovered,
    );
  }
}
