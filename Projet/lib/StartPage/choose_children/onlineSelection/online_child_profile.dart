import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sorttrash/player_box.dart';

import '../../../BackEnd/PlayerProgress/player.dart';
import '../../../composents/app_theme.dart';
import '../../../composents/ui/app_button.dart';
import '../profile_widgets.dart';

class OnlineProfilesSelection extends StatefulWidget {
  const OnlineProfilesSelection({super.key});

  @override
  State<OnlineProfilesSelection> createState() => _OnlineProfilesSelection();
}

class _OnlineProfilesSelection extends State<OnlineProfilesSelection> {
  late Timer _timer;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      await getProgress();
      if (!mounted) return;
      setState(() {
        playersOnline = onlineProgress.returnPlayers();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) return const _SignedOut();
    return Scaffold(
      body: ProfilePicker(
        players: playersOnline,
        selectedId: onlineGlobalChildKey,
        onSelect: _select,
        onEdit: _edit,
        onAdd: () async {
          final newId = await Navigator.pushNamed(context, '/AddPlayer');
          if (!mounted) return;
          setState(() {
            _loadFromBox();
            if (newId is int && newId >= 0) {
              onlineGlobalChildKey = newId;
              globalChildKey = -1;
            }
          });
        },
        onPlay: () {
          addChild();
          Navigator.popAndPushNamed(context, '/');
        },
      ),
    );
  }

  /// Re-reads this account's profiles from the local cache of Firestore data.
  void _loadFromBox() {
    final Parent? parent = onlineParentBox.get(user!.uid);
    if (parent == null) return;
    onlineProgress.setParent(parent);
    onlineProgress.setPlayers(parent.children);
    playersOnline = parent.children;
  }

  void _select(PlayerProgress player) {
    HapticFeedback.lightImpact();
    setState(() {
      onlineGlobalChildKey = player.childID;
      globalChildKey = -1;
    });
    try {
      onlineProgress.setParent(onlineParentBox.get(user!.uid) ?? onlineProgress.returnParent());
      onlineParentBox.put(onlineProgress.getUID(), onlineProgress.returnParent());
      onlineProgress.returnParent().updateData(onlineProgress.getUID());
    } catch (e) {
      debugPrint('$e');
    }
  }

  void _edit(PlayerProgress player) {
    showEditProfileDialog(
      context,
      player: player,
      onRename: (name) => setState(() {
        onlineProgress.setParent(onlineParentBox.get(user!.uid) ?? onlineProgress.returnParent());
        player.childsName = name;
        onlineProgress.setChild(player.childID, player);
        onlineProgress.returnParent().updateData(onlineProgress.getUID());
        onlineParentBox.put(onlineProgress.getUID(), onlineProgress.returnParent());
      }),
      onDelete: () => setState(() {
        onlineProgress.setParent(onlineParentBox.get(user!.uid) ?? onlineProgress.returnParent());
        onlineProgress.deleteElementProgress(player);
        playersOnline = onlineProgress.returnPlayers();
        onlineGlobalChildKey = -1;
        onlineProgress.returnParent().updateData(onlineProgress.getUID());
        onlineParentBox.put(onlineProgress.getUID(), onlineProgress.returnParent());
      }),
    );
  }
}

class _SignedOut extends StatelessWidget {
  const _SignedOut();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg-image2.png'), fit: BoxFit.cover),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.lightBlue),
                const SizedBox(height: 8),
                const Text('Profils en ligne',
                    style: TextStyle(
                        fontFamily: 'Digital', fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Connecte-toi pour sauvegarder ta progression en ligne.',
                    style: TextStyle(fontFamily: 'Digital', color: Colors.black54)),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Se connecter',
                  icon: Icons.login_rounded,
                  color: AppColors.lightBlue,
                  onTap: () => Navigator.pushNamed(context, '/LoginPage'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void addChild() {
  final child = onlineProgress.returnParent().children[onlineGlobalChildKey];
  onlineProgress.setChild(
      onlineGlobalChildKey,
      PlayerProgress(
          child.score,
          child.gamesData,
          DateTime.now(),
          child.childID,
          child.childsName,
          child.childGlobalUID,
          child.avatarProfileName,
          child.lastChallengeDate));
  onlineParentBox.put(onlineProgress.getUID(), onlineProgress.returnParent());
  onlineProgress.returnParent().updateData(onlineProgress.getUID());
}
