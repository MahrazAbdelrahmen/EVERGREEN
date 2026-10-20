import 'package:sorttrash/composents/app_audio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math' as math;

import 'package:book_page_flip/book_page_flip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../StartPage/settings.dart';
import '../composents/app_theme.dart';
import '../composents/ui/app_button.dart';
import '../composents/ui/pressable.dart';
import '../player_box.dart';

class advice {
  final String titre;
  final String contenu;
  final String SoundPath;
  advice({required this.titre, required this.contenu, required this.SoundPath});
}

class Conseils extends StatefulWidget {
  List<advice> cons = [
    advice(
      titre: "INTRODUCTION",
      contenu:
          "Bonjour à tous ! Je suis votre chère Terry, votre planète, votre maison. ",
      SoundPath: "music/Introduction1.m4a",
    ),
    advice(
        titre: "INTRODUCTION",
        SoundPath: "music/Introduction2.m4a",
        contenu:
            "Je suis ravie de vous parler aujourd'hui de quelque chose qui me tient particulièrement à cœur : le recyclage. "),
    advice(
        titre: "INTRODUCTION",
        SoundPath: "music/Introduction3.m4a",
        contenu:
            "Malheureusement, je souffre de plus en plus  chaque  jour à cause des  tonnes de déchets que vous produisez,  car ils polluent mes océans, mes rivières, mes forêts et mon air."),
    advice(
        titre: "INTRODUCTION",
        SoundPath: "music/Introduction4.m4a",
        contenu:
            "Je vous demande donc de faire un geste important pour moi : recycler."),
    advice(
        titre: "RECYCLAGE",
        SoundPath: "music/Recyclage.m4a",
        contenu:
            "Le recyclage est un moyen de réutiliser les choses que nous avons déjà utilisées afin que nous n'ayons pas à fabriquer de nouvelles choses à partir de zéro."),
    advice(
        titre: "TRI",
        SoundPath: "music/tri.m4a",
        contenu:
            "Maintenant ,On va ensemble apprendre comment trier et classer chaque déchet dans sa propre poubelle?"),
    advice(
        titre: "COMPOST",
        SoundPath: "music/COMPOST.m4a",
        contenu:
            "COULEUR DE POUBELLE: Gris\nSes déchets: déchets verts,restes de repas.\nIndication: Jette-les en vrac dans le composteur de ton jardin. Il y a aussi des composteurs à disposition dans ta ville !"),
    advice(
        titre: "PLASTIQUE",
        SoundPath: "music/PLASTIQUE.m4a",
        contenu:
            "COULEUR DE POUBELLE: Orange\nSes déchets: boîtes de conserve,bouteilles et flacons en plastique,sachets\nIndication :Jette-les en vrac, vidés de leur contenu,avec leurs bouchons."),
    advice(
        titre: "VERRE",
        SoundPath: "music/VERRE.m4a",
        contenu:
            "COULEUR DE POUBELLE: Vert\nSes déchets: bouteille, bocaux et flacons\nIndication: Jette-les en vrac, lavés, sans bouchon ou couvercle."),
    advice(
        titre: "PAPIER ET CARTON",
        SoundPath: "music/CARTON.m4a",
        contenu:
            "COULEUR DE POUBELLE: Bleu\nSes déchets: briques alimentaires et petits cartons,feuilles,magazines et journaux,livres,cahiers et enveloppes\nIndication :Jette-les en vrac, vidés de leur contenu,aplatis et compactés "),
    advice(
        titre: "METAL",
        SoundPath: "music/METAL.m4a",
        contenu:
            "COULEUR DE POUBELLE: Jaune\nSes déchets: barquettes en aluminium et emballages métalliques \nIndication: Jette-les en vrac, vidés de leur contenu,avec leurs bouchons."),
    advice(
        titre: "ELECTRONIQUE",
        SoundPath: "music/ELECTRONIQUE.m4a",
        contenu:
            "COULEUR DE POUBELLE: Rouge\nSes déchets: Lampes,calclatrice cassées,Micro-onde et PC."),

// advice(titre: titre,SoundPath: audio, contenu: contenu),
// advice(titre: titre,SoundPath: audio, contenu: contenu),
//Quoi recycler?
    advice(
        titre: "QUOI RECYCLER?",
        SoundPath: "music/QUOI1.m4a",
        contenu:
            "Recyclez du papier contenant des agrafes ou des enveloppes en plastique. Le métal et le plastique sont finalement triés."),
    advice(
        titre: "QUOI RECYCLER?",
        SoundPath: "music/QUOI2.m4a",
        contenu:
            "Recyclez les piles usagées en les déposant dans un point de collecte approprié. Ne les jetez jamais à la poubelle ordinaire."),
    advice(
        titre: "QUOI RECYCLER?",
        SoundPath: "music/QUOI3.m4a",
        contenu:
            "Recyclez les publicités non sollicitées. La plupart des adultes en reçoivent de grandes quantités chaque semaine et la plupart peuvent être recyclées."),
    advice(
        titre: "QUOI RECYCLER?",
        SoundPath: "music/QUOI4.m4a",
        contenu:
            "Retirez les bouchons de toutes les bouteilles en verre. Vérifiez également si votre communauté prend le verre des conteneurs de recyclage sur le trottoir."),
    advice(
        titre: "QUOI RECYCLER?",
        SoundPath: "music/QUOI5.m4a",
        contenu:
            "Rincez les canettes en aluminium et en acier pour les rendre plus faciles à traiter."),
    advice(
        titre: "QUOI RECYCLER?",
        SoundPath: "music/QUOI6.m4a",
        contenu: "Recyclez les aérosols vides et les cintres en métal."),
    advice(
        titre: "QUOI RECYCLER?",
        SoundPath: "music/QUOI7.m4a",
        contenu:
            "Recyclez les vieux appareils électroniques en les apportant dans un centre de recyclage. Cela permet de récupérer les matériaux précieux qu'ils contiennent."),
    advice(
        titre: "QUOI RECYCLER?",
        SoundPath: "music/QUOI8.m4a",
        contenu:
            "Recyclez les cartouches d'encre en les renvoyant au fabricant. Cela peut aider à réduire les déchets toxiques qui se retrouvent dans les décharges."),

//Pourquoi recycler?
    advice(
        titre: "POURQUOI ?",
        SoundPath: "music/POURQUOI1.m4a",
        contenu:
            "En recyclant, nous aidons à réduire la quantité de déchets que nous produisons et à garder notre planète propre."),
    advice(
        titre: "POURQUOI ?",
        SoundPath: "music/POURQUOI2.m4a",
        contenu:
            "Le recyclage peut économiser de l'énergie, de l'eau et des ressources naturelles qui seraient autrement utilisées pour créer de nouveaux produits."),
    advice(
        titre: "POURQUOI ?",
        SoundPath: "music/POURQUOI3.m4a",
        contenu:
            "En recyclant, nous pouvons réduire la quantité de pollution dans l'air, l'eau et le sol."),
    advice(
        titre: "POURQUOI ?",
        SoundPath: "music/POURQUOI4.m4a",
        contenu:
            "Grâce au tri, les déchets peuvent être recyclés et avoir une seconde vie."),
    advice(
        titre: "POURQUOI ?",
        SoundPath: "music/POURQUOI5.m4a",
        contenu:
            "En recyclant, vous faites votre part pour aider à protéger l'environnement pour les générations futures."),
    advice(
        titre: "POURQUOI ?",
        SoundPath: "music/POURQUOI6.m4a",
        contenu:
            "Le recyclage est facile et amusant ! Vous pouvez transformer les vieux objets en nouveaux objets et faire preuve de créativité avec vos projets d'art."),

//CONSEILS
    advice(
        titre: "CONSEIL 01",
        SoundPath: "music/CONSEIL1.m4a",
        contenu:
            "Faites attention aux symboles de recyclage sur les emballages. Ils vous indiquent quel type de matériau a été utilisé et s'il peut être recyclé."),
    advice(
        titre: "CONSEIL 02",
        SoundPath: "music/CONSEIL2.m4a",
        contenu:
            "Réduisez les déchets de nourriture en achetant seulement ce dont vous avez besoin et en utilisant les restes pour les repas suivants."),
    advice(
        titre: "CONSEIL 03",
        SoundPath: "music/CONSEIL3.m4a",
        contenu:
            "Évitez d'acheter des articles jetables pour les fêtes et les événements. Au lieu de cela, utilisez de la vaisselle et des serviettes réutilisables."),
    advice(
        titre: "CONSEIL 04",
        SoundPath: "music/CONSEIL4.m4a",
        contenu:
            "Séparez les couvercles et les bocaux, les cartons et les bouteilles afin que les conteneurs puissent être facilement écrasés lors du recyclage."),
    advice(
        titre: "CONSEIL 05",
        SoundPath: "music/CONSEIL5.m4a",
        contenu:
            "Séparez les déchets électroniques. La plupart peuvent être recyclés, mais ils doivent généralement être apportés à un centre de recyclage et non placés dans des conteneurs sur le trottoir."),
    advice(
        titre: "CONSEIL 06",
        SoundPath: "music/CONSEIL6.m4a",
        contenu:
            "Réutilisez les objets avant de les recycler. Par exemple, utilisez des bocaux vides comme contenants pour vos crayons ou utilisez des vieux vêtements pour faire des chiffons."),
    advice(
        titre: "CONSEIL 07",
        SoundPath: "music/CONSEIL7.m4a",
        contenu:
            "Évitez d'utiliser des produits jetables comme des couverts ou des pailles en plastique. Au lieu de cela, apportez vos propres objets réutilisables avec vous."),
    advice(
        titre: "CONSEIL 08",
        SoundPath: "music/CONSEIL8.m4a",
        contenu:
            "Assurez-vous de disposer correctement des matériaux dangereux tels que les batteries et les appareils électroniques. Ils nécessitent une manipulation spéciale pour éviter les dommages environnementaux."),
    advice(
        titre: "CONSEIL 09",
        SoundPath: "music/CONSEIL9.m4a",
        contenu:
            "Essayez d'acheter des produits fabriqués à partir de matériaux recyclés. Cela soutient l'industrie du recyclage et contribue à boucler la boucle."),
    advice(
        titre: "CONSEIL 10",
        SoundPath: "music/CONSEIL10.m4a",
        contenu:
            "Envisagez de composter les restes de nourriture et les déchets de jardin. Cela peut aider à réduire la quantité de déchets envoyés dans les décharges."),

//FIN
    advice(
        titre: "FIN",
        SoundPath: "music/FIN1.m4a",
        contenu:
            "Soyez un modèle pour les autres en recyclant régulièrement et en parlant des avantages du recyclage avec votre famille et vos amis."),
    advice(
        titre: "FIN",
        SoundPath: "music/FIN2.m4a",
        contenu:
            "Continuez à apprendre sur le recyclage et les problèmes environnementaux. Plus vous en savez, plus vous pouvez faire pour aider à protéger notre planète."),
    advice(
        titre: "FIN",
        SoundPath: "music/FIN3.m4a",
        contenu:
            "Rappelez-vous que le recyclage n'est qu'une partie de l'équation. Nous devons également chercher à réduire la quantité de déchets que nous produisons et réutiliser les objets chaque fois que possible."),
  ];
  int currentAdvice = 0;

