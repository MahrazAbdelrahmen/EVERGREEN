import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sorttrash/player_box.dart';
import 'package:uuid/uuid.dart';

import '../../../BackEnd/PlayerProgress/player.dart';
import '../profile_widgets.dart';

class OfflineProfilesSelection extends StatefulWidget {
  const OfflineProfilesSelection({super.key});

  @override
  State<OfflineProfilesSelection> createState() =>
      _OfflineProfilesSelectionState();
}

class _OfflineProfilesSelectionState extends State<OfflineProfilesSelection> {
  @override
  void initState() {
    super.initState();
    _loadFromBox();
  }

  /// The Hive box is the source of truth for offline profiles.
  void _loadFromBox() {
    if (parentBox.isNotEmpty) {
      final Parent parent = parentBox.getAt(0);
      offlineProgress.setParent(parent);
      offlineProgress.setPlayers(parent.children);
      offlineGlobalPlayers = parent.children;
    } else {
      offlineProgress.setParent(Parent([], 0, const Uuid().v4().toString()));
      parentBox.add(offlineProgress.returnParent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfilePicker(
        players: offlineGlobalPlayers,
        selectedId: globalChildKey,
        onSelect: _select,
        onEdit: _edit,
        onAdd: () async {
          final newId = await Navigator.pushNamed(context, '/AddPlayer');
          if (!mounted) return;
          setState(() {
            _loadFromBox();
            if (newId is int && newId >= 0) {
              globalChildKey = newId;
              onlineGlobalChildKey = -1;
            }
          });
        },
        onPlay: () {
          _startOfflineSession();
          Navigator.popAndPushNamed(context, '/');
        },
      ),
    );
  }

  void _select(PlayerProgress player) {
    HapticFeedback.lightImpact();
    setState(() {
      globalChildKey = player.childID;
      onlineGlobalChildKey = -1;
      offlineProgress.setParent(parentBox.get(0));
    });
  }

  void _edit(PlayerProgress player) {
    showEditProfileDialog(
      context,
      player: player,
      onRename: (name) => setState(() {
        player.childsName = name;
        offlineProgress.setChild(player.childID, player);
        parentBox.putAt(0, offlineProgress.returnParent());
      }),
      onDelete: () => setState(() {
        offlineProgress.deleteElementProgress(player);
        offlineProgress.setPlayers(offlineProgress.returnPlayers());
        offlineGlobalPlayers = offlineProgress.returnParent().children;
        globalChildKey = -1;
      }),
    );
  }

  void _startOfflineSession() {
    final child = offlineProgress.returnParent().children[globalChildKey];
    offlineProgress.setChild(
        globalChildKey,
        PlayerProgress(
            child.score,
            child.gamesData,
            DateTime.now(),
            child.childID,
            child.childsName,
            child.childGlobalUID,
            child.avatarProfileName,
            child.lastChallengeDate));
    parentBox.putAt(0, offlineProgress.returnParent());
  }
}
