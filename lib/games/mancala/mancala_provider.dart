import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database.dart';
import '../../data/providers/database_provider.dart';
import 'ai/easy_ai.dart';
import 'ai/hard_ai.dart';
import 'ai/mancala_ai.dart';
import 'ai/medium_ai.dart';
import 'models/mancala_state.dart';

part 'mancala_provider.g.dart';

/// Duration for each seed drop animation.
const _seedDropDuration = Duration(milliseconds: 250);

/// Delay after animation completes before AI acts.
const _postAnimationDelay = Duration(seconds: 1);

/// Delay for showing messages (extra turn, capture).
const _messageDisplayDuration = Duration(milliseconds: 800);

/// Riverpod provider for Mancala game state management.
@riverpod
class MancalaGame extends _$MancalaGame {
  Timer? _timer;
  MancalaAi? _ai;
  bool _isAnimating = false;

  @override
  MancalaState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return MancalaState.initial();
  }

  /// Start a new game.
  void startGame({AiDifficulty? aiDifficulty}) {
    _timer?.cancel();
    _ai = _createAi(aiDifficulty);
    _isAnimating = false;
    state = MancalaState.newGame(aiDifficulty: aiDifficulty);
    _startTimer();
  }

  /// Load a saved game.
  void loadGame(MancalaState savedState) {
    _timer?.cancel();
    _ai = _createAi(savedState.aiDifficulty);
    _isAnimating = false;
    state = savedState.copyWith(status: MancalaStatus.playing);
    _startTimer();
  }

  /// Select a pit and start the sowing animation.
  void selectPit(int pitIndex) {
    if (state.status != MancalaStatus.playing) return;
    if (!state.isCurrentPlayerPit(pitIndex)) return;
    if (state.board[pitIndex] == 0) return;
    if (_isAnimating) return; // Prevent animation overlap

    _startSowingAnimation(pitIndex);
  }

  /// Start the sowing animation sequence.
  void _startSowingAnimation(int pitIndex) {
    _isAnimating = true;

    final seeds = state.board[pitIndex];
    final animState = SowingAnimationState.start(
      sourcePitIndex: pitIndex,
      seeds: seeds,
      currentPlayer: state.currentPlayer,
    );

    // Set up initial animation state with source pit emptied
    final newBoard = List<int>.from(state.board);
    newBoard[pitIndex] = 0;

    state = state.copyWith(
      board: newBoard,
      animationPhase: AnimationPhase.sowing,
      sowingAnimation: animState,
    );

    // Start the animation sequence
    _animateNextSeed(animState, newBoard);
  }

  /// Animate dropping the next seed.
  void _animateNextSeed(SowingAnimationState animState, List<int> board) {
    if (animState.seedsInHand == 0) {
      // Animation complete, finalize the turn
      _finalizeSowing(board, animState);
      return;
    }

    // Schedule the next seed drop
    Future.delayed(_seedDropDuration, () {
      if (state.status != MancalaStatus.playing || !_isAnimating) return;

      // Drop one seed at the current position
      final currentDropIndex = animState.currentDropIndex;
      final newBoard = List<int>.from(board);
      newBoard[currentDropIndex]++;

      // Calculate next animation state
      final newAnimState = animState.nextDrop(state.currentPlayer);

      // Update state
      state = state.copyWith(board: newBoard, sowingAnimation: newAnimState);

      // Continue animation
      _animateNextSeed(newAnimState, newBoard);
    });
  }

  /// Finalize the sowing after all seeds are dropped.
  void _finalizeSowing(List<int> board, SowingAnimationState animState) {
    final currentPlayer = state.currentPlayer;
    final storeIndex = currentPlayer == 0 ? 6 : 13;
    final lastLandedIndex = animState.currentDropIndex;

    // Check if last seed landed in player's store (extra turn)
    final landedInStore = lastLandedIndex == storeIndex;

    // Check for capture
    int captured = 0;
    int? captureSource;

    if (!landedInStore && board[lastLandedIndex] == 1) {
      // Check if landed in empty pit on own side
      final isOwnPit = currentPlayer == 0
          ? (lastLandedIndex >= 0 && lastLandedIndex < 6)
          : (lastLandedIndex >= 7 && lastLandedIndex < 13);

      if (isOwnPit) {
        // Calculate opposite pit index
        final oppositeIndex = lastLandedIndex < 6
            ? 12 - lastLandedIndex
            : 12 - lastLandedIndex;

        // Capture if opposite has seeds
        if (board[oppositeIndex] > 0) {
          captured = board[lastLandedIndex] + board[oppositeIndex];
          captureSource = oppositeIndex;
          board[lastLandedIndex] = 0;
          board[oppositeIndex] = 0;
          board[storeIndex] += captured;
        }
      }
    }

    // Check for game over
    final p1Empty = board.sublist(0, 6).every((p) => p == 0);
    final p2Empty = board.sublist(7, 13).every((p) => p == 0);
    bool isGameOver = p1Empty || p2Empty;

    if (isGameOver) {
      // Collect remaining seeds to stores
      board[6] += board.sublist(0, 6).fold(0, (a, b) => a + b);
      board[13] += board.sublist(7, 13).fold(0, (a, b) => a + b);
      for (int i = 0; i < 6; i++) board[i] = 0;
      for (int i = 7; i < 13; i++) board[i] = 0;
    }

    // Determine next player
    int nextPlayer = currentPlayer;
    if (!landedInStore && !isGameOver) {
      nextPlayer = 1 - currentPlayer;
    }

    // Determine next status
    final newStatus = isGameOver
        ? MancalaStatus.gameOver
        : MancalaStatus.playing;

    // Update state with final board
    state = state.copyWith(
      board: board,
      currentPlayer: nextPlayer,
      status: newStatus,
      sowingAnimation: null,
      animationPhase: AnimationPhase.animationComplete,
    );

    // Handle game over
    if (isGameOver) {
      _timer?.cancel();
      _isAnimating = false;
      _saveGameRecord();
      return;
    }

    // Handle messages (extra turn or capture)
    String? message;
    if (landedInStore) {
      message = 'Extra Turn!';
    } else if (captured > 0) {
      message = 'Captured $captured!';
    }

    if (message != null) {
      state = state.copyWith(animationMessage: message);

      // Schedule message clear
      Future.delayed(_messageDisplayDuration, () {
        if (state.status == MancalaStatus.playing) {
          state = state.copyWith(clearAnimation: true);
        }
      });
    }

    // Reset animation flag and schedule AI turn
    _isAnimating = false;

    // Schedule AI turn with delay
    if (state.isAiTurn && state.status == MancalaStatus.playing) {
      _scheduleAiTurnAfterAnimation();
    }
  }

  /// Pause the game.
  void pause() {
    if (state.status == MancalaStatus.playing && !_isAnimating) {
      _timer?.cancel();
      state = state.copyWith(status: MancalaStatus.paused);
    }
  }

  /// Resume the game.
  void resume() {
    if (state.status == MancalaStatus.paused) {
      state = state.copyWith(status: MancalaStatus.playing);
      _startTimer();

      if (state.isAiTurn) {
        _scheduleAiTurnAfterAnimation();
      }
    }
  }

  /// Save the current game.
  Future<int> saveGame(int slotIndex) async {
    final dao = ref.read(mancalaSavesDaoProvider);
    return await dao.saveGame(
      MancalaSavesCompanion.insert(
        slotIndex: Value(slotIndex),
        gameStateJson: jsonEncode(state.toJson()),
        player1Score: state.player1Store,
        player2Score: state.player2Store,
        aiDifficulty: state.aiDifficulty != null
            ? Value(state.aiDifficulty!.index)
            : const Value.absent(),
      ),
    );
  }

  /// Load a game from a save slot.
  Future<void> loadFromSlot(int slotIndex) async {
    final dao = ref.read(mancalaSavesDaoProvider);
    final save = await dao.getSaveBySlot(slotIndex);
    if (save != null) {
      final loadedState = MancalaState.fromJson(
        jsonDecode(save.gameStateJson) as Map<String, dynamic>,
      );
      loadGame(loadedState);
    }
  }

  /// Delete a save slot.
  Future<void> deleteSave(int slotIndex) async {
    final dao = ref.read(mancalaSavesDaoProvider);
    await dao.deleteSaveBySlot(slotIndex);
  }

  /// Check if there's a saved game.
  Future<bool> hasSavedGame() async {
    final dao = ref.read(mancalaSavesDaoProvider);
    return await dao.hasAnySaves();
  }

  /// Get all saved games.
  Future<List<MancalaSave>> getAllSaves() async {
    final dao = ref.read(mancalaSavesDaoProvider);
    return await dao.getAllSaves();
  }

  // ============ Private Methods ============

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.status == MancalaStatus.playing) {
        state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
      }
    });
  }

  MancalaAi? _createAi(AiDifficulty? difficulty) {
    switch (difficulty) {
      case AiDifficulty.easy:
        return EasyAi();
      case AiDifficulty.medium:
        return MediumAi();
      case AiDifficulty.hard:
        return HardAi();
      case null:
        return null;
    }
  }

  /// Schedule AI turn after animation completes.
  void _scheduleAiTurnAfterAnimation() {
    if (_ai == null) return;

    // Wait for post-animation delay, then start AI thinking
    Future.delayed(_postAnimationDelay, () async {
      if (state.status != MancalaStatus.playing || !state.isAiTurn) return;
      if (_isAnimating) return; // Still animating, wait

      final decision = await _ai!.decide(state);

      // Wait for the AI's "thinking" delay
      await Future.delayed(Duration(milliseconds: decision.delayMs));

      // Check if game state is still valid
      if (state.status != MancalaStatus.playing || !state.isAiTurn) return;
      if (_isAnimating) return;

      selectPit(decision.pitIndex);
    });
  }

  /// Save game record to database.
  Future<void> _saveGameRecord() async {
    final dao = ref.read(gameRecordsDaoProvider);
    final scores = state.finalScores;
    final winner = state.winner;

    await dao.insertRecord(
      GameRecordsCompanion.insert(
        gameType: 'mancala',
        score: Value(winner == 0 ? scores.player1 : scores.player2),
        durationSeconds: Value(state.elapsedSeconds),
      ),
    );
  }
}
