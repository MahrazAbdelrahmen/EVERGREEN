import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../BackEnd/PlayerProgress/player.dart';
import '../../composents/app_theme.dart';
import '../../composents/ui/app_button.dart';
import '../../composents/ui/pressable.dart';

/// "Who's playing?" screen body shared by the online and offline tabs.
class ProfilePicker extends StatelessWidget {
  const ProfilePicker({
    super.key,
    required this.players,
    required this.selectedId,
    required this.onSelect,
    required this.onEdit,
    required this.onAdd,
    required this.onPlay,
  });

  final List<PlayerProgress> players;
  final int selectedId;
  final ValueChanged<PlayerProgress> onSelect;
  final ValueChanged<PlayerProgress> onEdit;
  final VoidCallback onAdd;
  final VoidCallback onPlay;

  PlayerProgress? get _selected {
    for (final p in players) {
      if (p.childID == selectedId) return p;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg-image2.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Row(
                children: [
                  RoundIconButton(
                    icon: Icons.home_rounded,
                    color: AppColors.green,
                    tooltip: 'Accueil',
                    onTap: () =>
                        Navigator.popAndPushNamed(context, '/StartPage'),
                  ),
                  const Expanded(
                    child: Text(
                      'Qui joue ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Digital',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 6)],
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),
            Expanded(
              child: players.isEmpty
                  ? Center(child: _EmptyProfiles(onAdd: onAdd))
                  : Center(
                      child: SizedBox(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          children: [
                            for (final p in players)
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: ProfileCard(
                                  key: ObjectKey(p),
                                  player: p,
                                  selected: p.childID == selectedId,
                                  onTap: () => onSelect(p),
                                  onEdit: () => onEdit(p),
                                ),
                              ),
                            _AddProfileCard(onTap: onAdd),
                          ],
                        ),
                      ),
                    ),
            ),
            if (players.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppButton(
                  label: selected == null
                      ? 'Choisis un profil'
                      : 'Jouer avec ${selected.childsName ?? ''}',
                  icon: Icons.play_arrow_rounded,
                  color: AppColors.green,
                  fontSize: 20,
                  onTap: selected == null ? null : onPlay,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A child's profile card. Its accent colour is picked at random once per visit.
class ProfileCard extends StatefulWidget {
  const ProfileCard({
    super.key,
    required this.player,
    required this.selected,
    required this.onTap,
    required this.onEdit,
  });

  final PlayerProgress player;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  final Color _color = Color(
    (math.Random().nextDouble() * 0xFFFFFF).toInt(),
  ).withValues(alpha: 1.0);

  @override
  Widget build(BuildContext context) {
    final p = widget.player;
    final selected = widget.selected;
    return Pressable(
      onTap: widget.onTap,
      semanticLabel: p.childsName,
      child: AnimatedScale(
        scale: selected ? 1.06 : 1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected ? AppColors.green : _color,
              width: selected ? 5 : 3,
            ),
            boxShadow: [
              BoxShadow(
                color: selected
                    ? AppColors.green.withValues(alpha: 0.6)
                    : Colors.black26,
                blurRadius: selected ? 16 : 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: _color,
                          child: ClipOval(
                            child: Image.asset(
                              avatarAsset(p),
                              height: 58,
                              width: 58,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 124),
                          child: Text(
                            p.childsName ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Digital',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/coin_img.png',
                              height: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${p.score}',
                              style: const TextStyle(
                                fontFamily: 'Digital',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          relativeTimeFr(p.lastTimeToJoin),
                          style: const TextStyle(
                            fontFamily: 'Digital',
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  tooltip: 'Modifier',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.edit_rounded,
                    size: 20,
                    color: Colors.black45,
                  ),
                  onPressed: widget.onEdit,
                ),
              ),
              if (selected)
                const Positioned(
                  top: 6,
                  left: 6,
                  child: CircleAvatar(
                    radius: 13,
                    backgroundColor: AppColors.green,
                    child: Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: Colors.white,
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

class _AddProfileCard extends StatelessWidget {
  const _AddProfileCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: 'Ajouter un profil',
      child: Container(
        width: 130,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.darkBeige,
              child: Icon(Icons.add_rounded, size: 36, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              'Ajouter',
              style: TextStyle(
                fontFamily: 'Digital',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyProfiles extends StatelessWidget {
  const _EmptyProfiles({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.child_care_rounded,
            size: 48,
            color: AppColors.lightBlue,
          ),
          const SizedBox(height: 8),
          const Text(
            'Aucun profil pour l\'instant',
            style: TextStyle(
              fontFamily: 'Digital',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Crée ton profil pour commencer à jouer !',
            style: TextStyle(fontFamily: 'Digital', color: Colors.black54),
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Créer un profil',
            icon: Icons.add_rounded,
            color: AppColors.darkBeige,
            onTap: onAdd,
          ),
        ],
      ),
    );
  }
}

/// Lets the parent rename or delete a profile. Deleting asks for confirmation.
Future<void> showEditProfileDialog(
  BuildContext context, {
  required PlayerProgress player,
  required ValueChanged<String> onRename,
  required VoidCallback onDelete,
}) {
  final controller = TextEditingController(text: player.childsName);
  return showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Modifier le profil'),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLength: 20,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(labelText: 'Nom', counterText: ''),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton.icon(
          style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
          icon: const Icon(Icons.delete_outline_rounded),
          label: const Text('Supprimer'),
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: dialogContext,
              builder: (confirmContext) => AlertDialog(
                title: const Text('Supprimer ce profil ?'),
                content: Text(
                  'La progression de ${player.childsName ?? 'cet enfant'} sera définitivement perdue.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(confirmContext, false),
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                    ),
                    onPressed: () => Navigator.pop(confirmContext, true),
                    child: const Text('Supprimer'),
                  ),
                ],
              ),
            );
            if (confirmed == true && dialogContext.mounted) {
              Navigator.pop(dialogContext);
              onDelete();
            }
          },
        ),
        FilledButton(
          onPressed: () {
            final name = controller.text.trim();
            if (name.isEmpty) return;
            Navigator.pop(dialogContext);
            onRename(name);
          },
          child: const Text('Enregistrer'),
        ),
      ],
    ),
  ).whenComplete(controller.dispose);
}

String avatarAsset(PlayerProgress player) {
  final name = player.avatarProfileName;
  return name != null && name.startsWith('assets/')
      ? name
      : 'assets/profiles/0.png';
}

/// "à l'instant", "il y a 5 min", "hier", ... for the last time a child played.
String relativeTimeFr(DateTime date, {DateTime? now}) {
  final diff = (now ?? DateTime.now()).difference(date);
  if (diff.inMinutes < 1) return 'Joué à l\'instant';
  if (diff.inHours < 1) return 'Joué il y a ${diff.inMinutes} min';
  if (diff.inDays < 1) return 'Joué il y a ${diff.inHours} h';
  if (diff.inDays == 1) return 'Joué hier';
  if (diff.inDays < 7) return 'Joué il y a ${diff.inDays} jours';
  String two(int n) => n.toString().padLeft(2, '0');
  return 'Joué le ${two(date.day)}/${two(date.month)}/${date.year}';
}
