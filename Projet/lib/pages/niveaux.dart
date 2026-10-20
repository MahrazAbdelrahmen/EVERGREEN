import 'package:flutter/material.dart';
import 'package:sorttrash/composents/level_select.dart';
import 'package:sorttrash/sort_game/Levels/levels_managment.dart';

//la page de la gestion de niveaux

class Niveaux extends StatefulWidget {
  late LevelManagement _levelManagement;
  final int NbrNiveax;
  final int OpenLevels;
  final String href;
  Niveaux(
      {super.key,
      required this.NbrNiveax,
      required this.OpenLevels,
      required this.href,
      required LevelManagement levelMangement}) {
    _levelManagement = levelMangement;
  }

  @override
  State<Niveaux> createState() => _NiveauxState();
}

class _NiveauxState extends State<Niveaux> {
  @override
  Widget build(BuildContext context) {
    final levels = widget._levelManagement.levelsContainer;
    return ClassicLevelSelect(
      title: 'TRI',
      levelCount: widget.NbrNiveax,
      isLocked: (i) => levels[i].returnIsLocked(),
      isCompleted: (i) => isLevelCompleted(GameProgressSlot.sort, i),
      onOpen: (i) {
        sortGameNumber = i + 1;
        Navigator.push(context, MaterialPageRoute(builder: (_) => levels[i]))
            .then((_) => setState(() {}));
      },
    );
  }
}
