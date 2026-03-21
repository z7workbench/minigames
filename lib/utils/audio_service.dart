import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';

class AudioService {
  final Ref ref;

  AudioService(this.ref);

  Future<void> preload() async {
    // Preload common sounds
    // Note: Add actual audio files to assets/audio/ before using
  }

  Future<void> playButtonTap() async {
    if (!ref.read(settingsProvider).soundEnabled) return;
    await FlameAudio.play('button_tap.mp3');
  }

  Future<void> playDiceRoll() async {
    if (!ref.read(settingsProvider).soundEnabled) return;
    await FlameAudio.play('dice_roll.mp3');
  }

  Future<void> playCorrect() async {
    if (!ref.read(settingsProvider).soundEnabled) return;
    await FlameAudio.play('correct.mp3');
  }

  Future<void> playWrong() async {
    if (!ref.read(settingsProvider).soundEnabled) return;
    await FlameAudio.play('wrong.mp3');
  }

  Future<void> playWin() async {
    if (!ref.read(settingsProvider).soundEnabled) return;
    await FlameAudio.play('win.mp3');
  }

  Future<void> playLose() async {
    if (!ref.read(settingsProvider).soundEnabled) return;
    await FlameAudio.play('lose.mp3');
  }
}
