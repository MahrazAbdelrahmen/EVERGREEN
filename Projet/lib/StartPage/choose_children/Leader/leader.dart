import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../composents/app_theme.dart';
import '../../../composents/ui/app_button.dart';

/// One child on the shared leaderboard (see firestore.rules).
class _Entry {
  _Entry.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc)
      : name = (doc.data()['name'] as String?) ?? '',
        score = (doc.data()['score'] as num?)?.toInt() ?? 0,
        avatar = (doc.data()['avatar'] as String?) ?? '',
        owner = (doc.data()['owner'] as String?) ?? '';

  final String name;
  final int score;
  final String avatar;
  final String owner;

  String get avatarAsset => avatar.startsWith('assets/') ? avatar : 'assets/profiles/0.png';
}

/// "Classement": a podium for the top three and the ranking below it.
class LeaderBoard extends StatefulWidget {
  const LeaderBoard({super.key});

  @override
  State<LeaderBoard> createState() => _LeaderBoard();
}

class _LeaderBoard extends State<LeaderBoard> {
  final User? user = FirebaseAuth.instance.currentUser;

  late final Stream<QuerySnapshot<Map<String, dynamic>>> _ranking = FirebaseFirestore.instance
      .collection('leaderboard')
      .orderBy('score', descending: true)
      .limit(50)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/bg-image2.png'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: user == null
              ? const Center(child: _SignInCard())
              : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _ranking,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: _MessageCard(
                          icon: Icons.cloud_off_rounded,
                          title: 'Classement indisponible',
                          text: 'Vérifie ta connexion internet et réessaie.',
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    }
                    final entries = snapshot.data!.docs.map(_Entry.fromDoc).toList();
                    if (entries.isEmpty) {
                      return const Center(
                        child: _MessageCard(
                          icon: Icons.emoji_events_rounded,
                          title: 'Personne pour l\'instant',
                          text: 'Joue pour être le premier du classement !',
                        ),
                      );
                    }
                    return _Ranking(entries: entries, myUid: user!.uid);
                  },
                ),
        ),
      ),
    );
  }
}

class _Ranking extends StatelessWidget {
  const _Ranking({required this.entries, required this.myUid});
  final List<_Entry> entries;
  final String myUid;

  @override
  Widget build(BuildContext context) {
    final top = entries.take(3).toList();
    final rest = entries.skip(3).toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              children: [
                const _Title(),
                const SizedBox(height: 8),
                Expanded(child: _Podium(top: top, myUid: myUid)),
              ],
            ),
          ),
          if (rest.isNotEmpty) ...[
            const SizedBox(width: 20),
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: rest.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (context, i) => _Row(rank: i + 4, entry: rest[i], mine: rest[i].owner == myUid),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.darkBeige,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [BoxShadow(color: Color.lerp(AppColors.darkBeige, Colors.black, 0.3)!, offset: const Offset(0, 4))],
      ),
      child: const Text(
        'CLASSEMENT',
        style: TextStyle(
          fontFamily: 'Digital',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2))],
        ),
      ),
    );
  }
}

/// The top three on a podium: 2nd · 1st · 3rd.
class _Podium extends StatelessWidget {
  const _Podium({required this.top, required this.myUid});
  final List<_Entry> top;
  final String myUid;

  static const _medals = [Color(0xFFFFC107), Color(0xFFB0BEC5), Color(0xFFCD7F32)];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final heights = [c.maxHeight * 0.42, c.maxHeight * 0.3, c.maxHeight * 0.22];
      Widget place(int rank) {
        if (rank >= top.length) return const Expanded(child: SizedBox());
        final entry = top[rank];
        final mine = entry.owner == myUid;
        return Expanded(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 500 + 200 * (2 - rank)),
            curve: Curves.easeOutBack,
            builder: (context, t, child) => Transform.translate(
              offset: Offset(0, (1 - t) * 60),
              child: Opacity(opacity: t.clamp(0.0, 1.0), child: child),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (rank == 0) const Icon(Icons.emoji_events_rounded, color: Color(0xFFFFC107), size: 30),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _medals[rank],
                    boxShadow: mine ? [const BoxShadow(color: AppColors.green, blurRadius: 10, spreadRadius: 2)] : null,
                  ),
                  child: CircleAvatar(
                    radius: rank == 0 ? 30 : 24,
                    backgroundColor: Colors.white,
                    child: ClipOval(child: Image.asset(entry.avatarAsset)),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  entry.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Digital',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                    shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
                    decoration: mine ? TextDecoration.underline : null,
                    decorationColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: heights[rank],
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: _medals[rank],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${rank + 1}',
                        style: const TextStyle(
                          fontFamily: 'Digital',
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Colors.white,
                          shadows: [Shadow(color: Colors.black38, offset: Offset(0, 2))],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/coin_img.png', height: 16),
                          const SizedBox(width: 3),
                          Text(
                            '${entry.score}',
                            style: const TextStyle(fontFamily: 'Digital', fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [place(1), place(0), place(2)],
      );
    });
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.rank, required this.entry, required this.mine});
  final int rank;
  final _Entry entry;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mine ? AppColors.green.withValues(alpha: 0.15) : null,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text('$rank', style: const TextStyle(fontFamily: 'Digital', fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey.shade200,
            child: ClipOval(child: Image.asset(entry.avatarAsset)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              entry.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: 'Digital', fontSize: 16, fontWeight: mine ? FontWeight.bold : null),
            ),
          ),
          Image.asset('assets/images/coin_img.png', height: 16),
          const SizedBox(width: 4),
          Text('${entry.score}', style: const TextStyle(fontFamily: 'Digital', fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _SignInCard extends StatelessWidget {
  const _SignInCard();

  @override
  Widget build(BuildContext context) {
    return _MessageCard(
      icon: Icons.leaderboard_rounded,
      title: 'Classement',
      text: 'Connecte-toi pour comparer ton score avec les autres joueurs.',
      action: AppButton(
        label: 'Se connecter',
        icon: Icons.login_rounded,
        color: AppColors.lightBlue,
        onTap: () => Navigator.pushNamed(context, '/LoginPage'),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.icon, required this.title, required this.text, this.action});
  final IconData icon;
  final String title;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: AppColors.darkBeige),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontFamily: 'Digital', fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Digital', color: Colors.black54)),
          if (action != null) ...[const SizedBox(height: 16), action!],
        ],
      ),
    );
  }
}