  Conseils({super.key});
  @override
  State<Conseils> createState() => _ConseilsState();
}

/// A group of pages shown as a chip above the book.
class _Chapter {
  const _Chapter(this.label, this.color, this.titles);
  final String label;
  final Color color;
  final List<String> titles;

  bool contains(advice page) =>
      titles.any((t) => page.titre == t || (t.endsWith('*') && page.titre.startsWith(t.substring(0, t.length - 1))));
}

const _chapters = [
  _Chapter('Introduction', AppColors.lightBlue, ['INTRODUCTION']),
  _Chapter('Le tri', AppColors.green, ['RECYCLAGE', 'TRI']),
  _Chapter('Les poubelles', Color(0xFFFF9800), ['COMPOST', 'PLASTIQUE', 'VERRE', 'PAPIER ET CARTON', 'METAL', 'ELECTRONIQUE']),
  _Chapter('Quoi recycler ?', AppColors.lightPurple, ['QUOI RECYCLER?']),
  _Chapter('Pourquoi ?', Color(0xFF26A69A), ['POURQUOI ?']),
  _Chapter('Conseils', AppColors.darkBeige, ['CONSEIL*']),
  _Chapter('Fin', Color(0xFFEF5350), ['FIN']),
];

/// The illustration shown on the left page.
String _illustrationFor(advice page, int index) => switch (page.titre) {
      'COMPOST' => 'assets/images/graycan.png',
      'PLASTIQUE' => 'assets/images/orangecan.png',
      'VERRE' => 'assets/images/greencan.png',
      'PAPIER ET CARTON' => 'assets/images/bluecan.png',
      'METAL' => 'assets/images/metal.png',
      'ELECTRONIQUE' => 'assets/images/ewaste.png',
      _ => index.isEven ? 'assets/images/logo1.png' : 'assets/images/logo2.png',
    };

