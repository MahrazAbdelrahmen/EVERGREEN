import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:book_page_flip/book_page_flip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sorttrash/composents/app_audio.dart';

import '../StartPage/settings.dart';
import '../composents/app_theme.dart';
import '../composents/ui/app_button.dart';
import '../player_box.dart';

class Histoire {
  String text;
  String picture;
  String SoundPath;
  Histoire(
      {required this.text, required this.picture, required this.SoundPath});
}

/// An illustrated story read as a book: picture on the left, text on the
/// right, narration on every spread, turned with a 3D page curl.
class storyDesign extends StatefulWidget {
  final List<Histoire> storys;
  const storyDesign({super.key, required this.storys});
  @override
  State<storyDesign> createState() => _storyDesignState();
}

class _storyDesignState extends State<storyDesign> {
  static const _pageColor = Color(0xFFFFF8E7);
  static const _pageShade = Color(0xFFF1E3C0);
  static const _atlasLimit = 4096.0;

  final _player = AppAudio.create();
  final _controller = BookFlipController();
  int CurrentIndex = 0;
  bool _imagesReady = false;

  // Created once: the book re-captures (and resets to page 1) whenever it is
  // given a different builder, and a method tear-off is a new object each build.
  late final Widget Function(BuildContext, int) _pageBuilder = _page;

  @override
  void initState() {
    super.initState();
    globalMusicPlayerStartPage.stop();
    _play(0);
    // Pages are captured as images on their first frame: load the pictures first.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        for (final chapter in widget.storys) precacheImage(AssetImage(chapter.picture), context),
      ]);
      if (mounted) setState(() => _imagesReady = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _player.dispose();
    super.dispose();
  }

  void _play(int index) {
    _player.stop();
    _player.play(AssetSource(widget.storys[index].SoundPath), volume: globalVolumeSoundSettings);
  }

  void _onSpreadChanged(int spread) {
    setState(() => CurrentIndex = spread);
    _play(spread);
  }

  @override
  Widget build(BuildContext context) {
    final last = widget.storys.length - 1;
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
                      color: AppColors.green,
                      tooltip: 'Histoires',
                      onTap: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Chapitre ${CurrentIndex + 1} / ${widget.storys.length}',
                        style: const TextStyle(fontFamily: 'Digital', fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                    RoundIconButton(
                      icon: Icons.volume_up_rounded,
                      color: AppColors.darkBeige,
                      tooltip: 'Écouter',
                      onTap: () => _play(CurrentIndex),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Row(
                    children: [
                      _turnButton(Icons.chevron_left_rounded,
                          CurrentIndex > 0 ? () => _controller.previousSpread() : null),
                      const SizedBox(width: 8),
                      Expanded(child: LayoutBuilder(builder: (context, c) => _book(c.biggest))),
                      const SizedBox(width: 8),
                      _turnButton(Icons.chevron_right_rounded,
                          CurrentIndex < last ? () => _controller.nextSpread() : null),
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

  Widget _turnButton(IconData icon, VoidCallback? onTap) => AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: onTap == null ? 0.3 : 1,
        child: RoundIconButton(icon: icon, color: AppColors.lightBlue, size: 52, onTap: onTap),
      );

  Widget _book(Size area) {
    const spreadAspect = 1.55;
    final width = math.min(area.width, area.height * spreadAspect);
    final pageSize = Size((width / 2).floorToDouble(), (width / spreadAspect).floorToDouble());
    if (!_imagesReady || pageSize.isEmpty) return const SizedBox.shrink();

    final pageCount = widget.storys.length * 2;
    final columns = math.sqrt(pageCount).ceil();
    final rows = (pageCount / columns).ceil();
    final pixelRatio = math.min(
      MediaQuery.devicePixelRatioOf(context),
      math.min(_atlasLimit / columns / pageSize.width, _atlasLimit / rows / pageSize.height) * 0.98,
    );

    return Center(
      child: SizedBox(
        width: pageSize.width * 2,
        height: pageSize.height,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 14, offset: Offset(0, 6))],
          ),
          child: BookFlip.builder(
            key: ValueKey(pageSize),
            controller: _controller,
            pageCount: pageCount,
            pageSize: pageSize,
            pixelRatio: pixelRatio,
            curl: BookFlipCurl.gentle,
            onSpreadChanged: _onSpreadChanged,
            onFlipStart: (_, __) => HapticFeedback.selectionClick(),
            pageBuilder: _pageBuilder,
          ),
        ),
      ),
    );
  }

  /// Even pages hold the picture, odd pages the text of the same chapter.
  Widget _page(BuildContext context, int i) {
    final chapter = widget.storys[i ~/ 2];
    final left = i.isEven;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: left ? Alignment.centerLeft : Alignment.centerRight,
          end: left ? Alignment.centerRight : Alignment.centerLeft,
          colors: const [_pageColor, _pageColor, _pageShade],
          stops: const [0, 0.85, 1],
        ),
      ),
      child: Padding(
        padding: left ? const EdgeInsets.all(18) : const EdgeInsets.fromLTRB(18, 16, 22, 10),
        child: left
            ? Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(chapter.picture, fit: BoxFit.contain),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, c) => FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: c.maxWidth,
                          child: Text(
                            chapter.text,
                            style: const TextStyle(fontSize: 17, height: 1.35, color: Color(0xFF4E342E)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      i ~/ 2 == widget.storys.length - 1 ? 'Fin' : '${i ~/ 2 + 1}',
                      style: const TextStyle(fontFamily: 'Digital', fontWeight: FontWeight.bold, color: Colors.black45),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
