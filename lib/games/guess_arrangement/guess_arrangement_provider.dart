import 'dart:math' as math;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';

import '../../../data/database.dart';
import '../../../data/providers/database_provider.dart';
import 'models/guess_arrangement_state.dart';
import 'ai/guess_ai.dart';
import 'ai/easy_ai.dart';
import 'ai/medium_ai.dart';
import 'ai/hard_ai.dart';

part 'guess_arrangement_provider.g.dart';

/// AI guess result for UI feedback.
class AiGuessResult {
  final int position;
  final int guessedRankValue;
  final bool wasCorrect;

  const AiGuessResult({
    required this.position,
    required this.guessedRankValue,
    required this.wasCorrect,
  });
}

@riverpod
class GuessArrangementGame extends _$GuessArrangementGame {
  GuessAi? _ai;
  bool _isTwoPlayerMode = false;

  @override
  GuessArrangementState build() {
    return GuessArrangementState.idle();
  }

  /// Start a new game with the specified mode
  void startGame({AiDifficulty? aiDifficulty}) {
    _isTwoPlayerMode = aiDifficulty == null;

    state = GuessArrangementState.dealing(
      aiDifficulty: aiDifficulty,
      isDarkMode: false, // Will be updated from theme
    );

    // Initialize AI if needed
    if (aiDifficulty != null) {
      _ai = _createAi(aiDifficulty);
    }
  }

  /// Complete dealing animation and start playing
  void finishDealing() {
    if (state.status == GameStatus.dealing) {
      state = state.startPlaying();
      // AI 先手的情况由 UI 手动触发 startAiTurn()
    }
  }

  /// Make a guess (human player) - only rank matters
  void makeGuess(int position, int guessedRankValue) {
    if (state.status != GameStatus.playing || state.isAiTurn) return;

    final opponent = state.opponentPlayer;
    final actualCard = opponent.hand.cardAt(position);

    // Only compare rank, not suit
    final wasCorrect = actualCard?.rank.value == guessedRankValue;

    final newState = state.makeGuess(position, guessedRankValue);

    state = newState;

    // If game ended, save record
    if (state.isGameOver) {
      _saveGameRecord();
    } else if (!wasCorrect) {
      // Wrong guess - handle turn switching
      if (!_isTwoPlayerMode) {
        // AI mode: switch turns but DON'T start AI yet
        // UI will show dialog and call startAiTurn() after user confirms
        state = state.nextTurn();
      }
      // For 2P mode: don't switch yet, UI will call handleWrongGuess()
    }
  }

  /// Handle wrong guess in 2P mode (shows switch dialog)
  void handleWrongGuess() {
    if (!_isTwoPlayerMode) return;
    state = state.enterSwitching();
  }

  /// Confirm turn switch (2P mode)
  void confirmTurnSwitch() {
    if (state.status == GameStatus.switching) {
      state = state.switchTurn();
    }
  }

  /// Cancel turn switch (2P mode)
  void cancelTurnSwitch() {
    if (state.status == GameStatus.switching) {
      state = state.cancelSwitching();
    }
  }

  /// Process AI turn - returns the decision first, then UI calls applyAiGuess after delay
  Future<AiDecision?> getAiDecision() async {
    if (state.status != GameStatus.playing || !state.isAiTurn || _ai == null) {
      return null;
    }

    // Get available positions to guess
    final hiddenPositions = state.opponentPlayer.hand.hiddenPositions;
    if (hiddenPositions.isEmpty) return null;

    // AI decides what to guess
    return await _ai!.decide(state);
  }

  /// Apply AI guess after showing it to user
  Future<AiGuessResult> applyAiGuess(AiDecision decision) async {
    // Apply the guess (only rank matters)
    final newState = state.makeAiGuess(
      decision.position,
      decision.guessedRankValue,
    );

    // Check result (only compare rank)
    final actualCard = state.opponentPlayer.hand.cardAt(decision.position);
    final wasCorrect = actualCard?.rank.value == decision.guessedRankValue;

    state = newState;

    // If game ended, save record
    if (state.isGameOver) {
      _saveGameRecord();
      return AiGuessResult(
        position: decision.position,
        guessedRankValue: decision.guessedRankValue,
        wasCorrect: wasCorrect,
      );
    }

    // Handle turn switching for AI
    if (!wasCorrect) {
      // AI guessed wrong, switch to human player
      state = state.nextTurn();
    }

    return AiGuessResult(
      position: decision.position,
      guessedRankValue: decision.guessedRankValue,
      wasCorrect: wasCorrect,
    );
  }

  /// Reset to idle state
  void resetGame() {
    state = GuessArrangementState.idle();
    _ai = null;
    _isTwoPlayerMode = false;
  }

  /// Restore a saved game state
  void restoreState(GuessArrangementState savedState) {
    state = savedState;

    // Reinitialize AI if needed
    final aiDiff = state.players
        .where((p) => p.type == PlayerType.ai)
        .firstOrNull
        ?.aiDifficulty;
    if (aiDiff != null) {
      _ai = _createAi(aiDiff);
      _isTwoPlayerMode = false;
    } else {
      _isTwoPlayerMode = true;
    }
  }

  /// Create AI instance based on difficulty
  GuessAi _createAi(AiDifficulty difficulty) {
    switch (difficulty) {
      case AiDifficulty.easy:
        return EasyAi();
      case AiDifficulty.medium:
        return MediumAi();
      case AiDifficulty.hard:
        return HardAi();
    }
  }

  /// Save game record to database
  Future<void> _saveGameRecord() async {
    if (state.winnerIndex == null || state.startTime == null) return;

    final dao = ref.read(gameRecordsDaoProvider);
    final duration = state.duration ?? Duration.zero;

    // Calculate score: correct guesses - wrong guesses
    final player = state.players[0];
    final score =
        player.correctGuesses * 10 -
        (player.totalGuesses - player.correctGuesses) * 5;

    await dao.insertRecord(
      GameRecordsCompanion.insert(
        gameType: 'guess_arrangement',
        score: Value(math.max(0, score)),
        durationSeconds: Value(duration.inSeconds),
        difficulty: Value(state.players[1].aiDifficulty?.name),
        playedAt: Value(DateTime.now()),
      ),
    );
  }
}
