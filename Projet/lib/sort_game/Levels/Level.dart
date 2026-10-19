import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sorttrash/BackEnd/PlayerProgress/player.dart';
import '../../StartPage/settings.dart';
import '../../composents/game_settings.dart';
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
    _arrayOfTrash = arrayOfTrash;
    _arrayOfTrashCans = arrayOfTrashCans;
    _changeBooleanStatus = changeBooleanStatus;
    _isLocked = isLocked;
    _copyOfArrayOfTrash = arrayOfTrash.toList();
  }
  bool _isLocked = false;
  late List<Trash> _arrayOfTrash;
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
  late double screenHeight = MediaQuery.of(context).size.height;
  late double screenWidth = MediaQuery.of(context).size.width;
  late PlayerProgress playerProgress = currentProfileIndex == 1
      ? offlineProgress.returnParent().children[globalChildKey]
      : onlineProgress.returnParent().children[onlineGlobalChildKey];
  final User? user = FirebaseAuth.instance.currentUser;
  void replay(){
    setState(() {
      widget._copyOfArrayOfTrash.shuffle();
      widget._arrayOfTrash = widget._copyOfArrayOfTrash;
    });
  }
  void decoy(){
  }
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
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GamesSettings(functionToBeUsed: replay, functionToResumeTimer: decoy, functionToStopTimer: decoy,),
                const SizedBox(width: 30,),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildDragInterface(),
                ],
              ),
            ),
            SizedBox(
              height: 0.06*MediaQuery.of(context).size.height,
            ),
            showTrashCans(context),
          ],
        ),
      ),
    );
  }

  Widget showTrashCans(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 2, color: Colors.black),
            color: Colors.white38
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

  @override
  void initState() {
    globalMusicPlayerStartPage.stop();
    widget._copyOfArrayOfTrash.shuffle();
    widget._arrayOfTrash = widget._copyOfArrayOfTrash;
    super.initState();
  }

  Widget showTrashCan(BuildContext context, {required TrashCan trashCan}) {
    return DragTarget<Trash>(
      builder: (context, candidateData, rejectedData) => Center(
        child: Container(
          height: 0.55*MediaQuery.of(context).size.height,
          width: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(trashCan.imageName), fit: BoxFit.fill),
            color: Colors.transparent,
          ),
        ),
      ),
      onWillAcceptWithDetails: (data) => true,
      onAcceptWithDetails: (details) {
        final data = details.data;
        if (trashCan.trashToGoThrough.contains(data.type)) {
          globalSoundPlayerStartPage.play(AssetSource('music/correct.mp3'));
          if (widget._arrayOfTrash.length == 1) {
            setState(() {
              playerProgress.score = 5*widget._copyOfArrayOfTrash.length;
              setState(() {
                if (sortGameNumber <
                    playerProgress.gamesData[1].levelsCompleted.length) {
                  List<String> characters =
                  playerProgress.gamesData[1].levelsCompleted.split('');
                  characters[sortGameNumber] = '1';
                  playerProgress.gamesData[1].levelsCompleted =
                      characters.join('');
                }
              });
              widget._arrayOfTrash = widget._copyOfArrayOfTrash.toList();
              widget._changeBooleanStatus(false);
            });
            try {
              if (currentProfileIndex == 1) {
                offlineProgress.setChild(globalChildKey, playerProgress);
                if (parentBox.isEmpty) {
                  parentBox.add(offlineProgress);
                }else{
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => BravoPage(score: playerProgress.score ,)));
          }
          setState(() {
            widget._arrayOfTrash.removeWhere((trash) => trash.id == data.id);
          });
        } else {
          globalSoundPlayerStartPage.play(AssetSource('music/wrong.mp3'));
        }
      },
    );
  }

  Widget buildDragInterface() {
    widget._arrayOfTrash.shuffle();
    return Container(
      width: 0.7*MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black,
          width: 5.0,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget._arrayOfTrash
              .map((trash) => DraggableTrash(trash: trash))
              .toList(),
        ),
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
  static double size = 50;
  @override
  Widget build(BuildContext context) => Draggable<Trash>(
        data: trash,
        feedback: image(),
        childWhenDragging: Container(height: size),
        child: image(),
      );

  Widget image() => Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.transparent,
        ),
        child: Image.asset(trash.imageName),
      );
}
