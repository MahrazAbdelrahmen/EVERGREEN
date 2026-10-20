import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sorttrash/histoires/storydesign.dart';
import 'package:video_player/video_player.dart';

import '../StartPage/settings.dart';
import '../composents/app_theme.dart';
import '../composents/floating_snackbar.dart';
import '../composents/level_select.dart';
import '../composents/ui/app_button.dart';
import '../composents/ui/pressable.dart';

/// One book on the stories shelf.
class _StoryBook {
  const _StoryBook({
    required this.title,
    required this.keysNeeded,
    required this.openImage,
    required this.closedImage,
    required this.isVideo,
    required this.build,
  });

  final String title;
  final int keysNeeded;
  final String openImage;
  final String closedImage;
  final bool isVideo;
  final WidgetBuilder build;
}

final _nemo = storyDesign(storys: [
  Histoire(
      text:
          "Nemo, un petit poisson-clown, et ses amis Dory, une demoiselle bleue étourdie, et Marlin, le père protecteur de Nemo, vivent au milieu des coraux dans l'océan. Ils jouent et s'amusent, heureux de leur vie sous-marine.",
      picture: "assets/images/storys/nemo1.png",
      SoundPath: "music/histoires/story1/chap1Nemo.m4a"),
  Histoire(
      text:
          "Nemo et ses amis vivaient heureux dans les coraux de l'océan. Chaque jour, ils jouaient et s'amusaient dans leur petit paradis aquatique. Ils avaient toutes sortes de jeux et de divertissements, comme courir après les bulles, chasser les petits poissons, ou simplement se détendre en admirant la beauté des coraux.",
      picture: "assets/images/storys/nemo2.png",
      SoundPath: "music/histoires/story1/chap2Nemo.m4a"),
  Histoire(
      text:
          "Nemo et ses amis ont remarqué la présence de débris de plastique dans leur environnement de corail. Marlin, inquiet, a décidé d'enquêter pour découvrir d'où venait cette pollution. Avec l'aide de ses amis, ils ont suivi les débris de plastique et ont finalement atteint une grande usine sur le bord de l'océan, qui était la source de la pollution.",
      picture: "assets/images/storys/nemo3.png",
      SoundPath: "music/histoires/story1/chap3Nemo.m4a"),
  Histoire(
      text:
          "La première tentative de persuasion : Nemo et ses amis décident de parler à monsieur Philippe Sherman, le chef de l'usine, pour le convaincre de cesser de polluer la mer. Ils lui demandent d'arrêter, mais pour l'usine, jeter les déchets en mer est la solution la moins coûteuse. Philippe refuse.",
      picture: "assets/images/storys/nemo4.png",
      SoundPath: "music/histoires/story1/chap4Nemo.m4a"),
  Histoire(
      text:
          "La deuxième tentative de persuasion : Nemo et ses amis décident d'essayer une approche différente. Ils suggèrent à Philippe de recycler les déchets au lieu de les jeter en mer. Mais il refuse à cause du coût trop élevé.",
      picture: "assets/images/storys/nemo5.png",
      SoundPath: "music/histoires/story1/chap5Nemo.m4a"),
  Histoire(
      text:
          "La troisième tentative de persuasion : Nemo et ses amis décident de montrer l'impact de ses actions à Philippe en lui ramenant des jarres d'eau polluée extraite de leur habitat. Il est choqué de voir l'étendue de la pollution et réalise l'importance de protéger l'environnement.",
      picture: "assets/images/storys/nemo6.png",
      SoundPath: "music/histoires/story1/chap6Nemo.m4a"),
  Histoire(
      text:
          "La prise de conscience : Philippe Sherman réalise qu'il a fait une erreur en polluant la mer. Il décide qu'il doit changer ses méthodes et faire sa part pour protéger l'environnement.",
      picture: "assets/images/storys/nemo7.png",
      SoundPath: "music/histoires/story1/chap7Nemo.m4a"),
  Histoire(
      text:
          "Philippe Sherman met en place de nouvelles pratiques pour recycler les déchets de son usine et éviter de polluer la mer. Nemo revient à l'océan pour annoncer la bonne nouvelle à ses amis.",
      picture: "assets/images/storys/nemo8.png",
      SoundPath: "music/histoires/story1/chap8Nemo.m4a"),
  Histoire(
      text:
          "La célébration de la victoire : Nemo et ses amis célèbrent leur victoire avec tous les animaux de l'océan. Ils sont heureux de voir que leur habitat est plus propre et plus sûr grâce à leur détermination à protéger l'environnement.",
      picture: "assets/images/storys/nemo9.png",
      SoundPath: "music/histoires/story1/chap9Nemo.m4a"),
]);

