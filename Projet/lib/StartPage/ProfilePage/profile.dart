import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sorttrash/button.dart';
import 'package:sorttrash/player_box.dart';

import '../../BackEnd/PlayerProgress/PlayerUtil/new_player.dart';
import '../../BackEnd/PlayerProgress/PlayerUtil/player_stats.dart';
import '../../BackEnd/PlayerProgress/player.dart';
import 'no_player_page.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final User? user = FirebaseAuth.instance.currentUser;
  late final PlayerProgress playerProgress =
      currentProfileIndex == 1 && globalChildKey != -1
          ? offlineProgress.returnParent().children[globalChildKey]
          : (onlineGlobalChildKey != -1
              ? onlineProgress.returnParent().children[onlineGlobalChildKey]
              : NewPlayerUtil.returnNewPlayer());
  late final PlayerStatsUtil playerStatsUtil =
      PlayerStatsUtil(playerProgress: playerProgress);
  @override
  Widget build(BuildContext context) {
    return globalChildKey * onlineGlobalChildKey > 0
        ? NoPlayerSelectedPage()
        : Scaffold(
            body: Row(
              children: [
                Container(
                  height: double.infinity,
                  width: 0.26 * MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      border: Border.all(width: 2, color: Colors.indigo),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Profile",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Digital',
                              fontSize: 24,
                              decoration: TextDecoration.none),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            height: 0.25 * MediaQuery.of(context).size.height,
                            width: 0.25 * MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    playerProgress.avatarProfileName
                                                ?.startsWith('assets/') ==
                                            true
                                        ? playerProgress.avatarProfileName!
                                        : 'assets/profiles/0.png'),
                              ),
                              borderRadius: BorderRadius.circular(100),
                            )),
                        SizedBox(
                          height: 0.06 * MediaQuery.of(context).size.height,
                        ),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              "Score : ${playerProgress.score} ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Digital',
                                  fontSize: 18,
                                  decoration: TextDecoration.none),
                            )),
                        SizedBox(
                          height: 0.06 * MediaQuery.of(context).size.height,
                        ),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              "Nom : ${playerProgress.childsName} ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Digital',
                                  fontSize: 18,
                                  decoration: TextDecoration.none),
                            )),

                        user != null ? ElevatedButton(
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              await FirebaseAuth.instance.signOut();
                              onlineGlobalChildKey = -1;
                              playersOnline = [];
                              if (currentProfileIndex != 1) {
                                currentProfileIndex = 1;
                              }
                              navigator.pushNamedAndRemoveUntil(
                                  '/StartPage', (route) => false);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(
                                    width: 2, color: Colors.black),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, top: 8, bottom: 10)),
                            child: Center(
                              child: Text(
                                "Déconnexion",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 13,
                                  fontFamily: 'Digital',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )) :  SizedBox( height: 0.05*MediaQuery.of(context).size.width,),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: RoundButton(
                                href: "/",
                                myIcon: Icons.exit_to_app,
                                couleur: Color.fromRGBO(179, 0, 230, 0.5),
                                shadowColor: Colors.transparent))
                      ],
                    ),
                  ),
                ),
                Container(
                  height: double.infinity,
                  width: MediaQuery.of(context).size.width -
                      0.26 * MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 245, 238, 0.1),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 0.06 * MediaQuery.of(context).size.height,
                      ),
                      ProgressBar(
                        color: Colors.purpleAccent,
                        backGroundColor: Color.fromRGBO(200, 162, 200, 0.5),
                        innerString:
                            playerStatsUtil.calculateTotal().toString(),
                        text: "Jeux",
                        percentage: playerStatsUtil.calculateTotal() / 25,
                      ),
                      SizedBox(
                        width: 0.04 * MediaQuery.of(context).size.height,
                      ),
                      ProgressBar(
                        innerString: playerStatsUtil
                            .countNumberOfOnesInAString(3)
                            .toString(),
                        color: Colors.lightGreenAccent,
                        backGroundColor: Color.fromRGBO(255, 218, 185, 0.5),
                        text: "Défis",
                        percentage:
                            playerStatsUtil.countNumberOfOnesInAString(3) /
                                24,
                      ),
                      SizedBox(
                        width: 0.04 * MediaQuery.of(context).size.height,
                      ),
                      ProgressBar(
                        color: Colors.cyanAccent,
                        innerString: (playerStatsUtil
                                        .countNumberOfOnesInAString(3) /
                                    6 +
                                1)
                            .toInt()
                            .toString(),
                        backGroundColor: Color.fromRGBO(230, 230, 250, 1),
                        text: "Histoires",
                        percentage: (playerStatsUtil
                                            .countNumberOfOnesInAString(3) /
                                        6 +
                                    1)
                                .toInt() /
                            6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class ProgressBar extends StatelessWidget {
  const ProgressBar(
      {super.key,
      required this.text,
      required this.color,
      required this.percentage,
      required this.backGroundColor,
      required this.innerString});
  final Color color;
  final String innerString;
  final Color backGroundColor;
  final String text;
  final double percentage;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 0.25 * MediaQuery.of(context).size.height,
        ),
        CircularPercentIndicator(
          radius: 0.11 * MediaQuery.of(context).size.width,
          lineWidth: 8.0,
          percent: percentage.clamp(0.0, 1.0),
          center: Text(
            innerString,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Digital',
                fontSize: 24),
          ),
          progressColor: color,
          backgroundColor: backGroundColor,
        ),
        SizedBox(
          height: 0.01 * MediaQuery.of(context).size.height,
        ),
        Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Digital',
              fontSize: 22,
              color: Colors.black,
              decoration: TextDecoration.none),
        )
      ],
    );
  }
}
