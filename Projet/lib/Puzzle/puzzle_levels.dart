
import 'package:flutter/material.dart';
import 'package:sorttrash/composents/level_select.dart';
import 'Models/puzzle_management.dart';



class PuzzleLevels extends StatefulWidget {
  late PuzzleManagement _puzzleManagement;
  final int nbrNiveax;
  final int openLevels;
  final String href;
  PuzzleLevels(
      {super.key,
        required this.nbrNiveax,
        required this.openLevels,
        required this.href,
        required PuzzleManagement levelMangement}) {
    _puzzleManagement = levelMangement;
  }

  @override
  State<PuzzleLevels> createState() => _PuzzleLevels();
}

class _PuzzleLevels extends State<PuzzleLevels> {
  @override
  Widget build(BuildContext context) {
    final levels = widget._puzzleManagement.levelsContainer;
    return ClassicLevelSelect(
      title: 'PUZZLE',
      levelCount: widget.nbrNiveax,
      isLocked: (i) => levels[i].returnIsLocked(),
      isCompleted: (i) => isLevelCompleted(GameProgressSlot.puzzle, i),
      onOpen: (i) {
        puzzleNumber = i + 1;
        Navigator.push(context, MaterialPageRoute(builder: (_) => levels[i]))
            .then((_) => setState(() {}));
      },
    );
  }
}
