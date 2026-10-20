import 'package:sorttrash/composents/app_audio.dart';
import 'package:flutter/material.dart';
import 'package:sorttrash/quiz/quizmultiples.dart';
import 'package:audioplayers/audioplayers.dart';

import '../player_box.dart';
import 'quiz_ui.dart';

class QuizPhotos {
  String question;
  String photoQuestion;
  String reponse1;
  String photo1;
  String reponse2;
  String photo2;
  String reponse3;
  String photo3;
  String reponse4;
  String photo4;
  int reponseCorrecte;
  EXPLICATION explication;
  String SoundPath;
  QuizPhotos({
    required this.question,
    required this.photoQuestion,
    required this.reponse1,
    required this.photo1,
    required this.reponse2,
    required this.photo2,
    required this.reponse3,
    required this.photo3,
    required this.reponse4,
    required this.photo4,
    required this.reponseCorrecte,
    required this.explication,
    required this.SoundPath,
  });
}

class QuizPhotosDesign extends StatefulWidget {
  final QuizPhotos quizPhotos;
  const QuizPhotosDesign({
    super.key,
    required this.quizPhotos,
  });

  @override
  State<QuizPhotosDesign> createState() => _QuizPhotosDesignState();
}

class _QuizPhotosDesignState extends State<QuizPhotosDesign> with QuizAnswerLogic {
  final _player = AppAudio.create();

  @override
  AudioPlayer get quizPlayer => _player;

  @override
  int get correctAnswer => widget.quizPhotos.reponseCorrecte;

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
    _player.play(AssetSource(widget.quizPhotos.SoundPath), volume: globalVolumeSoundSettings);
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.quizPhotos;
    final answers = [
      (q.reponse1, q.photo1),
      (q.reponse2, q.photo2),
      (q.reponse3, q.photo3),
      (q.reponse4, q.photo4),
    ];
    return QuizScaffold(
      onReplayAudio: _playQuestion,
      onRestart: restartLevel,
      child: Column(
        children: [
          QuestionBubble(text: q.question, image: q.photoQuestion),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                for (int i = 0; i < answers.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  Expanded(
                    child: AnswerTile(
                      text: answers[i].$1,
                      image: answers[i].$2,
                      state: stateOf(i + 1),
                      onTap: onAnswer(i + 1),
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
