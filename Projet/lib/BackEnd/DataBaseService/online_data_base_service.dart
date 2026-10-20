import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:sorttrash/BackEnd/DataBaseService/local_data_base_service.dart';
import 'package:sorttrash/player_box.dart';
import 'package:uuid/uuid.dart';

import '../PlayerProgress/player.dart';

class OnlineDataBaseService extends DataBaseService {
  late String _uid;

  OnlineDataBaseService(super.players, super.parent, String uid) {
    _uid = uid;
  }
  @override
  addElementProgress(String childName, int childAge, String profileImage) {
    if (!(childName == '' || childAge >= 100 || childAge <= 3)) {
      int index = 0;
      // No cached family for THIS account yet (other accounts may be cached).
      if (!onlineParentBox.containsKey(getUID())) {
        onlineParentBox.put(getUID(), returnParent());
        index = returnParent().numberOfChildren;
        incrementChildrenCount();
        addChild(PlayerProgress(
            0,
            [
              LevelsCompleted(1, '100000000000000000000000000000000000000000000000'),
              LevelsCompleted(2, '100000000000000000000000000000000000000000000000'),
              LevelsCompleted(3, '100000000000000000000000000000000000000000000000'),
              LevelsCompleted(4, '100000000000000000000000000000000000000000000000'),
            ],
            DateTime.now(),
            index,
            childName,
            '$childName-${const Uuid().v4().toString().substring(0, 8)}',profileImage,DateTime.now()));
        setParentChildren(returnPlayers());
        onlineParentBox.put(getUID(), returnParent());
      } else {
        setParent(onlineParentBox.get(getUID()) ?? returnParent());
        index = returnParent().numberOfChildren;
        incrementChildrenCount();
        addChild(PlayerProgress(
            0,
            [
              LevelsCompleted(1, '100000000000000000000000000000000000000000000000'),
              LevelsCompleted(2, '100000000000000000000000000000000000000000000000'),
              LevelsCompleted(3, '100000000000000000000000000000000000000000000000'),
              LevelsCompleted(4, '100000000000000000000000000000000000000000000000'),
            ],
            DateTime.now(),
            index,
            childName,
            '$childName-${const Uuid().v4().toString().substring(0, 8)}', profileImage,DateTime.now()));
        setParentChildren(returnPlayers());
        onlineParentBox.put(getUID(), returnParent());
      }

    }
  }

  @override
  deleteElementProgress(PlayerProgress playerProgress) {
    try {
      decrementChildrenCount();
      int i = returnPlayers().indexOf(playerProgress);
      removeChild(playerProgress);
      while (i < returnPlayers().length) {
        globalChildKey--;
        decrementChildID(i);
        i++;
      }
      setParentChildren(returnPlayers());
      onlineParentBox.put(getUID(), returnParent());
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  updateElementProgress(
      PlayerProgress playerProgress, String childName, int childAge) {
    if (!(childName == '' || childAge >= 100 || childAge <= 3)) {
      playerProgress.childsName = childName;
      removeChild(playerProgress);
      addChild(playerProgress);
      setParent(onlineParentBox.get(getUID()) ?? returnParent());
      setParentChildren(returnPlayers());
      onlineParentBox.put(getUID(), returnParent());
    }
  }

  @override
  bool returnLockedState(int index, int levelNumber) {
    try {
      setParent(onlineParentBox.get(getUID()) ?? returnParent());
      playerProgress =
          onlineProgress.returnParent().children[onlineGlobalChildKey];
    } catch (e) {
      debugPrint('$e');
    }
    if (index < 0 ||
        index >= playerProgress.gamesData[levelNumber].levelsCompleted.length) {
      return true;
    }
    if (playerProgress.gamesData[levelNumber].levelsCompleted[index] == '0') {
      return true;
    } else {
      return false;
    }
  }

  @override
  bool returnChallengeLockedState(int index, int levelNumber) {
    try {
      setParent(onlineParentBox.get(getUID()) ?? returnParent());
      playerProgress =
      onlineProgress.returnParent().children[onlineGlobalChildKey];
    } catch (e) {
      debugPrint('$e');
    }
    if (index < 0 ||
        index >= playerProgress.gamesData[levelNumber].levelsCompleted.length || playerProgress.lastChallengeDate == null) {
      return true;
    }
    if (playerProgress.gamesData[levelNumber].levelsCompleted[index] == '0') {
      return true;
    } else {
      if (isExactlyOneDayApart(playerProgress.lastChallengeDate!, DateTime.now())){
        return false;
      }
    }
    return true;
  }
  void setUID(String uid) {
    _uid = uid;
  }

  /// The signed-in family's id; falls back to the current Firebase user when
  /// it was never set (e.g. right after sign-up), so saves never use ''.
  String getUID() {
    if (_uid.isEmpty) _uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return _uid;
  }

  void appendDataAndSave(Parent parent) {
    try {
      int i = returnParent().children.length;
      int cpt = 0;
      while (cpt < parent.children.length) {
        addChild(PlayerProgress(
            parent.children[cpt].score,
            parent.children[cpt].gamesData,
            parent.children[cpt].lastTimeToJoin,
            i + cpt,
            parent.children[cpt].childsName,
            parent.children[cpt].childGlobalUID, parent.children[cpt].avatarProfileName, parent.children[cpt].lastChallengeDate));
        cpt++;
        incrementChildrenCount();
      }
      setParentChildren(returnPlayers());
    } catch (e) {
      debugPrint('$e');
    }
  }
}
