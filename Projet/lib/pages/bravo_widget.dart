import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:sorttrash/StartPage/settings.dart';

import '../composents/app_theme.dart';
import '../composents/ui/app_button.dart';
import '../player_box.dart';

/// End-of-level screen: confetti, 1–3 stars and the points won this round.
class BravoPage extends StatefulWidget {
  const BravoPage({super.key, required this.score, this.stars = 3});
  final int score;
  final int stars;
  @override
  State<BravoPage> createState() => _BravoPageState();
}

class _BravoPageState extends State<BravoPage> {
  final _confetti = ConfettiController(duration: const Duration(seconds: 2));

  @override
  void initState() {
    super.initState();
    globalMusicPlayerStartPage.stop();
    globalSoundPlayerStartPage.play(AssetSource("music/finishedgame.mp3"),
        volume: globalVolumeSoundSettings);
    _confetti.play();
  }

  @override
  void dispose() {
    _confetti.dispose();
    globalSoundPlayerStartPage.stop();
    super.dispose();
  }

  void _leave(VoidCallback navigate) {
    globalSoundPlayerStartPage.stop();
    globalMusicPlayerStartPage.resume();
    navigate();
  }

  String get _message => switch (widget.stars) {
        3 => 'Parfait !',
        2 => 'Bravo !',
        _ => 'Bien joué !',
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg-image2.png'), fit: BoxFit.cover),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Center(
              child: SingleChildScrollView(
                child: Container(
                  width: 360,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(color: Colors.black38, offset: Offset(0, 8)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _message,
                        style: const TextStyle(
                          fontFamily: 'Digital',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < 3; i++) _Star(index: i, filled: i < widget.stars),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(194, 253, 255, 1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset("assets/images/coin_img.png", height: 36),
                            const SizedBox(width: 12),
                            TweenAnimationBuilder<int>(
                              tween: IntTween(begin: 0, end: widget.score),
                              duration: const Duration(milliseconds: 900),
                              builder: (context, value, _) => Text(
                                '+$value',
                                style: const TextStyle(
                                  color: Color.fromRGBO(34, 138, 237, 1),
                                  fontSize: 24,
                                  fontFamily: 'Digital',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppButton(
                            label: 'Niveaux',
                            icon: Icons.grid_view_rounded,
                            color: AppColors.lightBlue,
                            onTap: () => _leave(() => Navigator.pop(context)),
                          ),
                          const SizedBox(width: 12),
                          AppButton(
                            label: 'Menu',
                            icon: Icons.home_rounded,
                            color: AppColors.darkBeige,
                            onTap: () => _leave(() => Navigator.pushNamedAndRemoveUntil(
                                context, '/', (route) => false)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 30,
              gravity: 0.25,
              colors: const [
                AppColors.lightBlue,
                AppColors.darkBeige,
                AppColors.green,
                AppColors.lightPurple,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Star extends StatelessWidget {
  const _Star({required this.index, required this.filled});
  final int index;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + 200 * index),
      curve: Curves.elasticOut,
      builder: (context, t, child) => Transform.rotate(
        angle: (1 - t) * math.pi / 4,
        child: Transform.scale(scale: t, child: child),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: index == 1 ? 12 : 0),
        child: Icon(
          filled ? Icons.star_rounded : Icons.star_outline_rounded,
          size: index == 1 ? 64 : 52,
          color: filled ? AppColors.darkBeige : Colors.black26,
        ),
      ),
    );
  }
}
