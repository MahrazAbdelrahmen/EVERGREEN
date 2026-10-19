import 'package:firebase_auth/firebase_auth.dart';
import 'package:sorttrash/composents/floating_snackbar.dart';
import 'package:flutter/material.dart';

import 'package:sorttrash/button.dart';
import 'package:sorttrash/defis/key_container.dart';
import 'package:sorttrash/player_box.dart';
import 'package:uuid/uuid.dart';
import '../../../BackEnd/PlayerProgress/player.dart';
import 'offline_data_profile_container.dart';

class OfflineProfilesSelection extends StatefulWidget {
  const OfflineProfilesSelection({super.key});

  @override
  State<OfflineProfilesSelection> createState() =>
      _OfflineProfilesSelectionState();
}

class _OfflineProfilesSelectionState extends State<OfflineProfilesSelection> {
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {

    if (parentBox.isNotEmpty) {
      Parent test = Parent([], 0, const Uuid().v4().toString());
      test = parentBox.getAt(0);
      offlineProgress.setParent(test);
      offlineProgress.setPlayers(offlineProgress.returnParent().children);
      setState(() {
        offlineGlobalPlayers = test.children;
      });
    } else {
      offlineProgress.setParent(Parent([], 0, const Uuid().v4().toString()));
      parentBox.add(offlineProgress.returnParent());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg-image2.png'),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const RoundButton(
                          myIcon: Icons.home,
                          href: '/StartPage',
                          couleur: Colors.greenAccent,
                          shadowColor: Colors.greenAccent,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: sm1,
                                side: const BorderSide(
                                    width: 3, color: Colors.white),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, top: 8, bottom: 10)),
                            onPressed: () async {
                              if (globalChildKey != -1) {
                                _startOfflineSession();
                                await Navigator.popAndPushNamed(context, '/');
                              } else {
                                FloatingSnackBar(
                                  message:
                                      '📢 : Veuillez choisir un profil enfant! ',
                                  context: context,
                                  textColor: Colors.black,
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Digital',
                                      fontSize: 16),
                                  duration: const Duration(milliseconds: 2000),
                                  backgroundColor: Colors.redAccent,
                                );
                              }
                            },
                            child: const Text(
                              'Jouer',
                              style: TextStyle(
                                fontFamily: 'Digital',
                              ),
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: sm1,
                                side: const BorderSide(
                                    width: 3, color: Colors.white),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, top: 8, bottom: 10)),
                            child: const Text(
                              'Ajouter',
                              style: TextStyle(
                                fontFamily: 'Digital',
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/AddPlayer');
                            }),
                      ],
                    ),
                  ),
                  ...offlineGlobalPlayers
                      .map((e) => OfflineProfileDataContainer(
                            playerProgress: e,
                          )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



  void _startOfflineSession() {
    offlineProgress.setChild(
        globalChildKey,
        PlayerProgress(
            offlineProgress.returnParent().children[globalChildKey].score,
            offlineProgress.returnParent().children[globalChildKey].gamesData,
            DateTime.now(),
            offlineProgress.returnParent().children[globalChildKey].childID,
            offlineProgress.returnParent().children[globalChildKey].childsName,
            offlineProgress
                .returnParent()
                .children[globalChildKey]
                .childGlobalUID,
            offlineProgress
                .returnParent()
                .children[globalChildKey]
                .avatarProfileName,
            offlineProgress
                .returnParent()
                .children[globalChildKey]
                .lastChallengeDate));
    parentBox.putAt(0, offlineProgress.returnParent());
  }
}