class _ConseilsState extends State<Conseils> {
  static const _pageColor = Color(0xFFF0FCFF);
  static const _pageShade = Color(0xFFD9EEF2);

  /// Largest texture the page curl packs a chapter's pages into.
  static const _atlasLimit = 4096.0;

  final _player = AppAudio.create();
  late BookFlipController _controller =
      BookFlipController(initialSpread: math.max(0, _windowOf(_chapter).indexOf(_current)));

  /// The book shows one chapter at a time so its pages stay sharp.
  late int _chapter = _chapterIndexOf(_current);
  bool _imagesReady = false;

  /// The book re-captures (and resets to its first spread) whenever it gets a
  /// different page builder, so the builder only changes with the chapter.
  late Widget Function(BuildContext, int) _pageBuilder = _pageBuilderFor(_chapter);

  Widget Function(BuildContext, int) _pageBuilderFor(int chapter) {
    final pages = _windowOf(chapter);
    return (context, i) {
      final index = pages[i ~/ 2];
      return i.isEven ? _leftPage(index) : _rightPage(index);
    };
  }

  List<advice> get _book => widget.cons;
  int get _current => widget.currentAdvice;

  /// Indices (into [_book]) of the pages of chapter [chapter].
  List<int> _pagesOf(int chapter) => [
        for (int i = 0; i < _book.length; i++)
          if (_chapters[chapter].contains(_book[i])) i,
      ];

