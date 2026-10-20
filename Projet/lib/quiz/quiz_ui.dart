import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../composents/app_audio.dart';
import '../composents/app_theme.dart';
import '../composents/game_settings.dart';
import '../composents/navigation.dart';
import '../composents/ui/app_button.dart';
import '../composents/ui/pressable.dart';
import '../player_box.dart';

/// Where the child is in the current quiz level. Set by the level screen.
abstract final class QuizProgress {
  static int question = 0;
  static int total = 0;
  static int correct = 0;

  static void startLevel(int questionCount) {
    question = 0;
    total = questionCount;
    correct = 0;
  }
}

const quizPink = Color.fromARGB(255, 218, 78, 204);
const quizPinkLight = Color.fromARGB(255, 242, 220, 247);
const quizPinkBorder = Color.fromARGB(255, 251, 194, 240);

/// Shared frame of every quiz question: back button, "Question 3 / 10" bar,
/// pause menu, a white card for the question, and audio / hint buttons.
class QuizScaffold extends StatelessWidget {
  const QuizScaffold({
    super.key,
    required this.child,
    required this.onReplayAudio,
    required this.onRestart,
    this.onHint,
    this.onBack,
  });

  final Widget child;
  final VoidCallback onReplayAudio;
  final VoidCallback onRestart;
  final VoidCallback? onHint;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
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
                      onTap: onBack ?? () => backToRoute(context, '/Nquiz'),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(child: QuizProgressBar()),
                    const SizedBox(width: 16),
                    GamesSettings(
                      functionToBeUsed: onRestart,
                      functionToResumeTimer: () {},
                      functionToStopTimer: () {},
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    children: [
                      RoundIconButton(
                        icon: Icons.volume_up_rounded,
                        color: AppColors.darkBeige,
                        tooltip: 'Écouter',
                        onTap: onReplayAudio,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white.withValues(alpha: 0.88),
                            boxShadow: const [
                              BoxShadow(color: Colors.black38, offset: Offset(0, 5), blurRadius: 10),
                            ],
                          ),
                          child: child,
                        ),
                      ),
                      const SizedBox(width: 16),
                      onHint == null
                          ? const SizedBox(width: 44)
                          : RoundIconButton(
                              icon: Icons.lightbulb_rounded,
                              color: AppColors.darkBeige,
                              tooltip: 'Indice',
                              onTap: onHint,
                            ),
                    ],
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

