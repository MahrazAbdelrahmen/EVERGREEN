import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sorttrash/BackEnd/ChallengesLocalDataBase/local_challenges.dart';
import 'package:sorttrash/button.dart';
import 'package:sorttrash/defis/show_challenge_screen.dart';
import '../BackEnd/PlayerProgress/player.dart';
import '../composents/app_theme.dart';
import '../composents/floating_snackbar.dart';
import '../player_box.dart';
import 'challenge_mangement.dart';
import 'key_container.dart';

/// Daily challenges: one new eco-gesture unlocks each day, shown as keys.
class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  late PlayerProgress playerProgress = currentProfileIndex == 1
      ? offlineProgress.returnParent().children[globalChildKey]
      : onlineProgress.returnParent().children[onlineGlobalChildKey];
  late ChallengeManagement challengeManagement;

  @override
  void initState() {
    super.initState();
    // A new challenge unlocks at most once a day.
    final last = playerProgress.lastChallengeDate;
    if (last != null && _isAtLeastOneDayApart(DateTime.now(), last)) {
      playerProgress.lastChallengeDate = DateTime.now();
      _unlockNextChallenge();
    }
    challengeManagement = ChallengeManagement();
  }

  List<bool> get _locked => challengeManagement.locked;

  int get _unlockedCount => _locked.where((locked) => !locked).length;

  /// The most recently unlocked challenge, or -1 if none.
  int get _newest => _locked.lastIndexWhere((locked) => !locked);

  String get _nextUnlockText {
    if (_unlockedCount >= ChallengeManagement.challengeCount) {
      return 'Bravo, tous les défis sont débloqués !';
    }
    final last = playerProgress.lastChallengeDate;
    if (last == null) return 'Un nouveau défi chaque jour !';
    final remaining = last.add(const Duration(days: 1)).difference(DateTime.now());
    if (remaining.inMinutes <= 0) return 'Un nouveau défi t\'attend !';
    final hours = remaining.inHours;
    final when = hours >= 1 ? '$hours h' : '${remaining.inMinutes} min';
    return 'Un nouveau défi chaque jour ! Prochain dans $when';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/bg-image2.png'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Row(
                  children: [
                    const RoundButton(
                      href: '/games',
                      myIcon: Icons.arrow_back_rounded,
                      couleur: AppColors.darkBeige,
                      shadowColor: AppColors.darkBeige,
                    ),
                    const Spacer(),
                    _Header(unlocked: _unlockedCount, total: ChallengeManagement.challengeCount),
                    const Spacer(),
                    const RoundButton(
                      href: '/TrophiesPage',
                          replace: false,
                      myIcon: Icons.star,
                      couleur: AppColors.darkBeige,
                      shadowColor: AppColors.darkBeige,
                    ),
                    const SizedBox(width: 12),
                    const RoundButton(
                      href: '/',
                      myIcon: Icons.home_rounded,
                      couleur: AppColors.darkBeige,
                      shadowColor: AppColors.darkBeige,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wb_sunny_rounded, color: sm1, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      _nextUnlockText,
                      style: const TextStyle(fontFamily: 'Digital', fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Expanded(child: _grid()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _grid() {
    const columns = 8;
    const rows = ChallengeManagement.challengeCount ~/ columns;
    return LayoutBuilder(builder: (context, constraints) {
      const gap = 14.0;
      final tile = math.min(
        (constraints.maxWidth - 48 - gap * (columns - 1)) / columns,
        (constraints.maxHeight - 28 - gap * (rows - 1)) / rows,
      );
      final newest = _newest;
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int row = 0; row < rows; row++) ...[
              if (row > 0) const SizedBox(height: gap),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int col = 0; col < columns; col++) ...[
                    if (col > 0) const SizedBox(width: gap),
                    _key(row * columns + col, tile, newest),
                  ],
                ],
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _key(int index, double size, int newest) {
    return KeyTile(
      number: index + 1,
      size: size,
      locked: _locked[index],
      isNew: index == newest,
      onTap: () => showChallengeDialog(
        context,
        number: index + 1,
        text: globalchallengesInformationsList[index],
      ),
      onLockedTap: () => FloatingSnackBar(
        message: '🔒 Reviens demain pour débloquer un nouveau défi !',
        context: context,
        duration: const Duration(milliseconds: 1800),
        backgroundColor: sm,
      ),
    );
  }

  void _unlockNextChallenge() {
    playerProgress.gamesData[3].levelsCompleted =
        playerProgress.gamesData[3].levelsCompleted.replaceFirst('0', '1');
    try {
      if (currentProfileIndex == 1) {
        offlineProgress.setChild(globalChildKey, playerProgress);
        if (parentBox.isEmpty) {
          parentBox.add(offlineProgress.returnParent());
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

  bool _isAtLeastOneDayApart(DateTime date1, DateTime date2) {
    return date2.difference(date1).inDays.abs() >= 1;
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.unlocked, required this.total});
  final int unlocked;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 4, 8, 4),
      decoration: BoxDecoration(
        color: sm,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [BoxShadow(color: Color.lerp(sm, Colors.black, 0.3)!, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'DÉFIS',
            style: TextStyle(
              fontFamily: 'Digital',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2))],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/gold_key.png', height: 20),
                const SizedBox(width: 4),
                Text('$unlocked/$total',
                    style: const TextStyle(fontFamily: 'Digital', fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
