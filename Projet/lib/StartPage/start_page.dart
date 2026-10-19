import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sorttrash/StartPage/settings.dart';
import 'package:sorttrash/StartPage/start_page_button.dart';
import 'package:sorttrash/player_box.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isSignedIn = false;
  final roundButtonSettingsWhileLogged = RoundButtonSettingsWhileLogged(
      href: '/StartPage',
      myIcon: Icons.settings,
      value: globalVolumeMusicSettings,
      volumeSettingsFunction: globalMusicPlayerStartPage.setVolume,
      volumeSettingsSoundFunction: globalSoundPlayerStartPage.setVolume);
  final roundButtonSettings = RoundButtonSettings(
    href: '/StartPage',
    myIcon: Icons.settings,
    value: globalVolumeMusicSettings,
    volumeSettingsFunction: globalMusicPlayerStartPage.setVolume,
    volumeSettingsSoundFunction: globalSoundPlayerStartPage.setVolume,
  );
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  void dispose() {
    globalMusicPlayerStartPage.stop();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    globalMusicPlayerStartPage.setReleaseMode(ReleaseMode.loop);
    globalMusicPlayerStartPage.play(AssetSource("music/gamebackground.mp3"),
        volume: globalVolumeMusicSettings);
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
              image: AssetImage('assets/images/bg-image.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              width: 400,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.transparent,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 150,
                    width: 250,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(

                    padding: const EdgeInsets.only(left: 65.0),
                    child: Center(
                      child: Row(
                        children: [
                          const AnonButton(
                            text: 'Jouer',
                            href: '/ChildSelector',
                            color: Color.fromRGBO(255, 210, 23, 1),
                          ),
                          const SizedBox(width: 20,),
                          isSignedIn
                              ? AnonButton(href: '/ProfilePage' , color: Color.fromRGBO(255, 210, 23, 1),text: 'Profile',)
                              : AnonButton(href: '/LoginPage' , color: Color.fromRGBO(255, 210, 23, 1),text: 'Connecter',),
                        ],
                      ),
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
}

