import 'package:sorttrash/composents/app_audio.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../player_box.dart';
import 'quiz_ui.dart';

class Indication {
  String text; //le corps de l'indication
  String SoundPath; //le son
  Indication({required this.text, required this.SoundPath});
}

class EXPLICATION {
  String text; //corps
  String SoundPath; //son
  EXPLICATION({required this.text, required this.SoundPath});
}

class QuizMultiples extends StatefulWidget { //le ui et le corps des quiz multiples
  final String question;
  final String reponse1;
  final String reponse2;
  final String reponse3;
  final String reponse4;
  final int reponseCorrecte; //pour indiquer le numero de la reponse correcte
  final Indication indication;
  final EXPLICATION explication;
  final String SoundPath;
  const QuizMultiples(
      {super.key,
      required this.question,
      required this.reponse1,
      required this.reponse2,
      required this.reponse3,
      required this.reponse4,
      required this.reponseCorrecte,
      required this.indication,
      required this.explication,
      required this.SoundPath});

  @override
  State<QuizMultiples> createState() => _QuizMultiplesState();
}

class _QuizMultiplesState extends State<QuizMultiples> with QuizAnswerLogic {
  final _player = AppAudio.create();

  @override
  AudioPlayer get quizPlayer => _player;

  @override
  int get correctAnswer => widget.reponseCorrecte;

  @override
  void initState() {
    super.initState();
    _playQuestion();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _playQuestion() {
    _player.stop();
    _player.play(AssetSource(widget.SoundPath), volume: globalVolumeSoundSettings);
  }

  @override
  Widget build(BuildContext context) {
    final answers = [widget.reponse1, widget.reponse2, widget.reponse3, widget.reponse4];
    return QuizScaffold(
      onReplayAudio: _playQuestion,
      onRestart: restartLevel,
      onHint: () {
        _player.stop();
        showQuizHint(context,
            text: widget.indication.text, soundPath: widget.indication.SoundPath);
      },
      child: Column(
        children: [
          QuestionBubble(text: widget.question),
          const SizedBox(height: 12),
          Expanded(
            child: Column(
              children: [
                for (int row = 0; row < 2; row++) ...[
                  if (row == 1) const SizedBox(height: 12),
                  Expanded(
                    child: Row(
                      children: [
                        for (int col = 0; col < 2; col++) ...[
                          if (col == 1) const SizedBox(width: 12),
                          Expanded(
                            child: AnswerTile(
                              text: answers[row * 2 + col],
                              state: stateOf(row * 2 + col + 1),
                              onTap: onAnswer(row * 2 + col + 1),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