  int _chapterIndexOf(int page) {
    final i = _chapters.indexWhere((c) => c.contains(_book[page]));
    return i < 0 ? 0 : i;
  }

  /// What the book holds for [chapter]: its pages, plus the last page of the
  /// previous chapter and the first page of the next one, so a drag can cross
  /// into the neighbouring chapter like any other page turn.
  List<int> _windowOf(int chapter) => [
        if (chapter > 0) _pagesOf(chapter - 1).last,
        ..._pagesOf(chapter),
        if (chapter < _chapters.length - 1) _pagesOf(chapter + 1).first,
      ];

  @override
  void initState() {
    super.initState();
    globalMusicPlayerStartPage.stop();
    _playPage(_current);
    // Pages are captured as images on their first frame: load the pictures first.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final images = {for (int i = 0; i < _book.length; i++) _illustrationFor(_book[i], i)};
      await Future.wait([for (final image in images) precacheImage(AssetImage(image), context)]);
      if (mounted) setState(() => _imagesReady = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _player.dispose();
    super.dispose();
  }

  void _playPage(int index) {
    _player.stop();
    _player.play(AssetSource(_book[index].SoundPath), volume: globalVolumeSoundSettings);
  }

  /// Opens [chapter], at its first page or (when coming back) its last.
  void _openChapter(int chapter, {bool atEnd = false, bool playAudio = true}) {
    if (chapter < 0 || chapter >= _chapters.length) return;
    final pages = _pagesOf(chapter);
    final page = atEnd ? pages.last : pages.first;
    if (playAudio) HapticFeedback.selectionClick();
    final old = _controller;
    setState(() {
      _chapter = chapter;
      _pageBuilder = _pageBuilderFor(chapter);
      widget.currentAdvice = page;
      _controller = BookFlipController(initialSpread: _windowOf(chapter).indexOf(page));
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
    if (playAudio) _playPage(page);
  }

  void _next() {
    if (!_controller.nextSpread()) _openChapter(_chapter + 1);
  }

  void _previous() {
    if (!_controller.previousSpread()) _openChapter(_chapter - 1, atEnd: true);
  }

  void _onSpreadChanged(int spread) {
    final window = _windowOf(_chapter);
    if (spread < 0 || spread >= window.length) return;
    final page = window[spread];
    setState(() => widget.currentAdvice = page);
    _playPage(page);
    // Landed on a neighbouring chapter's edge page: switch the book to that
    // chapter (showing the same page) so the reader can keep turning.
    final chapterOfPage = _chapterIndexOf(page);
    if (chapterOfPage != _chapter) {
      _openChapter(chapterOfPage, atEnd: chapterOfPage < _chapter, playAudio: false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      color: AppColors.green,
                      tooltip: 'Menu',
                      onTap: () => Navigator.popAndPushNamed(context, '/'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int c = 0; c < _chapters.length; c++) ...[
                              _ChapterChip(
                                chapter: _chapters[c],
                                selected: c == _chapterIndexOf(_current),
                                onTap: () => _openChapter(c),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    RoundIconButton(
                      icon: Icons.volume_up_rounded,
                      color: AppColors.darkBeige,
                      tooltip: 'Écouter',
                      onTap: () => _playPage(_current),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Row(
                    children: [
                      _TurnButton(
                        icon: Icons.chevron_left_rounded,
                        onTap: _current > 0 ? _previous : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: LayoutBuilder(builder: (context, c) => _openBook(c.biggest))),
                      const SizedBox(width: 8),
                      _TurnButton(
                        icon: Icons.chevron_right_rounded,
                        onTap: _current < _book.length - 1 ? _next : null,
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

  /// The open book: the current chapter's pages, turned with a real 3D curl.
  Widget _openBook(Size area) {
    // Two pages side by side, in the proportions of the original book art.
    const spreadAspect = 500 / 322;
    final width = math.min(area.width, area.height * spreadAspect);
    final pageSize = Size((width / 2).floorToDouble(), (width / spreadAspect).floorToDouble());
    if (!_imagesReady || pageSize.isEmpty) return const SizedBox.shrink();

    final pageCount = _windowOf(_chapter).length * 2;
    // Keep every page of the chapter inside the curl's texture, as sharp as possible.
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
            key: ValueKey('chapter$_chapter-${pageSize.width}'),
            controller: _controller,
            pageCount: pageCount,
            pageSize: pageSize,
            pixelRatio: pixelRatio,
            curl: BookFlipCurl.gentle,
            onSpreadChanged: _onSpreadChanged,
            onFlipStart: (_, __) => HapticFeedback.selectionClick(),
            // While a chapter's pages are captured, show the current page as is.
            loadingBuilder: (context) => Row(children: [
              Expanded(child: _leftPage(_current)),
              Expanded(child: _rightPage(_current)),
            ]),
            pageBuilder: _pageBuilder,
          ),
        ),
      ),
    );
  }

  /// Paper with a soft shade towards the spine.
  Widget _paper({required bool left, required Widget child}) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: left ? Alignment.centerLeft : Alignment.centerRight,
            end: left ? Alignment.centerRight : Alignment.centerLeft,
            colors: const [_pageColor, _pageColor, _pageShade],
            stops: const [0, 0.85, 1],
          ),
        ),
        child: child,
      );

  /// Left page: the illustration.
  Widget _leftPage(int index) => _paper(
        left: true,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(child: Image.asset(_illustrationFor(_book[index], index), fit: BoxFit.contain)),
        ),
      );

  /// Right page: chapter-coloured title, the text and the page number.
  Widget _rightPage(int index) {
    final page = _book[index];
    final chapter = _chapters[_chapterIndexOf(index)];
    return _paper(
      left: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 22, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
              decoration: BoxDecoration(color: chapter.color, borderRadius: BorderRadius.circular(14)),
              child: Text(
                _readableTitle(page.titre),
                style: const TextStyle(
                  fontFamily: 'Digital',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(child: _FittedPageText(page: page)),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '${index + 1} / ${_book.length}',
                style: const TextStyle(fontFamily: 'Digital', fontWeight: FontWeight.bold, color: Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _readableTitle(String title) {
  final lower = title.toLowerCase();
  return lower[0].toUpperCase() + lower.substring(1);
}

/// Page text, scaled down when needed so it is never cut off. Bin pages
/// ("COULEUR DE POUBELLE: …") are laid out as labelled rows.
class _FittedPageText extends StatelessWidget {
  const _FittedPageText({required this.page});
  final advice page;

  static const _text = TextStyle(fontSize: 17, height: 1.35, color: Color(0xFF37474F));

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: constraints.maxWidth,
          child: page.contenu.contains('COULEUR DE POUBELLE') ? _binRows() : Text(_clean(page.contenu), style: _text),
        ),
      );
    });
  }

  Widget _binRows() {
    final fields = <String, String>{};
    for (final line in page.contenu.split('\n')) {
      final i = line.indexOf(':');
      if (i > 0) fields[line.substring(0, i).trim().toUpperCase()] = line.substring(i + 1).trim();
    }
    final colour = fields['COULEUR DE POUBELLE'] ?? '';
    final rows = <Widget>[
      Row(
        children: [
          CircleAvatar(radius: 9, backgroundColor: _binColor(colour)),
          const SizedBox(width: 8),
          Text('Poubelle ${_binAdjective(colour)}', style: _text.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    ];
    void add(String emoji, String label, String? value) {
      if (value == null || value.isEmpty) return;
      rows.add(Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text.rich(TextSpan(children: [
          TextSpan(text: '$emoji $label : ', style: _text.copyWith(fontWeight: FontWeight.bold)),
          TextSpan(text: _clean(value), style: _text),
        ])),
      ));
    }

    add('🗑', "Ce qu'on y met", fields['SES DÉCHETS']);
    add('💡', 'Astuce', fields['INDICATION']);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }

  static String _clean(String text) => text
      .replaceAll(RegExp(r'\s+'), ' ')
      .replaceAll(RegExp(r'\s*,\s*'), ', ')
      // French typography: a space before ? ! : ;
      .replaceAllMapped(RegExp(r'\s*([?!:;])'), (m) => ' ${m[1]}')
      .trim();

  static Color _binColor(String colour) => switch (colour.toLowerCase()) {
        'gris' => Colors.grey,
        'orange' => Colors.orange,
        'vert' => Colors.green,
        'bleu' => Colors.blue,
        'jaune' => Colors.amber,
        'rouge' => Colors.red,
        _ => Colors.black26,
      };

  static String _binAdjective(String colour) => switch (colour.toLowerCase()) {
        'gris' => 'grise',
        'vert' => 'verte',
        'bleu' => 'bleue',
        _ => colour.toLowerCase(),
      };
}

class _ChapterChip extends StatelessWidget {
  const _ChapterChip({required this.chapter, required this.selected, required this.onTap});
  final _Chapter chapter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: chapter.label,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? chapter.color : Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: selected ? Colors.white : chapter.color, width: 2),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 2))],
        ),
        child: Text(
          chapter.label,
          style: TextStyle(
            fontFamily: 'Digital',
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _TurnButton extends StatelessWidget {
  const _TurnButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: onTap == null ? 0.3 : 1,
      child: RoundIconButton(icon: icon, color: AppColors.lightBlue, size: 52, onTap: onTap),
    );
  }
}