final _shelf = <_StoryBook>[
  _StoryBook(
    title: 'Nemo et la mer',
    keysNeeded: 1,
    openImage: 'assets/images/book1.png',
    closedImage: 'assets/images/book1closed.png',
    isVideo: false,
    build: (_) => _nemo,
  ),
  for (final (i, keys) in [(1, 5), (2, 10), (3, 14), (4, 19), (5, 24)])
    _StoryBook(
      title: 'Histoire ${i + 1}',
      keysNeeded: keys,
      openImage: 'assets/images/book${i + 1}open.png',
      closedImage: 'assets/images/book${i + 1}.png',
      isVideo: true,
      build: (_) => VideoPlayerWidget(videoPath: 'assets/Videos/video$i.mp4'),
    ),
];

/// The stories shelf: books unlock with the keys earned in the challenges.
class levelsStory extends StatefulWidget {
  /// Keys to use when no child profile is selected.
  final int nbrKeys;

  const levelsStory({
    super.key,
    required this.nbrKeys,
  });

  @override
  State<levelsStory> createState() => _levelsStoryState();
}

class _levelsStoryState extends State<levelsStory> {
  @override
  void initState() {
    super.initState();
    globalMusicPlayerStartPage.stop();
  }

  int get _keys {
    final progress = currentPlayer()?.gamesData[GameProgressSlot.challenges].levelsCompleted;
    return progress == null ? widget.nbrKeys : '1'.allMatches(progress).length;
  }

