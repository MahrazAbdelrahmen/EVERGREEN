import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;

import 'package:sorttrash/composents/ui/player_chip.dart';
import 'package:flutter/material.dart';
import 'package:sorttrash/card_bg.dart';
import 'package:sorttrash/histoires/levelsStory.dart';
import '../StartPage/settings.dart';
import '../button.dart';
import '../player_box.dart';

class mainMenu extends StatefulWidget {
  const mainMenu({super.key});

  @override
  State<mainMenu> createState() => _mainMenuState();
}

class _mainMenuState extends State<mainMenu> {
  bool isSignedIn = false;
  final roundButtonSettingsWhileLogged =  RoundButtonSettingsWhileLogged(
   href: '/',  myIcon: Icons.settings, value: globalVolumeMusicSettings, volumeSettingsFunction: globalMusicPlayerStartPage.setVolume, volumeSettingsSoundFunction: globalSoundPlayerStartPage.setVolume);
  final roundButtonSettings = RoundButtonSettings(
   href: '/', myIcon: Icons.settings, value: globalVolumeMusicSettings, volumeSettingsFunction: globalMusicPlayerStartPage.setVolume, volumeSettingsSoundFunction: globalSoundPlayerStartPage.setVolume );
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
                          href: '/StartPage',
                          myIcon: Icons.home,
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
                      const count = 3;
                      const gap = 40.0;
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
                              title: 'JEUX',
                              coleur1: const Color.fromARGB(255, 76, 218, 254),
                              coleur2: const Color.fromARGB(255, 76, 218, 254),
                              couleur3: const Color.fromARGB(255, 133, 216, 229),
                              href: '/games',
                              Photo: "trash.png",
                              width: cardWidth,
                              height: cardHeight,
                              floatIndex: 0,
                            ),
                            const SizedBox(width: 40),
                            cardBg(
                              title: 'LIVRE',
                              coleur1: const Color.fromARGB(255, 76, 218, 254),
                              coleur2: const Color.fromARGB(255, 76, 218, 254),
                              couleur3: const Color.fromARGB(255, 133, 216, 229),
                              href: '/conseils',
                              Photo: "trash2.png",
                              width: cardWidth,
                              height: cardHeight,
                              floatIndex: 1,
                            ),
                            const SizedBox(width: 40),
                            CardBgWithWidget(
                              title: 'HISTOIRES',
                              coleur1: const Color.fromARGB(255, 76, 218, 254),
                              coleur2: const Color.fromARGB(255, 76, 218, 254),
                              couleur3: const Color.fromARGB(255, 133, 216, 229),
                              href: levelsStory(nbrKeys: _countNumberOfOnesInAString(playerProgress.gamesData[3].levelsCompleted),),
                              Photo: "trash3.png",
                              width: cardWidth,
                              height: cardHeight,
                              floatIndex: 2,
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

  int _countNumberOfOnesInAString(String input) {
    int count = 0;
    for (int i = 0; i < input.length; i++) {
      if (input[i] == '1') {
        count++;
      }
    }
    return count;
  }
}
