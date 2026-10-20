import 'package:sorttrash/composents/app_audio.dart';
import 'package:flutter/material.dart';
import 'package:sorttrash/quiz/quizmultiples.dart';
import 'package:audioplayers/audioplayers.dart';

import '../player_box.dart';
import 'quiz_ui.dart';

/// "Bon geste ou mauvais geste ?": pick the right one of two pictures.
class QuizGestes extends StatefulWidget {
  final String question;
  final String photo1;
  final String photo2;
  final int reponseCorrecte;
  final EXPLICATION explication;
  final String SoundPath;
  const QuizGestes({
    super.key,
    required this.question,
    required this.photo1,
    required this.photo2,
    required this.reponseCorrecte,
    required this.explication,
    required this.SoundPath,
  });

  @override
  State<QuizGestes> createState() => _QuizGestesState();
}

class _QuizGestesState extends State<QuizGestes> with QuizAnswerLogic {
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
    return QuizScaffold(
      onReplayAudio: _playQuestion,
      onRestart: restartLevel,
      child: Column(
        children: [
          QuestionBubble(text: widget.question),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: AnswerTile(
                    image: widget.photo1,
                    state: stateOf(1),
                    onTap: onAnswer(1),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: AnswerTile(
                    image: widget.photo2,
                    state: stateOf(2),
                    onTap: onAnswer(2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
