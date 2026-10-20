import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_theme.dart';

/// The EVERGREEN logo drawn as text, so it stays sharp at any size:
/// yellow "EVER" over white "GREEN", each with a thick green outline.
class EvergreenWordmark extends StatelessWidget {
  const EvergreenWordmark({super.key, this.height = 120});

  /// Total height of the two lines.
  final double height;

  @override
  Widget build(BuildContext context) {
    final big = height * 0.56;
    final small = height * 0.44;
    return SizedBox(
      height: height,
      child: FittedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OutlinedWord('EVER', size: small, fill: AppColors.darkBeige),
            Transform.translate(
              offset: Offset(0, -small * 0.18),
              child: _OutlinedWord('GREEN', size: big, fill: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutlinedWord extends StatelessWidget {
  const _OutlinedWord(this.text, {required this.size, required this.fill});
  final String text;
  final double size;
  final Color fill;

  @override
  Widget build(BuildContext context) {
    final base = TextStyle(
      fontFamily: 'Digital',
      fontSize: size,
      fontWeight: FontWeight.w900,
      letterSpacing: size * 0.04,
      height: 1,
    );
    return Stack(
      children: [
        // Drop shadow + thick dark-green outline.
        Transform.translate(
          offset: Offset(0, size * 0.07),
          child: Text(
            text,
            style: base.copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = size * 0.22
                ..strokeJoin = StrokeJoin.round
                ..color = const Color(0xFF3A8F00),
            ),
          ),
        ),
        // Bright green outline.
        Text(
          text,
          style: base.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = size * 0.2
              ..strokeJoin = StrokeJoin.round
              ..color = AppColors.green,
          ),
        ),
        Text(text, style: base.copyWith(color: fill)),
      ],
    );
  }
}

/// Terry, the planet mascot, drawn in code: crisp at any size, and able to
/// blink. Set [blink] from 0 (eyes open) to 1 (closed).
class TerryPlanet extends StatelessWidget {
  const TerryPlanet({super.key, this.size = 120, this.blink = 0});
  final double size;
  final double blink;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _TerryPainter(blink)),
    );
  }
}

/// [TerryPlanet] that blinks by itself every few seconds.
class BlinkingTerry extends StatefulWidget {
  const BlinkingTerry({super.key, this.size = 120});
  final double size;

  @override
  State<BlinkingTerry> createState() => _BlinkingTerryState();
}

class _BlinkingTerryState extends State<BlinkingTerry> with SingleTickerProviderStateMixin {
  late final _blink = AnimationController(vsync: this, duration: const Duration(milliseconds: 3200))..repeat();

  @override
  void dispose() {
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _blink,
      builder: (context, _) {
        // Eyes close and reopen in the last ~6% of each cycle.
        final t = _blink.value;
        final closed = t < 0.94 ? 0.0 : math.sin((t - 0.94) / 0.06 * math.pi);
        return TerryPlanet(size: widget.size, blink: closed);
      },
    );
  }
}

class _TerryPainter extends CustomPainter {
  _TerryPainter(this.blink);
  final double blink;

  static const _ocean = Color(0xFF2E9BEA);
  static const _oceanLight = Color(0xFF6CC6FF);
  static const _land = Color(0xFF5CC93A);
  static const _landDark = Color(0xFF3E9E24);
  static const _ink = Color(0xFF15304A);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final c = Offset(s / 2, s / 2);
    final r = s * 0.46;
    final globe = Rect.fromCircle(center: c, radius: r);

    // Soft shadow under the planet.
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, s * 0.97), width: s * 0.62, height: s * 0.07),
      Paint()..color = Colors.black.withValues(alpha: 0.15),
    );

    // Ocean with a gentle light from the top-left.
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.35, -0.4),
          radius: 0.95,
          colors: [_oceanLight, _ocean],
        ).createShader(globe),
    );

    // Continents, clipped to the globe.
    canvas.save();
    canvas.clipPath(Path()..addOval(globe));
    final land = Paint()..color = _land;
    final edge = Paint()
      ..color = _landDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.018;
    for (final blob in _continents(s)) {
      canvas.drawPath(blob, land);
      canvas.drawPath(blob, edge);
    }
    canvas.restore();

    // Outline.
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..color = const Color(0xFF1B6FB3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.025,
    );

    // Eyes.
    for (final dx in [-0.16, 0.16]) {
      final eye = Offset(c.dx + dx * s, c.dy - s * 0.02);
      final open = 1 - blink;
      final eyeRect = Rect.fromCenter(center: eye, width: s * 0.17, height: s * 0.21 * math.max(open, 0.08));
      canvas.drawOval(eyeRect, Paint()..color = Colors.white);
      canvas.drawOval(
        eyeRect,
        Paint()
          ..color = _ink
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.016,
      );
      if (open > 0.3) {
        final pupil = Rect.fromCenter(
          center: eye.translate(0, s * 0.02),
          width: s * 0.1,
          height: s * 0.13 * open,
        );
        canvas.drawOval(pupil, Paint()..color = _ink);
        canvas.drawCircle(eye.translate(s * 0.022, -s * 0.012), s * 0.022 * open, Paint()..color = Colors.white);
      }
    }

    // Rosy cheeks.
    final cheek = Paint()..color = const Color(0xFFFF8FA3).withValues(alpha: 0.75);
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - s * 0.27, c.dy + s * 0.12), width: s * 0.1, height: s * 0.06), cheek);
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + s * 0.27, c.dy + s * 0.12), width: s * 0.1, height: s * 0.06), cheek);

    // Smile.
    final smile = Path()
      ..moveTo(c.dx - s * 0.09, c.dy + s * 0.13)
      ..quadraticBezierTo(c.dx, c.dy + s * 0.22, c.dx + s * 0.09, c.dy + s * 0.13);
    canvas.drawPath(
      smile,
      Paint()
        ..color = _ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.028
        ..strokeCap = StrokeCap.round,
    );

    // Shine.
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx - s * 0.2, c.dy - s * 0.27), width: s * 0.16, height: s * 0.08),
      Paint()..color = Colors.white.withValues(alpha: 0.45),
    );
  }

  /// Three friendly land shapes (in units of the planet's size).
  List<Path> _continents(double s) {
    Path blob(List<Offset> pts) {
      final p = Path()..moveTo(pts.first.dx * s, pts.first.dy * s);
      for (int i = 0; i < pts.length; i++) {
        final a = pts[i];
        final b = pts[(i + 1) % pts.length];
        final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
        p.quadraticBezierTo(a.dx * s, a.dy * s, mid.dx * s, mid.dy * s);
      }
      return p..close();
    }

    return [
      blob(const [Offset(0.08, 0.30), Offset(0.30, 0.12), Offset(0.44, 0.18), Offset(0.36, 0.34), Offset(0.18, 0.44)]),
      blob(const [Offset(0.62, 0.10), Offset(0.90, 0.26), Offset(0.88, 0.46), Offset(0.70, 0.38), Offset(0.60, 0.24)]),
      blob(const [Offset(0.20, 0.70), Offset(0.42, 0.62), Offset(0.62, 0.70), Offset(0.74, 0.86), Offset(0.40, 0.96), Offset(0.22, 0.86)]),
    ];
  }

  @override
  bool shouldRepaint(_TerryPainter old) => old.blink != blink;
}
