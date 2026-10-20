import 'package:sorttrash/composents/app_audio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../BackEnd/PlayerProgress/player.dart';
import '../StartPage/settings.dart';
import '../composents/app_theme.dart';
import '../composents/navigation.dart';
import '../composents/ui/app_button.dart';
import '../pages/bravo_widget.dart';
import '../player_box.dart';
import 'quiz_ui.dart';
import 'quizphotos.dart';
import 'package:sorttrash/quiz/quizmultiples.dart';
import 'package:sorttrash/quiz/quizgestes.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

/// A quiz level: a hub screen that introduces the level, shows the
/// explanation after each answer, and opens the questions one by one.
class Level extends StatefulWidget {
  late Function(bool) _changeBooleanStatus;
  List<Widget> liste;
  final int levelIndex;
  int _currentIndex = 0;
  bool isFirst = false;
  Level({
    super.key,
    required Function(bool) changeBooleanStatus,
    required bool isLocked,
    required this.liste,
    required this.levelIndex,
  }) {
    _changeBooleanStatus = changeBooleanStatus;
    _isLocked = isLocked;
  }
  bool _isLocked = false;

  bool returnIsLocked() {
    return _isLocked;
  }

  void setIsLocked(bool isUnlockde) {
    _isLocked = isUnlockde;
  }

  @override
  State<Level> createState() => _LevelState();
}

class _LevelState extends State<Level> {
  static const _pointsPerCorrectAnswer = 10;

  final User? user = FirebaseAuth.instance.currentUser;
  final _player = AppAudio.create();
  late PlayerProgress playerProgress = currentProfileIndex == 1
      ? offlineProgress.returnParent().children[globalChildKey]
      : onlineProgress.returnParent().children[onlineGlobalChildKey];

  @override
  void initState() {
    super.initState();
    globalMusicPlayerStartPage.stop();
    _restart();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _restart() {
    widget._currentIndex = 0;
    widget.isFirst = false;
    widget.liste.shuffle(Random());
    QuizProgress.startLevel(widget.liste.length);
  }

  bool get _finished => widget._currentIndex >= widget.liste.length;

  EXPLICATION? get _lastExplanation {
    if (widget._currentIndex == 0) return null;
    final previous = widget.liste[widget._currentIndex - 1];
    return switch (previous) {
      QuizMultiples q => q.explication,
      QuizGestes q => q.explication,
      QuizPhotosDesign q => q.quizPhotos.explication,
      _ => null,
    };
  }

  void _playExplanation() {
    final explanation = _lastExplanation;
    if (explanation == null) return;
    _player.stop();
    _player.play(AssetSource(explanation.SoundPath), volume: globalVolumeSoundSettings);
  }

  Future<void> _openNextQuestion() async {
    _player.stop();
    QuizProgress.question = widget._currentIndex + 1;
    final replay = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget.liste[widget._currentIndex]),
    );
    if (!mounted) return;
    setState(() {
      if (replay == true) {
        _restart();
      } else {
        widget._currentIndex += 1;
      }
    });
    if (replay != true) _playExplanation();
  }

  void _finishLevel() {
    final points = QuizProgress.correct * _pointsPerCorrectAnswer;
    playerProgress.score += points;
    final progress = playerProgress.gamesData[2].levelsCompleted.split('');
    if (widget.levelIndex + 1 < progress.length) {
      progress[widget.levelIndex + 1] = '1';
      playerProgress.gamesData[2].levelsCompleted = progress.join();
    }
    widget._changeBooleanStatus(false);
    try {
      if (currentProfileIndex == 1) {
        offlineProgress.setChild(globalChildKey, playerProgress);
        if (parentBox.isEmpty) {
          parentBox.add(offlineProgress.returnParent());
        } else {
          parentBox.putAt(0, offlineProgress.returnParent());
        }
      } else {
        onlineProgress.setChild(onlineGlobalChildKey, playerProgress);
        onlineParentBox.put(user!.uid, onlineProgress.returnParent());
        onlineProgress.returnParent().updateData(onlineProgress.getUID());
      }
    } catch (e) {
      debugPrint('$e');
    }
    final ratio = QuizProgress.total == 0 ? 0 : QuizProgress.correct / QuizProgress.total;
    final stars = ratio >= 0.9 ? 3 : (ratio >= 0.6 ? 2 : 1);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BravoPage(score: points, stars: stars)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final explanation = _lastExplanation;
    final String message;
    final String buttonLabel;
    if (widget._currentIndex == 0) {
      message = "Prépare-toi pour ce niveau !\n${widget.liste.length} questions t'attendent.";
      buttonLabel = 'Commencer';
    } else {
      message = explanation?.text ?? "Prêt pour la suite ?";
      buttonLabel = _finished ? 'Terminer' : 'Question suivante';
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/bg-image3.png"), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Row(
                  children: [
                    RoundIconButton(
                      icon: Icons.arrow_back_rounded,
                      color: AppColors.green,
                      tooltip: 'Niveaux',
                      onTap: () => backToRoute(context, '/Nquiz'),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(child: QuizProgressBar()),
                    const SizedBox(width: 60),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(80, 12, 80, 12),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white.withValues(alpha: 0.88),
                      boxShadow: const [
                        BoxShadow(color: Colors.black38, offset: Offset(0, 5), blurRadius: 10),
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.asset("assets/images/logo2.png", width: 110),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              if (explanation != null)
                                const Text(
                                  'Le savais-tu ?',
                                  style: TextStyle(
                                    fontFamily: 'Digital',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: quizPink,
                                  ),
                                ),
                              Expanded(
                                child: Center(
                                  child: SingleChildScrollView(
                                    child: Text(
                                      message,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 17, color: Colors.black87),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (explanation != null) ...[
                                    RoundIconButton(
                                      icon: Icons.volume_up_rounded,
                                      color: AppColors.darkBeige,
                                      tooltip: 'Écouter',
                                      onTap: _playExplanation,
                                    ),
                                    const SizedBox(width: 16),
                                  ],
                                  AppButton(
                                    label: buttonLabel,
                                    icon: _finished ? Icons.flag_rounded : Icons.play_arrow_rounded,
                                    color: AppColors.green,
                                    onTap: _finished ? _finishLevel : _openNextQuestion,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
