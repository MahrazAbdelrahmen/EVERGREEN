import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sorttrash/Puzzle/Models/Objects.dart';
import 'package:sorttrash/Puzzle/Models/TrashCans.dart';
import 'package:sorttrash/Puzzle/Models/puzzle_management.dart';
import 'package:sorttrash/composents/game_settings.dart';
import 'package:sorttrash/pages/bravo_widget.dart';

import '../BackEnd/PlayerProgress/player.dart';
import '../StartPage/settings.dart';
import '../composents/app_theme.dart';
import '../composents/ui/app_button.dart';
import '../composents/ui/drop_feedback.dart';
import '../composents/ui/game_hud.dart';
import '../composents/ui/pressable.dart';
import '../player_box.dart';
import 'jigsaw.dart';

class PuzzleLevel extends StatefulWidget {
  late Function(bool) _changeBooleanStatus;
  PuzzleLevel(
      {super.key,
      required List<Piece> arrayOfPuzzlePieces,
      required List<Square> arrayOfSquares,
      required Function(bool) changeBooleanStatus,
      required bool isLocked,
      required int timeCount,
      required int matrixSSize,
      required String imageName}) {
    _arrayOfPuzzlePieces = arrayOfPuzzlePieces;
    _arrayOfSquares = arrayOfSquares;
    _changeBooleanStatus = changeBooleanStatus;
    _isLocked = isLocked;
    _copyOfarrayOfPuzzlePieces = arrayOfPuzzlePieces.toList();
    _imageName = imageName;
    _timeCount = timeCount;
    _matrixSize = matrixSSize;
  }
  bool _isLocked = false;
  bool _isFinished = false;
  late List<Piece> _arrayOfPuzzlePieces;
  late final int _timeCount;
  late final int _matrixSize;
  late final String _imageName;
  late List<Piece> _copyOfarrayOfPuzzlePieces;
  late List<Square> _arrayOfSquares;
  bool returnIsLocked() {
    return _isLocked;
  }

  bool returnIsFinished() {
    return _isFinished;
  }

  void setIsLocked(bool isUnlockde) {
    _isLocked = isUnlockde;
  }

  void setIsFinished(bool isFinished) {
    _isFinished = isFinished;
  }

  @override
  State<PuzzleLevel> createState() => _PuzzleLevelState();
}

class _PuzzleLevelState extends State<PuzzleLevel> {
  static const _emptySquare = "assets/images/empty.png";
  static const _boardPadding = 6.0;

  final User? user = FirebaseAuth.instance.currentUser;
  late PlayerProgress playerProgress = currentProfileIndex == 1
      ? offlineProgress.returnParent().children[globalChildKey]
      : onlineProgress.returnParent().children[onlineGlobalChildKey];

  late Timer timer;
  late int time = widget._timeCount;
  int correctPiecesNumber = 0;
  bool stopTimerBool = false;
  bool _finished = false;
  bool _revealing = false;
  int _scatterSeed = 0;
  late JigsawCut _cut;
  final Map<int, DropResult> _squareResult = {};
  final Map<int, int> _squareTick = {};

  int get _totalPieces => widget._matrixSize * widget._matrixSize;

