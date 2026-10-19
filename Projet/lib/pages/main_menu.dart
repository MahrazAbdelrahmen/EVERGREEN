import 'package:firebase_auth/firebase_auth.dart';
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
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg-image2.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              height: 330.0,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: SizedBox(
                          //pour creer un alignement des elements
                          height: 60.0,
                          width: 120.0,
                          // color: Colors.amber,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:  [
                                const RoundButton(
                                  href: '/StartPage',
                                  myIcon: Icons.home,
                                  couleur: Color.fromRGBO(255, 210, 23, 1),
                                  shadowColor: Color.fromRGBO(255, 210, 23, 1),
                                ), //le premier
                                isSignedIn ?
                                roundButtonSettingsWhileLogged
                                    : roundButtonSettings
                              ]),
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      //la ligne de widget de type cardBg
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:  [
                        cardBg(
                          title: 'GAMES',
                          coleur1: Color.fromARGB(255, 76, 218, 254),
                          coleur2: Color.fromARGB(255, 76, 218, 254),
                          couleur3: Color.fromARGB(255, 133, 216, 229),
                          href: '/games',
                          Photo: "trash.png",
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        cardBg(
                          title: 'Livre',
                          coleur1: Color.fromARGB(255, 76, 218, 254),
                          coleur2: Color.fromARGB(255, 76, 218, 254),
                          couleur3: Color.fromARGB(255, 133, 216, 229),
                          href: '/conseils',
                          Photo: "trash2.png",
                        ),
                        SizedBox(
                          width: 40,
                        ),

                        CardBgWithWidget(
                          title: 'HISTOIRES',
                          coleur1: Color.fromARGB(255, 76, 218, 254),
                          coleur2: Color.fromARGB(255, 76, 218, 254),
                          couleur3: Color.fromARGB(255, 133, 216, 229),
                          href: levelsStory(nbrKeys: _countNumberOfOnesInAString(playerProgress.gamesData[3].levelsCompleted),),
                          Photo: "trash3.png",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
