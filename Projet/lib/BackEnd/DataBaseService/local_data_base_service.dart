import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../player_box.dart';
import '../PlayerProgress/player.dart';
// class pour gérer la base du données et user actuelle localement
class DataBaseService {
  static final List<LevelsCompleted> newGameDataPlayer = [
    LevelsCompleted(1, '100000000000000000000000000000000000000000000000'),
    LevelsCompleted(2, '100000000000000000000000000000000000000000000000'),
    LevelsCompleted(3, '100000000000000000000000000000000000000000000000'),
    LevelsCompleted(4, '100000000000000000000000000000000000000000000000'),
  ];
  List<PlayerProgress> _players = []; // un  liste du enfants du parent actuel 
  late Parent _parent = Parent([], 0, const Uuid().v4().toString());
  DataBaseService(List<PlayerProgress> players, Parent parent) {
    _parent = parent;
    _players = players;
  }
  // ajouter un enfant
  void addElementProgress(String childName, int childAge, String profileImage) {
    if (!(childName == '' || childAge >= 100 || childAge <= 3)) { // verification d'age
      int index = 0;
      if (parentBox.isEmpty) { // si la base est vide
        index = _parent.numberOfChildren; // nous obtenons le nombre actuel de joueurs du parent pour servir d'index pour en ajouter un nouveau
        _players.add(PlayerProgress( // nous ajoutons un nouveau joueur nous avons de nouvelles données
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
        _parent.children = _players.toList(); // on mis a jour la liste des enfants acutelle 
        _parent.numberOfChildren++; // nous mettons à jour la liste des enfants pour le parent actuel
        parentBox.add(_parent); // on mis a jour le parent dans la base des données
      } else { // si la base des données n'est pas vide
        _parent = parentBox.getAt(0); // on récuper le parent d'apres la base
        index = _parent.numberOfChildren; // nous obtenons le nombre actuel de joueurs du parent pour servir d'index pour en ajouter un nouveau
        _players.add(PlayerProgress(
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
        _parent.children = _players.toList(); 
        _parent.numberOfChildren++;
        parentBox.putAt(0, _parent); // enregistrer les nouvelles données dans la base de données
      }
    }
  }
  // Retourne l'état de verrouillage d'un niveau dans une bit map
  bool returnLockedState(int index, int levelNumber) {
    try {
      _parent = parentBox.getAt(0);
      playerProgress = offlineProgress.returnParent().children[globalChildKey];
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
  // Retourne l'état de verrouillage du défi
  bool returnChallengeLockedState(int index, int levelNumber){
    try {
      _parent = parentBox.getAt(0);
      playerProgress = offlineProgress.returnParent().children[globalChildKey];
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
      if (playerProgress.gamesData[levelNumber].levelsCompleted[index] == '1'){
        return false;
      }
      if (isExactlyOneDayApart(playerProgress.lastChallengeDate!, DateTime.now())){
        return false;
      }
    }
    return true;
  }
  // fonction pour vérifier si la date2 est après la date1 de plus d'un jour
  bool isExactlyOneDayApart(DateTime date1, DateTime date2) {
    final difference = date2.difference(date1);
    return difference.inDays.abs() >= 1;
  }
  // Procedure qui permet de supprimer un enfant 
  void deleteElementProgress(PlayerProgress playerProgress) {
    _parent.numberOfChildren--;
    int i = _players.indexOf(playerProgress);
    _players.remove(playerProgress);
    while (i < _players.length) {
      globalChildKey--;
      _players[i].childID--;
      i++;
    }
    _parent.children = _players;
    parentBox.putAt(0, _parent);
  }
  // procédure qui permet de faire des mises à jour sur les données de l'utilisateur 
  void updateElementProgress(
      PlayerProgress playerProgress, String childName, int childAge) {
    if (!(childName == '' || childAge >= 100 || childAge <= 3)) {
      playerProgress.childsName = childName;
      _players.remove(playerProgress);
      _players.add(playerProgress);
      _parent = parentBox.getAt(0);
      _parent.children = _players;
      parentBox.putAt(0, _parent);
    }
  }

  void setParent(Parent parent) {
    _parent = parent;
  }

  void setPlayers(List<PlayerProgress> players) {
    _players = players;
  }

  Parent returnParent() {
    return _parent;
  }
  
  List<PlayerProgress> returnPlayers() {
    return _players;
  }

  void incrementChildrenCount() {
    _parent.numberOfChildren++;
  }

  void decrementChildrenCount() {
    _parent.numberOfChildren--;
  }

  void setParentChildren(List<PlayerProgress> children) {
    _parent.children = children;
  }

  void addChild(PlayerProgress playerProgress) {
    _players.add(playerProgress);
  }

  void removeChild(PlayerProgress playerProgress) {
    _players.remove(playerProgress);
  }

  void decrementChildID(int index) {
    try {
      _players[index].childID--;
    } catch (e) {
      debugPrint('$e');
    }
  }

  void setChild(int index, PlayerProgress playerProgress) {
    try {
      _parent.children[index] = playerProgress;
    } catch (e) {
      debugPrint('$e');
    }
  }
}
