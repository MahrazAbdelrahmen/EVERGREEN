import 'package:sorttrash/composents/app_audio.dart';
import 'package:flutter/material.dart';
import 'package:sorttrash/StartPage/Silder.dart';
import 'package:sorttrash/player_box.dart';

import '../composents/app_theme.dart';
import '../composents/ui/app_button.dart';

final globalMusicPlayerStartPage = AppAudio.create();
final globalSoundPlayerStartPage = AppAudio.create();

/// Settings button for players who are not logged in.
class RoundButtonSettings extends StatelessWidget {
  final IconData myIcon;
  final SetVolumeFunction volumeSettingsFunction;
  final SetVolumeFunction volumeSettingsSoundFunction;
  final double value;
  final String href;
  const RoundButtonSettings(
      {super.key,
      required this.myIcon,
      required this.value,
      required this.volumeSettingsFunction,
      required this.volumeSettingsSoundFunction,
      required this.href});
  @override
  Widget build(BuildContext context) {
    return _SettingsButton(
      icon: myIcon,
      volumeSettingsFunction: volumeSettingsFunction,
      volumeSettingsSoundFunction: volumeSettingsSoundFunction,
      actionLabel: 'Se connecter',
      actionIcon: Icons.login_rounded,
      onAction: (context) => Navigator.popAndPushNamed(context, '/LoginPage'),
    );
  }
}

/// Settings button for logged-in players: links to their profile.
class RoundButtonSettingsWhileLogged extends StatelessWidget {
  final IconData myIcon;
  final double value;
  final SetVolumeFunction volumeSettingsFunction;
  final SetVolumeFunction volumeSettingsSoundFunction;
  final String href;
  const RoundButtonSettingsWhileLogged(
      {super.key,
      required this.myIcon,
      required this.value,
      required this.volumeSettingsFunction,
      required this.volumeSettingsSoundFunction,
      required this.href});
  @override
  Widget build(BuildContext context) {
    return _SettingsButton(
      icon: myIcon,
      volumeSettingsFunction: volumeSettingsFunction,
      volumeSettingsSoundFunction: volumeSettingsSoundFunction,
      actionLabel: 'Profil',
      actionIcon: Icons.person_rounded,
      onAction: (context) => Navigator.popAndPushNamed(context, '/ProfilePage'),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({
    required this.icon,
    required this.volumeSettingsFunction,
    required this.volumeSettingsSoundFunction,
    required this.actionLabel,
    required this.actionIcon,
    required this.onAction,
  });

  final IconData icon;
  final SetVolumeFunction volumeSettingsFunction;
  final SetVolumeFunction volumeSettingsSoundFunction;
  final String actionLabel;
  final IconData actionIcon;
  final void Function(BuildContext context) onAction;

  @override
  Widget build(BuildContext context) {
    return RoundIconButton(
      icon: icon,
      color: AppColors.darkBeige,
      tooltip: 'Paramètres',
      onTap: () => showDialog(
        context: context,
        builder: (dialogContext) => Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Paramètres',
                          style: TextStyle(
                            fontFamily: 'Digital',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      RoundIconButton(
                        icon: Icons.close_rounded,
                        color: Colors.redAccent,
                        size: 36,
                        tooltip: 'Fermer',
                        onTap: () => Navigator.pop(dialogContext),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _VolumeRow(
                    icon: Icons.music_note_rounded,
                    label: 'Musique',
                    slider: SilderMusic(
                      value: globalVolumeMusicSettings,
                      changeVolume: (v) {
                        globalVolumeMusicSettings = v;
                        return volumeSettingsFunction(v);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  _VolumeRow(
                    icon: Icons.volume_up_rounded,
                    label: 'Sons',
                    slider: SilderMusic(
                      value: globalVolumeSoundSettings,
                      changeVolume: (v) {
                        globalVolumeSoundSettings = v;
                        return volumeSettingsSoundFunction(v);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _VolumeRow(
                    icon: Icons.language_rounded,
                    label: 'Langue',
                    slider: Align(
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        label: Text('Français',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        backgroundColor: AppColors.lightBlue,
                        side: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    label: actionLabel,
                    icon: actionIcon,
                    color: AppColors.lightBlue,
                    onTap: () => onAction(dialogContext),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VolumeRow extends StatelessWidget {
  const _VolumeRow({required this.icon, required this.label, required this.slider});

  final IconData icon;
  final String label;
  final Widget slider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.darkBeige),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: Text(label,
              style: const TextStyle(
                  fontFamily: 'Digital', fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Expanded(child: slider),
      ],
    );
  }
}
