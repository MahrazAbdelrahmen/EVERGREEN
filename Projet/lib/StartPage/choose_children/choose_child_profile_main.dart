import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sorttrash/StartPage/choose_children/Leader/leader.dart';
import 'package:sorttrash/StartPage/choose_children/offlineSelection/offline_child_profiles.dart';
import 'package:sorttrash/StartPage/choose_children/onlineSelection/online_child_profile.dart';
import 'package:sorttrash/player_box.dart';

class AnonChildSelector extends StatefulWidget {
  const AnonChildSelector({super.key, Key? key1}) ;
  @override
  State<AnonChildSelector> createState() => _AnonChildSelector();
}

class _AnonChildSelector extends State<AnonChildSelector> {
  final User? user = FirebaseAuth.instance.currentUser;
  Widget _screen(int index) => switch (index) {
        0 => const OnlineProfilesSelection(),
        1 => const OfflineProfilesSelection(),
        _ => const LeaderBoard(),
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: currentProfileIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) => setState(() {
          currentProfileIndex = index;
        }),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.cloud_outlined),
              selectedIcon: Icon(Icons.cloud_rounded),
              label: 'En ligne'),
          NavigationDestination(
              icon: Icon(Icons.phone_android_outlined),
              selectedIcon: Icon(Icons.phone_android_rounded),
              label: 'Sur cet appareil'),
          NavigationDestination(
              icon: Icon(Icons.leaderboard_outlined),
              selectedIcon: Icon(Icons.leaderboard_rounded),
              label: 'Classement'),
        ],
      ),
      body: PopScope(
        canPop: false,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: KeyedSubtree(
            key: ValueKey(currentProfileIndex),
            child: _screen(currentProfileIndex),
          ),
        ),
      ),
    );
  }
}
