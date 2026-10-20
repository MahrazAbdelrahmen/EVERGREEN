import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../BackEnd/PlayerProgress/player.dart';
import '../hive_registrar.g.dart';
import '../player_box.dart';

Future<void>? _startup;

/// Everything the app needs before the first real screen: Firebase, the local
/// database and the signed-in family's online profiles. Runs once, behind the
/// splash screen.
Future<void> initializeApp() => _startup ??= _initialize();

Future<void> _initialize() async {
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapters();
  playerBox = await Hive.openBox<PlayerProgress>('playerBox');
  parentBox = await Hive.openBox<Parent>('parentBox');
  onlineParentBox = await Hive.openBox<Parent>('onlineParentBox');
  // Older builds could cache a family under an empty id; drop it.
  if (onlineParentBox.containsKey('')) await onlineParentBox.delete('');
  // Online profiles are a bonus: never keep the child waiting on the network.
  try {
    await getProgress().timeout(const Duration(seconds: 5));
  } on TimeoutException {
    debugPrint('Online profiles not loaded in time; continuing offline.');
  }
}
