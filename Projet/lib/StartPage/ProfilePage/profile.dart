import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sorttrash/player_box.dart';

import '../../BackEnd/PlayerProgress/player.dart';
import '../../composents/app_theme.dart';
import '../../composents/level_select.dart';
import '../../composents/navigation.dart';
import '../../composents/ui/app_button.dart';
import '../../composents/ui/pressable.dart';
import '../../pages/trophies_page.dart';
import '../choose_children/profile_widgets.dart';
import 'no_player_page.dart';

const _levelsPerGame = 5;
const _challengeCount = 24;

/// Thresholds of keys that unlock the six stories.
const _storyKeys = [1, 5, 10, 14, 19, 24];

/// The child's profile: who they are and how far they got in every activity.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final player = currentPlayer();
    if (player == null) return const NoPlayerSelectedPage();

    final keys = '1'.allMatches(player.gamesData[GameProgressSlot.challenges].levelsCompleted).length;
    final trophies = trophyCount();
    final stories = _storyKeys.where((needed) => keys >= needed).length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/bg-image2.png'), fit: BoxFit.cover),
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
                      color: AppColors.darkBeige,
                      tooltip: 'Retour',
                      onTap: () => goBack(context, '/'),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
                  child: Row(
                    children: [
                      SizedBox(width: 230, child: _IdentityCard(player: player)),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  _GameCard(
                                    label: 'Puzzle',
                                    icon: Icons.extension_rounded,
                                    color: AppColors.lightPurple,
                                    done: completedLevelCount(GameProgressSlot.puzzle, _levelsPerGame),
                                    total: _levelsPerGame,
                                  ),
                                  const SizedBox(width: 12),
                                  _GameCard(
                                    label: 'Tri',
                                    icon: Icons.recycling_rounded,
                                    color: AppColors.green,
                                    done: completedLevelCount(GameProgressSlot.sort, _levelsPerGame),
                                    total: _levelsPerGame,
                                  ),
                                  const SizedBox(width: 12),
                                  _GameCard(
                                    label: 'Quiz',
                                    icon: Icons.quiz_rounded,
                                    color: AppColors.lightBlue,
                                    done: completedLevelCount(GameProgressSlot.quiz, _levelsPerGame),
                                    total: _levelsPerGame,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _StatChip(
                                  image: 'assets/images/gold_key.png',
                                  label: 'Défis',
                                  value: '$keys/$_challengeCount',
                                ),
                                const SizedBox(width: 12),
                                _StatChip(
                                  icon: Icons.emoji_events_rounded,
                                  label: 'Trophées',
                                  value: '${trophies.won}/${trophies.total}',
                                  onTap: () => Navigator.pushNamed(context, '/TrophiesPage'),
                                ),
                                const SizedBox(width: 12),
                                _StatChip(
                                  icon: Icons.menu_book_rounded,
                                  label: 'Histoires',
                                  value: '$stories/${_storyKeys.length}',
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
            ],
          ),
        ),
      ),
    );
  }
}

/// Avatar, name, coins, and the account actions.
class _IdentityCard extends StatelessWidget {
  const _IdentityCard({required this.player});
  final PlayerProgress player;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.darkBeige, width: 4),
        boxShadow: [BoxShadow(color: Color.lerp(AppColors.darkBeige, Colors.black, 0.3)!, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Expanded(
            child: FittedBox(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppColors.darkBeige, shape: BoxShape.circle),
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: Colors.white,
                      child: ClipOval(child: Image.asset(avatarAsset(player), width: 86, height: 86)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    player.childsName ?? '',
                    style: const TextStyle(fontFamily: 'Digital', fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4C2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/coin_img.png', height: 22),
                        const SizedBox(width: 6),
                        Text(
                          '${player.score}',
                          style: const TextStyle(fontFamily: 'Digital', fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          AppButton(
            label: 'Changer',
            icon: Icons.swap_horiz_rounded,
            color: AppColors.lightBlue,
            fontSize: 15,
            expand: true,
            onTap: () => Navigator.pushNamed(context, '/ChildSelector'),
          ),
          if (user != null) ...[
            const SizedBox(height: 8),
            AppButton(
              label: 'Déconnexion',
              icon: Icons.logout_rounded,
              color: Colors.redAccent,
              fontSize: 15,
              expand: true,
              onTap: () async {
                final navigator = Navigator.of(context);
                await FirebaseAuth.instance.signOut();
                onlineGlobalChildKey = -1;
                playersOnline = [];
                currentProfileIndex = 1;
                navigator.pushNamedAndRemoveUntil('/StartPage', (route) => false);
              },
            ),
          ],
        ],
      ),
    );
  }
}

/// Levels finished in one game, as a ring.
class _GameCard extends StatelessWidget {
  const _GameCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.done,
    required this.total,
  });

  final String label;
  final IconData icon;
  final Color color;
  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: color, width: 4),
          boxShadow: [BoxShadow(color: Color.lerp(color, Colors.black, 0.3)!, offset: const Offset(0, 5))],
        ),
        child: LayoutBuilder(builder: (context, c) {
          final radius = (c.maxHeight - 34).clamp(30.0, c.maxWidth) / 2;
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 6),
                  Text(label, style: const TextStyle(fontFamily: 'Digital', fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const Spacer(),
              CircularPercentIndicator(
                radius: radius,
                lineWidth: 10,
                percent: (done / total).clamp(0.0, 1.0),
                animation: true,
                animationDuration: 900,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: color,
                backgroundColor: color.withValues(alpha: 0.18),
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$done/$total',
                        style: const TextStyle(fontFamily: 'Digital', fontSize: 22, fontWeight: FontWeight.bold)),
                    const Text('niveaux', style: TextStyle(fontFamily: 'Digital', fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
              const Spacer(),
            ],
          );
        }),
      ),
    );
  }
}

/// A small counter (keys, trophies, stories); optionally tappable.
class _StatChip extends StatelessWidget {
  const _StatChip({this.icon, this.image, required this.label, required this.value, this.onTap});
  final IconData? icon;
  final String? image;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          image != null ? Image.asset(image!, height: 24) : Icon(icon, color: AppColors.darkBeige, size: 26),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontFamily: 'Digital', fontSize: 16, color: Colors.black54)),
          ),
          Text(value, style: const TextStyle(fontFamily: 'Digital', fontSize: 18, fontWeight: FontWeight.bold)),
          if (onTap != null) const Icon(Icons.chevron_right_rounded, color: Colors.black38),
        ],
      ),
    );
    return Expanded(child: onTap == null ? chip : Pressable(onTap: onTap, semanticLabel: label, child: chip));
  }
}
