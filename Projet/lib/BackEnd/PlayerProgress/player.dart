
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';

part 'player.g.dart';

@HiveType(typeId: 1)
class PlayerProgress {
  @HiveField(0)
  late int score;
  @HiveField(1)
  late int childID;
  @HiveField(2)
  late List<LevelsCompleted> gamesData;
  @HiveField(3)
  late DateTime lastTimeToJoin;
  @HiveField(4)
  late String? childsName;
  @HiveField(5)
  late String? childGlobalUID;
  @HiveField(6)
  late String? avatarProfileName;
  @HiveField(7)
  late DateTime? lastChallengeDate;
  PlayerProgress(this.score, this.gamesData, this.lastTimeToJoin, this.childID,
      this.childsName, this.childGlobalUID, this.avatarProfileName, this.lastChallengeDate);
  factory PlayerProgress.fromJson(Map<String, dynamic> json) {
    List<dynamic> gamesDataJson = json['gamesData'];
    List<LevelsCompleted> gamesData = gamesDataJson.map((gameJson) => LevelsCompleted.fromJson(gameJson)).toList();
    return PlayerProgress(
      json['score'] as int,
      gamesData,
      DateTime.parse(json['lastTimeToJoin'] as String),
      json['childID'] as int,
      json['childsName'] as String?,
      json['childGlobalUID'] as String?,
      json['avatarProfileName'] as String?,
      json['lastChallengeDate'] == null
          ? null
          : DateTime.parse(json['lastChallengeDate'] as String),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'childID': childID,
      'gamesData': gamesData.map((game) => game.toJson()).toList(),
      'lastTimeToJoin': lastTimeToJoin.toIso8601String(),
      'childsName': childsName,
      'childGlobalUID': childGlobalUID,
      'avatarProfileName' : avatarProfileName,
      'lastChallengeDate' : lastChallengeDate?.toIso8601String()
    };
  }
}

@HiveType(typeId: 2)
class LevelsCompleted {
  @HiveField(0)
  late int id;
  @HiveField(1)
  late String levelsCompleted;
  LevelsCompleted(this.id, this.levelsCompleted);
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'levelsCompleted': levelsCompleted,
    };
  }

  factory LevelsCompleted.fromJson(Map<String, dynamic> json) {
    return LevelsCompleted(
      json['id'] as int,
      json['levelsCompleted'] as String,
    );
  }

}

@HiveType(typeId: 3)
class Parent {
  @HiveField(0)
  late List<PlayerProgress> _children = [];

  List<PlayerProgress> get children => _children;

  set children(List<PlayerProgress> value) {
    _children = value;
  }
  @HiveField(1)
  late int _numberOfChildren;
  @HiveField(2)
  late String? parentUUID;
  int get numberOfChildren => _numberOfChildren;

  set numberOfChildren(int value) {
    _numberOfChildren = value;
  }

  Parent(this._children, this._numberOfChildren, this.parentUUID);
   factory Parent.fromJson(Map<String, dynamic> json) {
    var children = (json['children'] as List)
        .map((e) => PlayerProgress.fromJson(e))
        .toList();
    return Parent(children, json['childrenNumber'], json['parentUUID']);
  }
  Map<String, dynamic> _toJson() => {
        "children": children.map((e) => e.toJson()).toList(),
        "childrenNumber": numberOfChildren,
        "parentUUID": parentUUID,
      };

  void createData(String uid) {
    FirebaseFirestore.instance.collection('parent').doc(uid).set(_toJson());
    syncLeaderboard(uid);
  }

  Future<Parent?> fetchParentData(String uuid) async {
    try{
      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('parent').doc(uuid).get();
      final data = snapshot.data() as Map<String, dynamic>?;
      return data == null ? null : Parent.fromJson(data);
    } catch (e) {
      debugPrint('fetchParentData failed: $e');
      return null;
    }
  }

  /// Saves this family's record and refreshes its leaderboard entries.
  void updateData(String dataId) {
    if (dataId.isEmpty) {
      debugPrint('updateData skipped: no signed-in family id');
      return;
    }
    FirebaseFirestore.instance
        .collection('parent')
        .doc(dataId)
        .set(_toJson())
        .catchError((Object e) => debugPrint('updateData failed: $e'));
    syncLeaderboard(dataId);
  }

  /// Mirrors each child's first name, score and avatar into the shared
  /// `leaderboard` collection (the only data other families can read), and
  /// removes entries of children that were deleted. See firestore.rules.
  Future<void> syncLeaderboard(String uid) async {
    if (uid.isEmpty) return;
    final firestore = FirebaseFirestore.instance;
    final board = firestore.collection('leaderboard');
    try {
      final batch = firestore.batch();
      final keep = <String>{};
      for (final child in children) {
        final key = (child.childGlobalUID ?? '${child.childID}').replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
        final id = '${uid}_$key';
        keep.add(id);
        final name = (child.childsName ?? '').trim();
        batch.set(board.doc(id), {
          'owner': uid,
          'name': name.length > 20 ? name.substring(0, 20) : name,
          'score': child.score,
          'avatar': child.avatarProfileName ?? '',
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      final mine = await board.where('owner', isEqualTo: uid).get();
      for (final doc in mine.docs) {
        if (!keep.contains(doc.id)) batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      debugPrint('syncLeaderboard failed: $e');
    }
  }
}
