import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../composents/app_audio.dart';
import '../composents/app_theme.dart';
import '../composents/ui/app_button.dart';
import '../player_box.dart';
import 'key_container.dart';

/// Shows challenge [number] (1-based) with its narration. The narration stops
/// when the dialog closes.
Future<void> showChallengeDialog(BuildContext context, {required int number, required String text}) {
  return showDialog(
    context: context,
    builder: (context) => _ChallengeDialog(number: number, text: text),
  );
}

class _ChallengeDialog extends StatefulWidget {
  const _ChallengeDialog({required this.number, required this.text});
  final int number;
  final String text;

  @override
  State<_ChallengeDialog> createState() => _ChallengeDialogState();
}

class _ChallengeDialogState extends State<_ChallengeDialog> {
  final _player = AppAudio.create();

  @override
  void initState() {
    super.initState();
    _play();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _play() {
    _player.stop();
    _player.play(AssetSource('music/D${widget.number}.m4a'), volume: globalVolumeSoundSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Row(
            children: [
              Container(
                width: 96,
                height: 96,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: pm,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const [BoxShadow(color: sm1, offset: Offset(0, 6))],
                ),
                child: Image.asset('assets/images/gold_key.png'),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Défi n°${widget.number}',
                      style: const TextStyle(
                        fontFamily: 'Digital',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: sm,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      readableChallengeText(widget.text),
                      style: const TextStyle(fontSize: 18, height: 1.3, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        RoundIconButton(
                          icon: Icons.volume_up_rounded,
                          color: AppColors.darkBeige,
                          tooltip: 'Écouter',
                          onTap: _play,
                        ),
                        const SizedBox(width: 16),
                        AppButton(
                          label: "C'est parti !",
                          icon: Icons.check_rounded,
                          color: AppColors.green,
                          onTap: () => Navigator.pop(context),
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
    );
  }
}

/// Several challenges are written in capitals with doubled spaces; show them
/// as normal sentences so children can read them.
String readableChallengeText(String text) {
  var result = text.trim().replaceAll(RegExp(r'\s+'), ' ');
  final letters = result.replaceAll(RegExp(r'[^A-Za-zÀ-ÿ]'), '');
  final upper = letters.replaceAll(RegExp(r'[^A-ZÀ-Þ]'), '');
  if (letters.isNotEmpty && upper.length / letters.length > 0.6) {
    result = result.toLowerCase();
  }
  if (result.isEmpty) return result;
  return result[0].toUpperCase() + result.substring(1);
}
