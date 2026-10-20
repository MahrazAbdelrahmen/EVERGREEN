import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sorttrash/BackEnd/PlayerProgress/player.dart';
import '../../StartPage/settings.dart';
import '../../composents/app_theme.dart';
import '../../composents/game_settings.dart';
import '../../composents/ui/drop_feedback.dart';
import '../../composents/ui/game_hud.dart';
import '../../pages/bravo_widget.dart';
import '../../player_box.dart';
import '../Models/Objects.dart';
import '../Models/TrashCans.dart';
import 'levels_managment.dart';

class Level extends StatefulWidget {
  late Function(bool) _changeBooleanStatus;
  Level(
      {super.key,
      required List<Trash> arrayOfTrash,
      required List<TrashCan> arrayOfTrashCans,
      required Function(bool) changeBooleanStatus,
      required bool isLocked}) {
    _arrayOfTrashCans = arrayOfTrashCans;
    _changeBooleanStatus = changeBooleanStatus;
    _isLocked = isLocked;
    _copyOfArrayOfTrash = arrayOfTrash.toList();
  }
  bool _isLocked = false;
  late List<Trash> _copyOfArrayOfTrash;
  late List<TrashCan> _arrayOfTrashCans;
  bool returnIsLocked() {
    return _isLocked;
  }
  void setIsLocked(bool isUnlocked) {
    _isLocked = isUnlocked;
  }


  @override
  State<Level> createState() => _LevelState();
}

class _LevelState extends State<Level> {
  late PlayerProgress playerProgress = currentProfileIndex == 1
      ? offlineProgress.returnParent().children[globalChildKey]
      : onlineProgress.returnParent().children[onlineGlobalChildKey];
  final User? user = FirebaseAuth.instance.currentUser;

  static const _pointsPerItem = 5;
  late List<Trash> _remaining;
  int _sessionScore = 0;
  int _mistakes = 0;
  final Map<int, DropResult> _binResult = {};
  final Map<int, int> _binTick = {};

  int get _total => widget._copyOfArrayOfTrash.length;

  @override
  void initState() {
    super.initState();
    globalMusicPlayerStartPage.stop();
    _resetRound();
  }

  void _resetRound() {
    _remaining = widget._copyOfArrayOfTrash.toList()..shuffle();
    _sessionScore = 0;
    _mistakes = 0;
    _binResult.clear();
  }

  void replay() => setState(_resetRound);

  void decoy() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg-image.png'), fit: BoxFit.fill),
        ),
        child: SafeArea(
          child: Column(
            children: [
              GameHud(
                done: _total - _remaining.length,
                total: _total,
                score: _sessionScore,
                trailing: GamesSettings(
                  functionToBeUsed: replay,
                  functionToResumeTimer: decoy,
                  functionToStopTimer: decoy,
                ),
              ),
              const SizedBox(height: 8),
              buildDragInterface(),
              const Spacer(),
              showTrashCans(context),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget showTrashCans(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white.withValues(alpha: 0.35),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget._arrayOfTrashCans
                .map((trashCan) => showTrashCan(context, trashCan: trashCan))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget showTrashCan(BuildContext context, {required TrashCan trashCan}) {
    return DragTarget<Trash>(
      builder: (context, candidateData, rejectedData) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: DropFeedback(
          result: _binResult[trashCan.id] ?? DropResult.none,
          tick: _binTick[trashCan.id] ?? 0,
          hovering: candidateData.isNotEmpty,
          child: Image.asset(
            trashCan.imageName,
            height: 0.5 * MediaQuery.sizeOf(context).height,
            width: 110,
            fit: BoxFit.fill,
          ),
        ),
      ),
      onWillAcceptWithDetails: (data) => true,
      onAcceptWithDetails: (details) => _onDrop(trashCan, details.data),
    );
  }

  void _onDrop(TrashCan trashCan, Trash trash) {
    final correct = trashCan.trashToGoThrough.contains(trash.type);
    final result = correct ? DropResult.correct : DropResult.wrong;
    DropFeedback.haptic(result);
    globalSoundPlayerStartPage.play(
        AssetSource(correct ? 'music/correct.mp3' : 'music/wrong.mp3'),
        volume: globalVolumeSoundSettings);
    setState(() {
      _binResult[trashCan.id] = result;
      _binTick[trashCan.id] = (_binTick[trashCan.id] ?? 0) + 1;
      if (correct) {
        _sessionScore += _pointsPerItem;
        _remaining.remove(trash);
      } else {
        _mistakes++;
      }
    });
    if (correct && _remaining.isEmpty) _finishLevel();
  }

  void _finishLevel() {
    playerProgress.score += _sessionScore;
    if (sortGameNumber < playerProgress.gamesData[1].levelsCompleted.length) {
      final characters = playerProgress.gamesData[1].levelsCompleted.split('');
      characters[sortGameNumber] = '1';
      playerProgress.gamesData[1].levelsCompleted = characters.join('');
    }
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
    final stars = _mistakes == 0 ? 3 : (_mistakes <= 3 ? 2 : 1);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BravoPage(score: _sessionScore, stars: stars),
      ),
    );
  }

  Widget buildDragInterface() {
    return Container(
      width: 0.75 * MediaQuery.sizeOf(context).width,
      height: 84,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.green, width: 4),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: _remaining.isEmpty
          ? const Center(
              child: Icon(Icons.check_circle, color: AppColors.green, size: 40))
          : ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final trash in _remaining)
                  DraggableTrash(key: ObjectKey(trash), trash: trash),
              ],
            ),
    );
  }
}

class DraggableTrash extends StatelessWidget {
  final Trash trash;
  const DraggableTrash({
    super.key,
    required this.trash,
  });
  static const double size = 64;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Draggable<Trash>(
          data: trash,
          feedback: Transform.scale(scale: 1.3, child: image()),
          childWhenDragging: Opacity(opacity: 0.25, child: image()),
          onDragStarted: HapticFeedback.selectionClick,
          child: image(),
        ),
      );

  Widget image() => SizedBox(
        height: size,
        width: size,
        child: Image.asset(trash.imageName),
      );
}
