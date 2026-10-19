import 'package:firebase_auth/firebase_auth.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sorttrash/BackEnd/ChallengesLocalDataBase/local_challenges.dart';
import 'package:sorttrash/button.dart';
import 'package:sorttrash/defis/show_challenge_screen.dart';
import '../BackEnd/PlayerProgress/player.dart';
import '../StartPage/settings.dart';
import '../player_box.dart';
import 'challenge_mangement.dart';
import 'key_container.dart';

int kcpt = 0;

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
  final roundButtonSettingsWhileLogged = RoundButtonSettingsWhileLogged(
      href: '/defis',
      myIcon: Icons.settings,
      value: globalVolumeMusicSettings,
      volumeSettingsFunction: globalMusicPlayerStartPage.setVolume,
      volumeSettingsSoundFunction: globalSoundPlayerStartPage.setVolume);
  final roundButtonSettings = RoundButtonSettings(
      href: '/defis',
      myIcon: Icons.settings,
      value: globalVolumeMusicSettings,
      volumeSettingsFunction: globalMusicPlayerStartPage.setVolume,
      volumeSettingsSoundFunction: globalSoundPlayerStartPage.setVolume);
  bool isSignedIn = false;
  final ChallengeManagement challengeManagement = ChallengeManagement();
  final User? user = FirebaseAuth.instance.currentUser;
  late PlayerProgress playerProgress = currentProfileIndex == 1
      ? offlineProgress.returnParent().children[globalChildKey]
      : onlineProgress.returnParent().children[onlineGlobalChildKey];
  @override
  void initState() {
    if (playerProgress.lastChallengeDate != null && _isExactlyOneDayApart(DateTime.now(),playerProgress.lastChallengeDate!) ){
      playerProgress.lastChallengeDate = DateTime.now();
     _updateUserData();
    }
    if (user != null) {
      if (!user!.emailVerified) {
        setState(() {
          user!.delete();
          FirebaseAuth.instance.signOut();
        });
      } else {
        setState(() {
          isSignedIn = true;
        });
      }
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.height,
        height: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg-image2.png'),
              fit: BoxFit.fill),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 80,
                  height: 32,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 22,
                        width: 30,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/gold_key.png'))),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${_countNumberOfOnesInAString(playerProgress.gamesData[3].levelsCompleted)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontFamily: 'Digitalt',
                            color: sm1),
                      )
                    ],
                  ),
                ),

                SizedBox(width: MediaQuery.of(context).size.width - 250,),
                const RoundButton(href: '/', myIcon: Icons.home_filled, couleur: Colors.greenAccent, shadowColor: Colors.greenAccent,),
                const SizedBox(width: 10,),
                const RoundButton(href: '/TrophiesPage', myIcon:  Icons.star, couleur: Color.fromRGBO(255, 210, 23, 1), shadowColor:  Color.fromRGBO(255, 210, 23, 1),),
                const SizedBox(width: 10,),
                isSignedIn ?
                roundButtonSettingsWhileLogged
                    : roundButtonSettings,
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: SizedBox(
                width: 8 * 0.12 * MediaQuery.of(context).size.width,
                child: AspectRatio(
                  aspectRatio: 2.7,
                  child: GridView.count(
                    crossAxisCount: 8,
                    children: [
                      for (int i = 0; i < 24; i++)
                        InkWell(
                            onTap: (){
                              if(!challengeManagement.challengesList[i].state ){
                                 audioPlayer.play(AssetSource("music/D${i + 1}.m4a"));
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) =>  ShowChallenge(challengeInformation: globalchallengesInformationsList[i]) )
                                );
                              }
                            },
                            child: challengeManagement.challengesList[i])
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateUserData(){
    setState(() {
        String newLevelsCompleted = playerProgress
            .gamesData[3].levelsCompleted
            .replaceFirst('0', '1');
        playerProgress.gamesData[3].levelsCompleted = newLevelsCompleted;
    });
    try {
      if (currentProfileIndex == 1) {
        offlineProgress.setChild(globalChildKey, playerProgress);
        if (parentBox.isEmpty) {
          parentBox.add(offlineProgress);
        } else {
          parentBox.putAt(0, offlineProgress.returnParent());
        }
      } else {
        onlineProgress.setChild(onlineGlobalChildKey, playerProgress);
        onlineParentBox.put(user!.uid, onlineProgress.returnParent());
        onlineProgress.returnParent().updateData(onlineProgress.getUID());
      }
    } catch (e) {
      debugPrint('$e');
    }
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
  bool _isExactlyOneDayApart(DateTime date1, DateTime date2) {
    final difference = date2.difference(date1);
    return difference.inDays.abs() >= 1;
  }
}