  @override
  Widget build(BuildContext context) {
    final keys = _keys;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/bg-image.png'), fit: BoxFit.cover),
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
                      tooltip: 'Menu',
                      onTap: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    _ShelfTitle(keys: keys),
                    const Spacer(),
                    const SizedBox(width: 44),
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  const columns = 3;
                  const gap = 18.0;
                  final cardHeight = (constraints.maxHeight - 32 - gap) / 2;
                  final cardWidth = math.min(
                    (constraints.maxWidth - 64 - gap * (columns - 1)) / columns,
                    cardHeight * 1.5,
                  );
                  return Center(
                    child: Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      alignment: WrapAlignment.center,
                      children: [
                        for (final book in _shelf)
                          SizedBox(
                            width: cardWidth,
                            height: cardHeight,
                            child: _BookCard(
                              book: book,
                              unlocked: keys >= book.keysNeeded,
                              keys: keys,
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShelfTitle extends StatelessWidget {
  const _ShelfTitle({required this.keys});
  final int keys;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 4, 8, 4),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [BoxShadow(color: Color.lerp(AppColors.lightBlue, Colors.black, 0.3)!, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'HISTOIRES',
            style: TextStyle(
              fontFamily: 'Digital',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2))],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/gold_key.png', height: 20),
                const SizedBox(width: 4),
                Text('$keys',
                    style: const TextStyle(fontFamily: 'Digital', fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A book on the shelf: open and inviting once unlocked, closed with the keys
/// it needs otherwise (and a wobble when tapped).
class _BookCard extends StatefulWidget {
  const _BookCard({required this.book, required this.unlocked, required this.keys});
  final _StoryBook book;
  final bool unlocked;
  final int keys;

  @override
  State<_BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<_BookCard> with SingleTickerProviderStateMixin {
  late final _wobble = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));

  @override
  void dispose() {
    _wobble.dispose();
    super.dispose();
  }

  void _open() {
    final book = widget.book;
    if (!widget.unlocked) {
      HapticFeedback.heavyImpact();
      _wobble.forward(from: 0);
      final missing = book.keysNeeded - widget.keys;
      FloatingSnackBar(
        message: '🔑 Encore $missing clé${missing > 1 ? 's' : ''} ! Relève les défis pour en gagner.',
        context: context,
        duration: const Duration(milliseconds: 2200),
        backgroundColor: Colors.deepPurple,
      );
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: book.build));
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final unlocked = widget.unlocked;
    return Pressable(
      onTap: _open,
      semanticLabel: '${book.title}${unlocked ? '' : ', verrouillé'}',
      child: AnimatedBuilder(
        animation: _wobble,
        builder: (context, child) => Transform.rotate(
          angle: math.sin(_wobble.value * math.pi * 5) * 0.06 * (1 - _wobble.value),
          child: child,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: unlocked ? 0.95 : 0.75),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: unlocked ? AppColors.lightBlue : Colors.white, width: 3),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  Expanded(
                    child: Opacity(
                      opacity: unlocked ? 1 : 0.6,
                      child: Image.asset(unlocked ? book.openImage : book.closedImage, fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Digital',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: unlocked ? Colors.black87 : Colors.black45,
                    ),
                  ),
                ],
              ),
              // 📖 story or ▶ video.
              Positioned(
                top: -2,
                left: -2,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: unlocked ? AppColors.lightBlue : Colors.blueGrey.shade200,
                  child: Icon(
                    book.isVideo ? Icons.play_arrow_rounded : Icons.menu_book_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              if (!unlocked)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_rounded, color: Colors.white, size: 14),
                        const SizedBox(width: 3),
                        Image.asset('assets/images/gold_key.png', height: 14),
                        const SizedBox(width: 2),
                        Text(
                          '${book.keysNeeded}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Digital',
                            fontWeight: FontWeight.bold,
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

/// Full-screen story video: tap to pause, a progress bar, and Rejouer /
/// Terminé at the end.
class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const VideoPlayerWidget({super.key, required this.videoPath});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final VideoPlayerController _video = VideoPlayerController.asset(widget.videoPath);
  bool _ready = false;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    globalMusicPlayerStartPage.stop();
    _video.addListener(_onVideoChanged);
    _video.initialize().then((_) {
      if (!mounted) return;
      setState(() => _ready = true);
      _video.play();
    });
  }

  void _onVideoChanged() {
    final value = _video.value;
    final finished = value.isInitialized &&
        value.duration > Duration.zero &&
        value.position >= value.duration &&
        !value.isPlaying;
    // Rebuild on every tick too, so the play / pause sign stays in sync.
    if (mounted) setState(() => _finished = finished);
  }

  @override
  void dispose() {
    _video.removeListener(_onVideoChanged);
    _video.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (!_ready || _finished) return;
    HapticFeedback.selectionClick();
    _video.value.isPlaying ? _video.pause() : _video.play();
  }

  void _replay() {
    _video.seekTo(Duration.zero);
    _video.play();
  }

  @override
  Widget build(BuildContext context) {
    final playing = _video.value.isPlaying;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _togglePlay,
              child: Center(
                child: _ready
                    ? AspectRatio(aspectRatio: _video.value.aspectRatio, child: VideoPlayer(_video))
                    : const CircularProgressIndicator(color: Colors.white),
              ),
            ),
          ),
          // Big play sign while paused.
          if (_ready && !playing && !_finished)
            IgnorePointer(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 64),
                ),
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RoundIconButton(
                    icon: Icons.close_rounded,
                    color: Colors.redAccent,
                    tooltip: 'Fermer',
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  if (_ready)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: VideoProgressIndicator(
                        _video,
                        allowScrubbing: true,
                        padding: EdgeInsets.zero,
                        colors: const VideoProgressColors(
                          playedColor: AppColors.lightBlue,
                          bufferedColor: Colors.white38,
                          backgroundColor: Colors.white24,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_finished)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black54,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton(
                        label: 'Rejouer',
                        icon: Icons.replay_rounded,
                        color: AppColors.lightPurple,
                        onTap: _replay,
                      ),
                      const SizedBox(width: 16),
                      AppButton(
                        label: 'Terminé',
                        icon: Icons.check_rounded,
                        color: AppColors.green,
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
