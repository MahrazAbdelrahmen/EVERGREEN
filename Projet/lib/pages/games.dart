import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;

import 'package:sorttrash/composents/level_select.dart';
import 'package:sorttrash/composents/ui/player_chip.dart';
import 'package:flutter/material.dart';
import 'package:sorttrash/button.dart';

import '../StartPage/settings.dart';
import '../card_bg.dart';
import '../player_box.dart';

class GamesMenu extends StatefulWidget {
  const GamesMenu({super.key});

  @override
  State<GamesMenu> createState() => _GamesMenuState();
}

class _GamesMenuState extends State<GamesMenu> {
  final roundButtonSettingsWhileLogged =  RoundButtonSettingsWhileLogged(
    href: '/games',myIcon: Icons.settings, value: globalVolumeMusicSettings, volumeSettingsFunction: globalMusicPlayerStartPage.setVolume, volumeSettingsSoundFunction: globalSoundPlayerStartPage.setVolume);
  final roundButtonSettings = RoundButtonSettings(
   href: '/games', myIcon: Icons.settings, value: globalVolumeMusicSettings, volumeSettingsFunction: globalMusicPlayerStartPage.setVolume, volumeSettingsSoundFunction: globalSoundPlayerStartPage.setVolume );
  bool isSignedIn = false;
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    globalMusicPlayerStartPage.resume();
    final user = this.user;
    if (user != null) {
      if (!user.emailVerified) {
        user.delete();
        FirebaseAuth.instance.signOut();
      } else {
        isSignedIn = true;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg-image2.png'),
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
                        const PlayerChip(),
                        const Spacer(),
                        const RoundButton(
                          href: '/',
                          myIcon: Icons.home,
                          couleur: Color.fromRGBO(255, 210, 23, 1),
                          shadowColor: Color.fromRGBO(255, 210, 23, 1),
                        ),
                        const SizedBox(width: 12),
                        const RoundButton(
                          href: '/TrophiesPage',
                          replace: false,
                          myIcon: Icons.star,
                          couleur: Color.fromRGBO(255, 210, 23, 1),
                          shadowColor: Color.fromRGBO(255, 210, 23, 1),
                        ),
                        const SizedBox(width: 12),
                        isSignedIn ? roundButtonSettingsWhileLogged : roundButtonSettings,
                      ],
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(builder: (context, constraints) {
                      const count = 4;
                      const gap = 24.0;
                      final cardWidth = math.min(
                        (constraints.maxWidth - 48 - gap * (count - 1)) / count,
                        constraints.maxHeight * 0.68,
                      );
                      final cardHeight = math.min(cardWidth * 1.4, constraints.maxHeight - 36);
                      return Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            cardBg(
                              title: 'QUIZ',
                              coleur1: const Color.fromARGB(223, 202, 63, 172),
                              coleur2: const Color.fromARGB(255, 240, 71, 206),
                              couleur3: Colors.white,
                              href: '/Nquiz',
                              Photo: "boy.png",
                              width: cardWidth,
                              height: cardHeight,
                              badge: currentPlayer() == null ? null : '${completedLevelCount(GameProgressSlot.quiz, 5)}/5',
                              floatIndex: 0,
                            ),
                            const SizedBox(width: 24),
                            cardBg(
                              title: 'TRI',
                              coleur1: const Color.fromARGB(223, 202, 63, 172),
                              coleur2: const Color.fromARGB(255, 240, 71, 206),
                              couleur3: Colors.white,
                              href: '/Niveaux',
                              Photo: "girl.png",
                              width: cardWidth,
                              height: cardHeight,
                              badge: currentPlayer() == null ? null : '${completedLevelCount(GameProgressSlot.sort, 5)}/5',
                              floatIndex: 1,
                            ),
                            const SizedBox(width: 24),
                            cardBg(
                              title: 'PUZZLE',
                              coleur1: const Color.fromARGB(223, 202, 63, 172),
                              coleur2: const Color.fromARGB(255, 240, 71, 206),
                              couleur3: Colors.white,
                              href: '/Puzzles',
                              Photo: "group.png",
                              width: cardWidth,
                              height: cardHeight,
                              badge: currentPlayer() == null ? null : '${completedLevelCount(GameProgressSlot.puzzle, 5)}/5',
                              floatIndex: 2,
                            ),
                            const SizedBox(width: 24),
                            cardBg(
                              title: 'DEFIS',
                              coleur1: const Color.fromARGB(223, 202, 63, 172),
                              coleur2: const Color.fromARGB(255, 240, 71, 206),
                              couleur3: Colors.white,
                              href: '/defis',
                              Photo: "defis.png",
                              width: cardWidth,
                              height: cardHeight,
                              badge: currentPlayer() == null ? null : '${_challengeKeys()}',
                              badgeAsset: 'assets/images/gold_key.png',
                              floatIndex: 3,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  /// Keys earned in challenges, as shown on the challenges screen.
  int _challengeKeys() {
    final progress = currentPlayer()?.gamesData[GameProgressSlot.challenges].levelsCompleted ?? '';
    return '1'.allMatches(progress).length;
  }
}
