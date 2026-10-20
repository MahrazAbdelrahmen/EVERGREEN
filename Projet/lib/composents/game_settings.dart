import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'navigation.dart';
import 'ui/app_button.dart';

/// Pause button shown in games. Opens a pause menu to resume, replay or quit.
class GamesSettings extends StatelessWidget {
  const GamesSettings(
      {super.key,
      required this.functionToBeUsed,
      required this.functionToResumeTimer,
      required this.functionToStopTimer});
  final void Function() functionToBeUsed;
  final void Function() functionToStopTimer;
  final void Function() functionToResumeTimer;

  @override
  Widget build(BuildContext context) {
    return RoundIconButton(
      icon: Icons.pause_rounded,
      color: AppColors.green,
      tooltip: 'Pause',
      onTap: () {
        functionToStopTimer();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => PopScope(
            canPop: false,
            child: Dialog(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Pause',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Digital',
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        label: 'Reprendre',
                        icon: Icons.play_arrow_rounded,
                        color: AppColors.green,
                        expand: true,
                        onTap: () {
                          functionToResumeTimer();
                          Navigator.pop(dialogContext);
                        },
                      ),
                      const SizedBox(height: 12),
                      AppButton(
                        label: 'Rejouer',
                        icon: Icons.replay_rounded,
                        color: AppColors.lightBlue,
                        expand: true,
                        onTap: () {
                          functionToResumeTimer();
                          Navigator.pop(dialogContext);
                          functionToBeUsed();
                        },
                      ),
                      const SizedBox(height: 12),
                      AppButton(
                        label: 'Quitter',
                        icon: Icons.logout_rounded,
                        color: Colors.redAccent,
                        expand: true,
                        onTap: () => backToRoute(dialogContext, '/games'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton(
      {super.key,
      required this.color,
      required this.text,
      required this.functionToBeUsed});
  final Color color;
  final String text;
  final void Function() functionToBeUsed;
  @override
  Widget build(BuildContext context) {
    return AppButton(label: text, color: color, onTap: functionToBeUsed, fontSize: 15);
  }
}