  @override
  void initState() {
    super.initState();
    globalMusicPlayerStartPage.stop();
    _resetBoard();
    timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _resetBoard() {
    time = widget._timeCount;
    correctPiecesNumber = 0;
    _finished = false;
    _revealing = false;
    _scatterSeed = math.Random().nextInt(1 << 30);
    _cut = JigsawCut(widget._matrixSize, _scatterSeed);
    _squareResult.clear();
    widget._copyOfarrayOfPuzzlePieces.shuffle();
    widget._arrayOfPuzzlePieces = widget._copyOfarrayOfPuzzlePieces.toList();
    for (final square in widget._arrayOfSquares) {
      square.imageName = _emptySquare;
    }
  }

  void _tick() {
    if (stopTimerBool || _finished) return;
    setState(() => time = time > 0 ? time - 1 : 0);
    if (time == 0) _timeUp();
  }

  void stopTimer() => setState(() => stopTimerBool = true);

  void resumeTimer() => setState(() => stopTimerBool = false);

  void replay() => setState(_resetBoard);

  void _timeUp() {
    stopTimerBool = true;
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
                  const Icon(Icons.timer_off_rounded, size: 56, color: Colors.redAccent),
                  const SizedBox(height: 8),
                  const Text(
                    'Temps écoulé !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Digital', fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    label: 'Rejouer',
                    icon: Icons.replay_rounded,
                    color: AppColors.lightBlue,
                    expand: true,
                    onTap: () {
                      Navigator.pop(dialogContext);
                      setState(() {
                        _resetBoard();
                        stopTimerBool = false;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Quitter',
                    icon: Icons.logout_rounded,
                    color: Colors.redAccent,
                    expand: true,
                    onTap: () {
                      Navigator.pop(dialogContext);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg-image.png'), fit: BoxFit.fill),
        ),
        child: SafeArea(
          child: Column(
            children: [
              GameHud(
                done: correctPiecesNumber,
                total: _totalPieces,
                score: correctPiecesNumber * 10,
                secondsLeft: time,
                trailing: GamesSettings(
                  functionToBeUsed: replay,
                  functionToResumeTimer: resumeTimer,
                  functionToStopTimer: stopTimer,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
                  child: LayoutBuilder(
                    builder: (context, constraints) => _playArea(constraints.biggest),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The board in the middle, the model pinned top-left, and the remaining
  /// pieces scattered around like a jigsaw spread out on a table.
  Widget _playArea(Size area) {
    final board = math.min(area.height, area.width * 0.42);
    final boardRect = Rect.fromLTWH((area.width - board) / 2, (area.height - board) / 2, board, board);
    final polaroidWidth = math.min(120.0, (boardRect.left - 16) * 0.55);
    final polaroidRect = Rect.fromLTWH(0, 0, polaroidWidth + 12, polaroidWidth * 1.2 + 12);
    // The board's picture area is inset by the frame's padding.
    final boardCell = (board - 2 * _boardPadding) / widget._matrixSize;
    final scatter = _scatterPieces(area, boardRect, polaroidRect, boardCell);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fromRect(rect: boardRect, child: _board()),
        Positioned(left: 4, top: 4, child: _polaroid(polaroidWidth)),
        for (final piece in widget._arrayOfPuzzlePieces)
          if (scatter.spots[piece] case final spot?)
            Positioned(
              left: spot.dx,
              top: spot.dy,
              child: DraggablePiece(
                key: ObjectKey(piece),
                trash: piece,
                image: widget._imageName,
                cut: _cut,
                cell: scatter.size,
                dragCell: boardCell,
                angle: scatter.angles[piece] ?? 0,
              ),
            ),
      ],
    );
  }

  /// Stable random spots for every piece of this round (seeded per round, so
  /// pieces stay put while others are placed).
  ({double size, Map<Piece, Offset> spots, Map<Piece, double> angles}) _scatterPieces(
      Size area, Rect board, Rect keepClear, double cellSize) {
    final pieces = widget._copyOfarrayOfPuzzlePieces;
    const spacing = 8.0;
    // `size` is a piece's square part; its tabs need the larger `box`.
    var size = math.min(cellSize, 60.0);
    List<Offset> slots = [];
    while (true) {
      slots = [];
      final box = JigsawPiece.boxSize(size);
      final step = box + spacing;
      for (final region in [
        Rect.fromLTRB(0, 0, board.left - spacing, area.height),
        Rect.fromLTRB(board.right + spacing, 0, area.width, area.height),
      ]) {
        final columns = ((region.width + spacing) / step).floor();
        final rows = ((region.height + spacing) / step).floor();
        if (columns <= 0 || rows <= 0) continue;
        // Centre the grid of spots inside the region.
        final offsetX = region.left + (region.width - (columns * step - spacing)) / 2;
        final offsetY = region.top + (region.height - (rows * step - spacing)) / 2;
        for (int r = 0; r < rows; r++) {
          for (int c = 0; c < columns; c++) {
            final spot = Offset(offsetX + c * step, offsetY + r * step);
            if (!keepClear.overlaps(spot & Size(box, box))) slots.add(spot);
          }
        }
      }
      if (slots.length >= pieces.length || size <= 26) break;
      size -= 4;
    }

    final random = math.Random(_scatterSeed);
    slots.shuffle(random);
    final spots = <Piece, Offset>{};
    final angles = <Piece, double>{};
    for (int i = 0; i < pieces.length && i < slots.length; i++) {
      final jitter = Offset((random.nextDouble() - 0.5) * spacing, (random.nextDouble() - 0.5) * spacing);
      spots[pieces[i]] = slots[i] + jitter;
      angles[pieces[i]] = (random.nextDouble() - 0.5) * 0.3;
    }
    return (size: size, spots: spots, angles: angles);
  }

  /// The picture to rebuild, pinned like a polaroid; tap to see it bigger.
  Widget _polaroid(double width) {
    return Transform.rotate(
      angle: -0.06,
      child: Pressable(
        onTap: _zoomModel,
        semanticLabel: 'Agrandir le modèle',
        child: Container(
          padding: const EdgeInsets.fromLTRB(6, 6, 6, 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(2, 4))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Image.asset(widget._imageName, width: width, height: width, fit: BoxFit.fill),
                  const Positioned(
                    right: 4,
                    bottom: 4,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.zoom_in_rounded, color: AppColors.darkBeige, size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              const Text(
                'Modèle',
                style: TextStyle(fontFamily: 'Digital', fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _zoomModel() {
    showDialog(
      context: context,
      builder: (dialogContext) => GestureDetector(
        onTap: () => Navigator.pop(dialogContext),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(widget._imageName, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  /// Framed board with a faint ghost of the picture so children can see where
  /// each piece goes.
  Widget _board() {
    return AnimatedScale(
      scale: _revealing ? 1.04 : 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: Container(
        padding: const EdgeInsets.all(_boardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _revealing ? AppColors.green.withValues(alpha: 0.8) : Colors.black38,
              blurRadius: _revealing ? 24 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: LayoutBuilder(builder: (context, constraints) {
            final n = widget._matrixSize;
            final cell = constraints.maxWidth / n;
            final m = cell * JigsawCut.tabRatio;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.1,
                    child: Image.asset(widget._imageName, fit: BoxFit.fill),
                  ),
                ),
                if (!_revealing)
                  Positioned.fill(child: CustomPaint(painter: JigsawOutlinePainter(_cut))),
                for (final square in widget._arrayOfSquares.take(_totalPieces))
                  if (square.imageName != _emptySquare)
                    Positioned(
                      left: ((square.id - 1) % n) * cell - m,
                      top: ((square.id - 1) ~/ n) * cell - m,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 1.15, end: 1),
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
                        child: JigsawPiece(
                          image: widget._imageName,
                          cut: _cut,
                          row: (square.id - 1) ~/ n,
                          col: (square.id - 1) % n,
                          cell: cell,
                          showShadow: false,
                          showEdge: !_revealing,
                        ),
                      ),
                    ),
                for (final square in widget._arrayOfSquares.take(_totalPieces))
                  Positioned(
                    left: ((square.id - 1) % n) * cell,
                    top: ((square.id - 1) ~/ n) * cell,
                    width: cell,
                    height: cell,
                    child: showSquare(context, square: square),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget showSquare(BuildContext context, {required Square square}) {
    return DragTarget<Piece>(
      builder: (context, candidateData, rejectedData) => DropFeedback(
        result: _squareResult[square.id] ?? DropResult.none,
        tick: _squareTick[square.id] ?? 0,
        hovering: candidateData.isNotEmpty,
        borderRadius: 6,
        child: Container(
          color: square.imageName == _emptySquare && candidateData.isNotEmpty
              ? Colors.white.withValues(alpha: 0.4)
              : Colors.transparent,
        ),
      ),
      onWillAcceptWithDetails: (details) => square.imageName == _emptySquare,
      onAcceptWithDetails: (details) => _onDrop(square, details.data),
    );
  }

  void _onDrop(Square square, Piece piece) {
    final correct = square.id == piece.id;
    final result = correct ? DropResult.correct : DropResult.wrong;
    DropFeedback.haptic(result);
    globalSoundPlayerStartPage.play(
        AssetSource(correct ? 'music/correct.mp3' : 'music/wrong.mp3'),
        volume: globalVolumeSoundSettings);
    setState(() {
      _squareResult[square.id] = result;
      _squareTick[square.id] = (_squareTick[square.id] ?? 0) + 1;
      if (correct) {
        correctPiecesNumber++;
        square.imageName = piece.imageName;
        widget._arrayOfPuzzlePieces.removeWhere((p) => p.id == piece.id);
      } else {
        time = time > 5 ? time - 5 : 0;
      }
    });
    if (correctPiecesNumber == _totalPieces) {
      _finished = true;
      setState(() => _revealing = true);
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) _finishLevel();
      });
    }
  }

  void _finishLevel() {
    _finished = true;
    final points = 100 +
        ((widget._copyOfarrayOfPuzzlePieces.length / widget._timeCount) * 1000).toInt();
    playerProgress.score += points;
    if (puzzleNumber < playerProgress.gamesData[0].levelsCompleted.length) {
      final characters = playerProgress.gamesData[0].levelsCompleted.split('');
      characters[puzzleNumber] = '1';
      playerProgress.gamesData[0].levelsCompleted = characters.join('');
    }
    widget.setIsFinished(true);
    widget._changeBooleanStatus(false);
    try {
      if (currentProfileIndex == 1) {
        offlineProgress.setChild(globalChildKey, playerProgress);
        if (parentBox.isEmpty) {
          parentBox.add(offlineProgress.returnParent());
        } else {
          parentBox.putAt(0, offlineProgress.returnParent());
        }
      } else {
        onlineProgress.setChild(onlineGlobalChildKey, playerProgress);
        onlineParentBox.put(user!.uid, onlineProgress.returnParent());
        onlineProgress.returnParent().updateData(onlineProgress.getUID());
      }
    } catch (e) {
      debugPrint('$e');
    }
    final timeLeft = time / widget._timeCount;
    final stars = timeLeft > 0.5 ? 3 : (timeLeft > 0.2 ? 2 : 1);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BravoPage(score: points, stars: stars)),
    );
  }
}

class DraggablePiece extends StatelessWidget {
  const DraggablePiece({
    super.key,
    required this.trash,
    required this.image,
    required this.cut,
    required this.cell,
    required this.dragCell,
    this.angle = 0,
  });
  final Piece trash;
  final String image;
  final JigsawCut cut;

  /// Size of the piece lying in the scatter, and while dragged (board size).
  final double cell;
  final double dragCell;

  /// Resting tilt in radians; the piece straightens while dragged.
  final double angle;

  int get _row => (trash.id - 1) ~/ cut.gridSize;
  int get _col => (trash.id - 1) % cut.gridSize;

  Widget _piece(double size, {bool lifted = false}) => JigsawPiece(
        image: image,
        cut: cut,
        row: _row,
        col: _col,
        cell: size,
        lifted: lifted,
      );

  @override
  Widget build(BuildContext context) => Draggable<Piece>(
        data: trash,
        // Centred under the finger at its board size, so it is easy to aim.
        dragAnchorStrategy: pointerDragAnchorStrategy,
        feedback: FractionalTranslation(
          translation: const Offset(-0.5, -0.5),
          child: _piece(dragCell, lifted: true),
        ),
        childWhenDragging: Opacity(
          opacity: 0.25,
          child: Transform.rotate(angle: angle, child: _piece(cell)),
        ),
        onDragStarted: HapticFeedback.selectionClick,
        child: Transform.rotate(angle: angle, child: _piece(cell)),
      );
}
