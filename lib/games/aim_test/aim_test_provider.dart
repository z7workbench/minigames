import 'dart:async';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/database.dart';
import '../../data/providers/database_provider.dart';
import 'models/aim_test_state.dart';

part 'aim_test_provider.g.dart';

final _random = Random();

// Keys for SharedPreferences persistence
const _kDeadZonePercentage = 'aim_test_dead_zone';
const _kBubbleSize = 'aim_test_bubble_size';
const _kSelectedColor = 'aim_test_selected_color';
const _kGameDuration = 'aim_test_game_duration';
const _kEnableAppearAnimation = 'aim_test_appear_animation';

// Provider for loading saved settings
@Riverpod(keepAlive: true)
Future<BubbleConfig> aimTestSettings(AimTestSettingsRef ref) async {
  final prefs = await SharedPreferences.getInstance();

  final deadZone = prefs.getDouble(_kDeadZonePercentage) ?? 0.2;
  final bubbleSize = prefs.getDouble(_kBubbleSize) ?? 60.0;
  final colorName = prefs.getString(_kSelectedColor) ?? 'random';
  final duration = prefs.getInt(_kGameDuration) ?? 30;
  final enableAnimation = prefs.getBool(_kEnableAppearAnimation) ?? false;

  return BubbleConfig(
    minSize: bubbleSize,
    maxSize: bubbleSize,
    deadZonePercentage: deadZone,
    selectedColor: BubbleColor.values.byName(colorName),
    gameDurationSeconds: duration,
    enableAppearAnimation: enableAnimation,
  );
}

@Riverpod(keepAlive: true)
class AimTestGame extends _$AimTestGame {
  Timer? _timer;
  Timer? _countdownTimer;

  @override
  AimTestState build() {
    ref.onDispose(() {
      _timer?.cancel();
      _countdownTimer?.cancel();
    });
    
    // Load saved settings asynchronously
    final settingsAsync = ref.watch(aimTestSettingsProvider);
    return settingsAsync.when(
      data: (config) => AimTestState.initial(config: config),
      loading: () => AimTestState.initial(),
      error: (error, stackTrace) => AimTestState.initial(),
    );
  }

  void startGame() {
    _timer?.cancel();
    _countdownTimer?.cancel();

    final duration = state.bubbleConfig.gameDurationSeconds;

    state = state.copyWith(
      status: AimTestStatus.countdown,
      score: 0,
      missedCount: 0,
      timeRemainingSeconds: duration,
      bubblesSpawned: 0,
      countdownValue: 3,
      clearBubble: true,
    );

    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final currentValue = state.countdownValue;
      
      if (currentValue > 0) {
        // Decrement countdown: 3 -> 2 -> 1 -> 0
        state = state.copyWith(countdownValue: currentValue - 1);
      } else {
        // countdownValue is 0 (showing "GO!")
        // After showing "GO!" briefly, start the actual game
        _countdownTimer?.cancel();
        _startActualGame();
      }
    });
  }

  void _startActualGame() {
    state = state.copyWith(
      status: AimTestStatus.playing,
      countdownValue: 3, // Reset for next game
    );
    _startTimer();
    _spawnBubble();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.status == AimTestStatus.playing) {
        final newTime = state.timeRemainingSeconds - 1;
        if (newTime <= 0) {
          _timer?.cancel();
          state = state.copyWith(
            status: AimTestStatus.completed,
            timeRemainingSeconds: 0,
            clearBubble: true,
          );
          _saveGameRecord();
        } else {
          state = state.copyWith(timeRemainingSeconds: newTime);
        }
      }
    });
  }

  void _spawnBubble() {
    final config = state.bubbleConfig;
    final deadZone = config.deadZonePercentage;

    final activeStart = deadZone;
    final activeEnd = 1.0 - deadZone;

    final x = activeStart + _random.nextDouble() * (activeEnd - activeStart);
    final y = activeStart + _random.nextDouble() * (activeEnd - activeStart);

    state = state.copyWith(
      currentBubbleX: x,
      currentBubbleY: y,
      bubblesSpawned: state.bubblesSpawned + 1,
    );
  }

  void onBubbleTap() {
    if (state.status != AimTestStatus.playing || !state.hasActiveBubble) {
      return;
    }

    final newScore = state.score + 1;
    final newBestScore = newScore > state.bestScore ? newScore : state.bestScore;

    state = state.copyWith(
      score: newScore,
      bestScore: newBestScore,
      clearBubble: true,
    );

    _spawnBubble();
  }

  void onMiss() {
    if (state.status != AimTestStatus.playing) return;
    state = state.copyWith(missedCount: state.missedCount + 1);
  }

  Future<void> updateDeadZonePercentage(double percentage) async {
    if (percentage < 0) percentage = 0;
    if (percentage > 0.4) percentage = 0.4;

    final newConfig = state.bubbleConfig.copyWith(deadZonePercentage: percentage);
    state = state.copyWith(bubbleConfig: newConfig);
    
    // Persist
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kDeadZonePercentage, percentage);
  }

  Future<void> updateBubbleSize(double size) async {
    final clampedSize = size.clamp(40.0, 100.0);
    final newConfig = state.bubbleConfig.copyWith(
      minSize: clampedSize,
      maxSize: clampedSize,
    );
    state = state.copyWith(bubbleConfig: newConfig);
    
    // Persist
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kBubbleSize, clampedSize);
  }

  Future<void> updateSelectedColor(BubbleColor color) async {
    final newConfig = state.bubbleConfig.copyWith(selectedColor: color);
    state = state.copyWith(bubbleConfig: newConfig);
    
    // Persist
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSelectedColor, color.name);
  }

  Future<void> updateGameDuration(int seconds) async {
    final newConfig = state.bubbleConfig.copyWith(gameDurationSeconds: seconds);
    state = state.copyWith(
      bubbleConfig: newConfig,
      timeRemainingSeconds: seconds,
    );
    
    // Persist
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kGameDuration, seconds);
  }

  Future<void> updateEnableAppearAnimation(bool enabled) async {
    final newConfig = state.bubbleConfig.copyWith(enableAppearAnimation: enabled);
    state = state.copyWith(bubbleConfig: newConfig);
    
    // Persist
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kEnableAppearAnimation, enabled);
  }

  void pause() {
    if (state.status == AimTestStatus.playing) {
      _timer?.cancel();
      state = state.copyWith(status: AimTestStatus.idle);
    } else if (state.status == AimTestStatus.countdown) {
      _countdownTimer?.cancel();
      state = state.copyWith(status: AimTestStatus.idle);
    }
  }

  void resume() {
    if (state.status == AimTestStatus.idle && state.timeRemainingSeconds > 0) {
      state = state.copyWith(status: AimTestStatus.playing);
      _startTimer();
    }
  }

  void reset() {
    _timer?.cancel();
    _countdownTimer?.cancel();
    state = AimTestState.initial(config: state.bubbleConfig);
  }

  void _saveGameRecord() {
    final dao = ref.read(gameRecordsDaoProvider);
    final duration = state.bubbleConfig.gameDurationSeconds;
    dao.insertRecord(
      GameRecordsCompanion.insert(
        gameType: 'aim_test',
        score: Value(state.score),
        durationSeconds: Value(duration),
        // Store missed count as extra data if needed
      ),
    );
  }
}
