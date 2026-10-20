import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sorttrash/StartPage/settings.dart';
import 'package:sorttrash/composents/app_theme.dart';
import 'package:sorttrash/composents/brand.dart';
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
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg-image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.8, end: 1),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.elasticOut,
                    builder: (context, scale, child) =>
                        Transform.scale(scale: scale, child: child),
                    child: EvergreenWordmark(height: 0.4 * height),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AnonButton(
                        text: 'Jouer',
                        icon: Icons.play_arrow_rounded,
                        href: '/ChildSelector',
                        color: AppColors.green,
                      ),
                      const SizedBox(width: 20),
                      isSignedIn
                          ? const AnonButton(
                              href: '/ProfilePage',
                              icon: Icons.person_rounded,
                              color: AppColors.darkBeige,
                              text: 'Profil')
                          : const AnonButton(
                              href: '/LoginPage',
                              icon: Icons.login_rounded,
                              color: AppColors.darkBeige,
                              text: 'Se connecter'),
                    ],
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
