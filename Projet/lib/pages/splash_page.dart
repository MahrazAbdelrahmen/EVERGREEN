import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../composents/app_init.dart';
import '../composents/app_theme.dart';
import '../composents/brand.dart';

/// Animated splash: Terry bounces in and blinks, the logo pops, leaves drift
/// down and a recycling sign spins while the app loads. All drawn in code, so
/// everything stays sharp.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  /// Long enough to enjoy the animation, short enough not to bore anyone.
  static const _minimumDuration = Duration(milliseconds: 2400);

  late final _intro = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..forward();
  late final _loop = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    await Future.wait([initializeApp(), Future.delayed(_minimumDuration)]);
    if (mounted) Navigator.of(context).pushReplacementNamed('/StartPage');
  }

  @override
  void dispose() {
    _intro.dispose();
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final terryIn = CurvedAnimation(parent: _intro, curve: const Interval(0, 0.55, curve: Curves.elasticOut));
    final logoIn = CurvedAnimation(parent: _intro, curve: const Interval(0.25, 0.8, curve: Curves.elasticOut));
    final loadingIn = CurvedAnimation(parent: _intro, curve: const Interval(0.7, 1, curve: Curves.easeOut));

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.lightBlue, Color(0xFF9BE7FF), Color(0xFFC8F59A)],
          ),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          final h = constraints.maxHeight;
          final w = constraints.maxWidth;
          return Stack(
            children: [
              // Leaves drifting down across the sky.
              Positioned.fill(child: _FallingLeaves(animation: _loop)),
              // Grassy hill.
              Positioned(
                left: -w * 0.1,
                right: -w * 0.1,
                bottom: -h * 0.35,
                height: h * 0.55,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFF8BDB4F),
                    borderRadius: BorderRadius.vertical(top: Radius.elliptical(900, 220)),
                  ),
                ),
              ),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Terry bounces in, then floats.
                    AnimatedBuilder(
                      animation: Listenable.merge([terryIn, _loop]),
                      builder: (context, child) => Transform.translate(
                        offset: Offset(0, math.sin(_loop.value * 2 * math.pi * 3) * 6),
                        child: Transform.scale(scale: terryIn.value, child: child),
                      ),
                      child: BlinkingTerry(size: h * 0.42),
                    ),
                    SizedBox(width: w * 0.04),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ScaleTransition(scale: logoIn, child: EvergreenWordmark(height: h * 0.36)),
                        SizedBox(height: h * 0.05),
                        FadeTransition(opacity: loadingIn, child: _Loading(animation: _loop)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({required this.animation});
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 6, 18, 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RotationTransition(
            turns: animation.drive(Tween(begin: 0.0, end: 4.0)),
            child: const Icon(Icons.recycling_rounded, color: AppColors.green, size: 28),
          ),
          const SizedBox(width: 8),
          const Text(
            'Chargement…',
            style: TextStyle(fontFamily: 'Digital', fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

/// A dozen leaves falling and swaying, each on its own path.
class _FallingLeaves extends StatelessWidget {
  const _FallingLeaves({required this.animation});
  final Animation<double> animation;

  static final _leaves = List.generate(12, (i) {
    final random = math.Random(i * 7 + 3);
    return (
      x: random.nextDouble(),
      offset: random.nextDouble(),
      size: 16 + random.nextDouble() * 18,
      sway: 0.02 + random.nextDouble() * 0.04,
      speed: 0.6 + random.nextDouble() * 0.8,
      color: [AppColors.green, const Color(0xFF3E9E24), const Color(0xFFA5E35A)][i % 3],
    );
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, _) => Stack(
          children: [
            for (final leaf in _leaves)
              Builder(builder: (context) {
                final t = (animation.value * leaf.speed + leaf.offset) % 1.0;
                final x = (leaf.x + math.sin(t * 2 * math.pi * 2) * leaf.sway) * c.maxWidth;
                final y = (t * 1.2 - 0.1) * c.maxHeight;
                return Positioned(
                  left: x,
                  top: y,
                  child: Transform.rotate(
                    angle: math.sin(t * 2 * math.pi * 3) * 0.8,
                    child: Icon(Icons.eco_rounded, color: leaf.color.withValues(alpha: 0.85), size: leaf.size),
                  ),
                );
              }),
          ],
        ),
      );
    });
  }
}