class QuizProgressBar extends StatelessWidget {
  const QuizProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final total = QuizProgress.total;
    final current = QuizProgress.question;
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Text(
            total == 0 ? 'Quiz' : 'Question $current / $total',
            style: const TextStyle(fontFamily: 'Digital', fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : current / total,
                minHeight: 12,
                color: quizPink,
                backgroundColor: quizPinkLight,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.check_circle_rounded, color: AppColors.green, size: 20),
          const SizedBox(width: 4),
          Text(
            '${QuizProgress.correct}',
            style: const TextStyle(fontFamily: 'Digital', fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

/// The question in a pink speech bubble, optionally with a picture.
class QuestionBubble extends StatelessWidget {
  const QuestionBubble({super.key, required this.text, this.image});
  final String text;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: quizPinkLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: quizPinkBorder, width: 2),
      ),
      child: Row(
        children: [
          if (image != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(image!, height: 64, width: 64, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              text,
              textAlign: image == null ? TextAlign.center : TextAlign.start,
              style: const TextStyle(color: quizPink, fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

enum AnswerState { idle, correct, wrong, reveal, dimmed }

/// One answer: text and/or picture. Bounces green when right, shakes red when
/// wrong; the right answer is then revealed so the child learns it.
class AnswerTile extends StatelessWidget {
  const AnswerTile({
    super.key,
    required this.state,
    required this.onTap,
    this.text,
    this.image,
  });

  final AnswerState state;
  final VoidCallback? onTap;
  final String? text;
  final String? image;

  @override
  Widget build(BuildContext context) {
    final (border, fill) = switch (state) {
      AnswerState.correct || AnswerState.reveal => (AppColors.green, const Color(0xFFE8FFD6)),
      AnswerState.wrong => (Colors.redAccent, const Color(0xFFFFE3E3)),
      _ => (quizPinkBorder, Colors.white),
    };
    final tile = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border, width: state == AnswerState.idle ? 2 : 4),
        boxShadow: [
          BoxShadow(
            color: Color.lerp(border, Colors.black, 0.25)!.withValues(alpha: 0.6),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (image != null)
                  Expanded(child: Image.asset(image!, fit: BoxFit.contain)),
                if (text != null && text!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: image != null ? 4 : 0),
                    child: Text(
                      text!,
                      textAlign: TextAlign.center,
                      maxLines: image != null ? 2 : 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: quizPink,
                        fontSize: image != null ? 13 : 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (state == AnswerState.correct || state == AnswerState.wrong)
            Positioned(
              right: -14,
              bottom: -14,
              child: Image.asset(
                state == AnswerState.correct ? "assets/images/juste.png" : "assets/images/faux.png",
                height: 34,
              ),
            ),
        ],
      ),
    );

    return Pressable(
      onTap: onTap,
      semanticLabel: text,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: state == AnswerState.dimmed ? 0.45 : 1,
        child: TweenAnimationBuilder<double>(
          key: ValueKey(state),
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          builder: (context, t, child) {
            if (state == AnswerState.correct) {
              return Transform.scale(scale: 1 + 0.08 * math.sin(math.pi * t), child: child);
            }
            if (state == AnswerState.wrong) {
              return Transform.translate(
                offset: Offset(math.sin(t * math.pi * 6) * 8 * (1 - t), 0),
                child: child,
              );
            }
            return child!;
          },
          child: tile,
        ),
      ),
    );
  }
}

/// Answer handling shared by the quiz screens: locks after the first tap,
/// plays feedback, counts correct answers and returns to the level screen.
mixin QuizAnswerLogic<T extends StatefulWidget> on State<T> {
  AudioPlayer get quizPlayer;
  int get correctAnswer;

  int? chosen;

  bool get answered => chosen != null;

  AnswerState stateOf(int answer) {
    if (!answered) return AnswerState.idle;
    if (answer == chosen) return answer == correctAnswer ? AnswerState.correct : AnswerState.wrong;
    if (answer == correctAnswer) return AnswerState.reveal;
    return AnswerState.dimmed;
  }

  VoidCallback? onAnswer(int answer) => answered ? null : () => _answer(answer);

  Future<void> _answer(int answer) async {
    final correct = answer == correctAnswer;
    setState(() => chosen = answer);
    if (correct) {
      QuizProgress.correct++;
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.heavyImpact();
    }
    await quizPlayer.stop();
    quizPlayer.play(AssetSource(correct ? 'music/correct.mp3' : 'music/wrong.mp3'),
        volume: globalVolumeSoundSettings);
    // A little longer after a mistake so the revealed answer can be read.
    await Future.delayed(Duration(milliseconds: correct ? 1100 : 1800));
    if (mounted) Navigator.pop(context, false);
  }

  /// Leaves the question and restarts the level from its first question.
  void restartLevel() => Navigator.pop(context, true);
}

/// Hint page: the clue text with its narration.
Future<void> showQuizHint(BuildContext context, {required String text, required String soundPath}) {
  return showDialog(
    context: context,
    builder: (dialogContext) => _HintDialog(text: text, soundPath: soundPath),
  );
}

class _HintDialog extends StatefulWidget {
  const _HintDialog({required this.text, required this.soundPath});
  final String text;
  final String soundPath;

  @override
  State<_HintDialog> createState() => _HintDialogState();
}

class _HintDialogState extends State<_HintDialog> {
  final _player = AppAudio.create();

  @override
  void initState() {
    super.initState();
    _player.play(AssetSource(widget.soundPath), volume: globalVolumeSoundSettings);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lightbulb_rounded, color: AppColors.darkBeige, size: 30),
                  SizedBox(width: 8),
                  Text('Indice', style: TextStyle(fontFamily: 'Digital', fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 18, 2, 81)),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundIconButton(
                    icon: Icons.volume_up_rounded,
                    color: AppColors.darkBeige,
                    tooltip: 'Écouter',
                    onTap: () {
                      _player.stop();
                      _player.play(AssetSource(widget.soundPath), volume: globalVolumeSoundSettings);
                    },
                  ),
                  const SizedBox(width: 16),
                  AppButton(
                    label: 'OK',
                    icon: Icons.check_rounded,
                    color: AppColors.green,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
