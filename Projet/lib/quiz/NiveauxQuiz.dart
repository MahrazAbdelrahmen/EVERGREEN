import 'package:flutter/material.dart';
import 'package:sorttrash/composents/level_select.dart';
import 'managementQuiz.dart';

//la page de la gestion de niveaux

class NiveauxQuiz extends StatefulWidget {
  late final  Management _levelManagement;
  final int nbrNiveax;
  final int openLevels;
  final String href;
  NiveauxQuiz(
      {super.key,
      required this.nbrNiveax,
      required this.openLevels,
      required this.href,
      required Management levelMangement}) {
    _levelManagement = levelMangement;
  }

  @override
  State<NiveauxQuiz> createState() => _NiveauxQuizState();
}

class _NiveauxQuizState extends State<NiveauxQuiz> {
  @override
  Widget build(BuildContext context) {
    final levels = widget._levelManagement.QuizContainer;
    return ClassicLevelSelect(
      title: 'QUIZ',
      levelCount: widget.nbrNiveax,
      isLocked: (i) => levels[i].returnIsLocked(),
      isCompleted: (i) => isLevelCompleted(GameProgressSlot.quiz, i),
      onOpen: (i) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => levels[i]))
            .then((_) => setState(() {}));
      },
    );
  }
}
