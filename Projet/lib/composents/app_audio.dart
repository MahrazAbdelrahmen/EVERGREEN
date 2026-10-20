import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

/// Creates the app's audio players and silences them while the app is in the
/// background (another app, home screen, screen off), resuming afterwards.
abstract final class AppAudio {
  static final _players = <WeakReference<AudioPlayer>>[];
  static final _pausedInBackground = <AudioPlayer>[];
  static AppLifecycleListener? _lifecycle;

  // The app's sounds mix with each other. With the default exclusive audio
  // focus, every new play() knocks the previous request out and Android pauses
  // the player that just started (narration cutting off, music stopping).
  static final _context = AudioContext(
    android: const AudioContextAndroid(audioFocus: AndroidAudioFocus.none),
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.playback,
      options: const {AVAudioSessionOptions.mixWithOthers},
    ),
  );

  /// Use instead of `AudioPlayer()` so the player follows the app lifecycle.
  static AudioPlayer create() {
    final player = AudioPlayer()..setAudioContext(_context);
    _players
      ..removeWhere((ref) => ref.target == null)
      ..add(WeakReference(player));
    return player;
  }

  /// Starts listening to the app lifecycle. Call once from `main`.
  static void init() {
    AudioPlayer.global.setAudioContext(_context);
    _lifecycle ??= AppLifecycleListener(onHide: _pauseAll, onShow: _resumeAll);
  }

  static void _pauseAll() {
    _pausedInBackground.clear();
    for (final ref in _players) {
      final player = ref.target;
      if (player != null && player.state == PlayerState.playing) {
        player.pause();
        _pausedInBackground.add(player);
      }
    }
  }

  static void _resumeAll() {
    for (final player in _pausedInBackground) {
      if (player.state == PlayerState.paused) player.resume();
    }
    _pausedInBackground.clear();
  }
}
