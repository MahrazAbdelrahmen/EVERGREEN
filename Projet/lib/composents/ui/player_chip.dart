import 'package:flutter/material.dart';

import '../../StartPage/choose_children/profile_widgets.dart';
import '../level_select.dart';
import 'pressable.dart';

/// Avatar, name and coins of the child playing. Opens their profile.
class PlayerChip extends StatelessWidget {
  const PlayerChip({super.key});

  @override
  Widget build(BuildContext context) {
    final player = currentPlayer();
    if (player == null) return const SizedBox.shrink();
    return Pressable(
      onTap: () => Navigator.pushNamed(context, '/ProfilePage'),
      semanticLabel: 'Profil de ${player.childsName ?? ''}',
      child: Container(
        height: 46,
        padding: const EdgeInsets.fromLTRB(4, 4, 14, 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(23),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 19,
              backgroundColor: Colors.grey.shade200,
              child: ClipOval(child: Image.asset(avatarAsset(player), width: 36, height: 36)),
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 120),
              child: Text(
                player.childsName ?? '',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontFamily: 'Digital', fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            Image.asset('assets/images/coin_img.png', height: 20),
            const SizedBox(width: 4),
            Text(
              '${player.score}',
              style: const TextStyle(fontFamily: 'Digital', fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
