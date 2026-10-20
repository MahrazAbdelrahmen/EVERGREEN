import 'package:flutter/material.dart';

import 'pressable.dart';

/// The game's standard button: a chunky, rounded "3D" pill that presses down.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.color,
    this.icon,
    this.fontSize = 18,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onTap;
  final Color color;
  final IconData? icon;
  final double fontSize;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final fill = onTap == null ? Colors.blueGrey.shade300 : color;
    final shadow = Color.lerp(fill, Colors.black, 0.3)!;
    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, color: Colors.white, size: fontSize + 4),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontFamily: 'Digital',
              fontWeight: FontWeight.bold,
              shadows: const [Shadow(color: Colors.black26, offset: Offset(0, 1))],
            ),
          ),
        ),
      ],
    );
    return Pressable(
      onTap: onTap,
      semanticLabel: label,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [BoxShadow(color: shadow, offset: const Offset(0, 4))],
        ),
        child: content,
      ),
    );
  }
}

/// Round icon button used for navigation (home, back, settings, close...).
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.color,
    this.size = 44,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  final double size;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = Pressable(
      onTap: onTap,
      semanticLabel: tooltip,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Color.lerp(color, Colors.black, 0.3)!,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.55),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}
