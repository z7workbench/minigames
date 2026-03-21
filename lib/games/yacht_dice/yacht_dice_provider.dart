import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database.dart';
import '../../data/providers/database_provider.dart';
import '../../models/game_type.dart';
import 'ai/easy_ai.dart';
import 'ai/medium_ai.dart';
import 'ai/hard_ai.dart';
import 'ai/yacht_ai.dart';
import 'models/scoring_category.dart';
import 'models/yacht_dice_state.dart';
import 'models/scoring.dart';

part 'yacht_dice_provider.g.dart';

final _random = Random();

@riverpod
class YachtDiceGame extends _$YachtDiceGame {
  @override
  YachtDiceState build() {
    return YachtDiceState.initial(2); // Default to 2 players
  }

  void startGame(
    int playerCount,
    AiDifficulty? aiDifficulty, {
    YachtDiceState? restoredState,
  }) {
    if (restoredState != null) {
      // Restore from saved state - don't auto-roll
      state = restoredState;
      return;
    }

    state = YachtDiceState.initial(playerCount, aiDifficulty);
    // Auto-roll removed - UI layer will call rollDice() for new games
  }

  void rollDice() {
    if (state.isGameOver || state.phase != GamePhase.rolling) {
      return;
    }

    final currentPlayer = state.players[state.currentPlayerIndex];

    if (currentPlayer.rollsRemaining <= 0) {
      return;
    }

    // Roll non-kept dice
    final newDice = List<int>.from(currentPlayer.dice);
    for (var i = 0; i < 5; i++) {
      if (!currentPlayer.kept[i]) {
        newDice[i] = _rollDie();
      }
    }

    final newKept = List<bool>.from(currentPlayer.kept);

    final newRollsRemaining = currentPlayer.rollsRemaining - 1;

    final updatedPlayer = currentPlayer.copyWith(
      dice: newDice,
      kept: newKept,
      rollsRemaining: newRollsRemaining,
    );

    final updatedPlayers = List<PlayerState>.from(state.players);
    updatedPlayers[state.currentPlayerIndex] = updatedPlayer;

    state = state.copyWith(
      players: updatedPlayers,
      phase: GamePhase
          .rolling, // Always stay in rolling phase to allow early category selection
    );

    // If it's AI's turn, let AI continue making decisions
    if (updatedPlayer.type == PlayerType.ai) {
      // Add delay before AI's next action for better UX
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleAiTurn();
      });
    }
  }

  void toggleKeepDie(int index) {
    if (state.isGameOver || state.phase != GamePhase.rolling) {
      return;
    }

    final currentPlayer = state.players[state.currentPlayerIndex];

    if (index < 0 || index >= 5) {
      return;
    }

    final newKept = List<bool>.from(currentPlayer.kept);
    newKept[index] = !newKept[index];

    final updatedPlayer = currentPlayer.copyWith(kept: newKept);

    final updatedPlayers = List<PlayerState>.from(state.players);
    updatedPlayers[state.currentPlayerIndex] = updatedPlayer;

    state = state.copyWith(players: updatedPlayers);
  }

  void selectCategory(ScoringCategory category) {
    final currentPlayer = state.players[state.currentPlayerIndex];

    // Can't select category if dice haven't been rolled (dice values are 0)
    if (currentPlayer.dice.any((d) => d == 0)) {
      return;
    }

    // Allow selection from rolling phase if at least one roll has been made,
    // or from selectingCategory phase
    final canSelectFromRolling =
        state.phase == GamePhase.rolling && currentPlayer.rollsRemaining < 3;

    if (state.isGameOver ||
        (state.phase != GamePhase.selectingCategory && !canSelectFromRolling)) {
      return;
    }

    // Check if category is already used
    if (currentPlayer.scores[category] != null) {
      return;
    }

    // Calculate score for selected category
    final score = calculateScore(currentPlayer.dice, category);

    // Update scores
    final newScores = Map<ScoringCategory, int?>.from(currentPlayer.scores);
    newScores[category] = score;

    // Calculate bonus if this is an upper section category
    int bonusEarned = currentPlayer.bonusEarned;
    if ([
      ScoringCategory.ones,
      ScoringCategory.twos,
      ScoringCategory.threes,
      ScoringCategory.fours,
      ScoringCategory.fives,
      ScoringCategory.sixes,
    ].contains(category)) {
      final upperSectionSum = [
        ScoringCategory.ones,
        ScoringCategory.twos,
        ScoringCategory.threes,
        ScoringCategory.fours,
        ScoringCategory.fives,
        ScoringCategory.sixes,
      ].map((cat) => newScores[cat] ?? 0).reduce((a, b) => a + b);

      bonusEarned = calculateBonus(upperSectionSum);
    }

    // Calculate total score
    final totalScore =
        newScores.values
            .where((score) => score != null)
            .map((score) => score!)
            .reduce((a, b) => a + b) +
        bonusEarned;

    final updatedPlayer = currentPlayer.copyWith(
      scores: newScores,
      totalScore: totalScore,
      bonusEarned: bonusEarned,
      // Reset for next round
      dice: List.filled(5, 1),
      kept: List.filled(5, false),
      rollsRemaining: 3,
    );

    final updatedPlayers = List<PlayerState>.from(state.players);
    updatedPlayers[state.currentPlayerIndex] = updatedPlayer;

    final newRoundsCompleted = state.roundsCompleted + 1;

    state = state.copyWith(
      players: updatedPlayers,
      roundsCompleted: newRoundsCompleted,
    );

    // Check if game is over (all players filled all categories)
    if (state.isGameOver) {
      state = state.copyWith(phase: GamePhase.gameOver);
      _saveGameRecord();
    } else {
      state = state.copyWith(phase: GamePhase.rolling);
      _nextPlayer();
    }
  }

  void _nextPlayer() {
    final nextPlayerIndex =
        (state.currentPlayerIndex + 1) % state.players.length;

    state = state.copyWith(
      currentPlayerIndex: nextPlayerIndex,
      phase: GamePhase.rolling,
    );

    // Handle AI turn if needed
    final nextPlayer = state.players[nextPlayerIndex];
    if (nextPlayer.type == PlayerType.ai) {
      // AI will roll automatically
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleAiTurn();
      });
    }
    // Human player needs to click roll button manually
  }

  Future<void> _handleAiTurn() async {
    if (state.isGameOver) {
      return;
    }

    final currentPlayer = state.players[state.currentPlayerIndex];
    if (currentPlayer.type != PlayerType.ai) {
      return;
    }

    final ai = _getAiForCurrentPlayer();
    if (ai == null) {
      return;
    }

    // If dice are all 0 (not rolled yet), force roll all dice
    if (currentPlayer.dice.every((d) => d == 0)) {
      rollDice();
      return;
    }

    // If no rolls remaining, AI must select a category
    if (currentPlayer.rollsRemaining <= 0) {
      final availableCategories = ScoringCategory.values
          .where((category) => currentPlayer.scores[category] == null)
          .toList();
      if (availableCategories.isNotEmpty) {
        // Select category with highest score
        ScoringCategory? bestCategory;
        int bestScore = -1;
        for (final category in availableCategories) {
          final score = calculateScore(currentPlayer.dice, category);
          if (score > bestScore) {
            bestScore = score;
            bestCategory = category;
          }
        }
        if (bestCategory != null) {
          selectCategory(bestCategory);
        }
      }
      return;
    }

    final decision = await ai.decide(state);

    if (decision.categoryToSelect != null) {
      // AI is selecting a category
      selectCategory(decision.categoryToSelect!);
    } else {
      // AI is deciding which dice to keep
      final updatedPlayer = currentPlayer.copyWith(kept: decision.diceToKeep);

      final updatedPlayers = List<PlayerState>.from(state.players);
      updatedPlayers[state.currentPlayerIndex] = updatedPlayer;

      state = state.copyWith(players: updatedPlayers);

      // AI should roll dice
      rollDice();
    }
  }

  YachtAi? _getAiForCurrentPlayer() {
    final currentPlayer = state.players[state.currentPlayerIndex];
    if (currentPlayer.type != PlayerType.ai) {
      return null;
    }

    switch (state.aiDifficulty) {
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

  int _rollDie() {
    return _random.nextInt(6) + 1;
  }

  void _saveGameRecord() {
    // Find winner
    final winner = state.players.reduce(
      (a, b) => a.totalScore > b.totalScore ? a : b,
    );

    // Save to database using the DAO provider
    final dao = ref.read(gameRecordsDaoProvider);
    dao.insertRecord(
      GameRecordsCompanion.insert(
        gameType: GameType.yachtDice.name,
        score: Value(winner.totalScore),
        durationSeconds: const Value(0), // TODO: track actual duration
      ),
    );
  }

  PlayerState? getWinner() {
    if (!state.isGameOver) {
      return null;
    }

    return state.players.reduce((a, b) => a.totalScore > b.totalScore ? a : b);
  }

  /// Save current game state to database
  Future<void> saveGameState() async {
    if (state.isGameOver) return;

    final dao = ref.read(yachtDiceSavesDaoProvider);
    await dao.saveGame(
      YachtDiceSavesCompanion.insert(
        gameType: 'yacht_dice',
        difficulty: Value(state.aiDifficulty?.name),
        gameStateJson: jsonEncode(state.toJson()),
      ),
    );
  }

  /// Check for saved game and return it if exists
  Future<YachtDiceState?> checkForSavedGame(AiDifficulty? difficulty) async {
    try {
      final dao = ref.read(yachtDiceSavesDaoProvider);
      final save = await dao.getMostRecentSave('yacht_dice', difficulty?.name);
      if (save == null) return null;

      return YachtDiceState.fromJson(
        jsonDecode(save.gameStateJson) as Map<String, dynamic>,
      );
    } catch (e) {
      // If there's any error (table doesn't exist, corrupted data, etc.)
      // return null and let the user start a fresh game
      return null;
    }
  }

  /// Delete saved game for the given difficulty
  Future<void> deleteSavedGame(AiDifficulty? difficulty) async {
    final dao = ref.read(yachtDiceSavesDaoProvider);
    await dao.deleteSavesByGameTypeAndDifficulty(
      'yacht_dice',
      difficulty?.name,
    );
  }

  /// Start the first roll for a new game (called by UI)
  void startFirstRoll() {
    if (!state.isGameOver && state.phase == GamePhase.rolling) {
      final currentPlayer = state.players[state.currentPlayerIndex];
      if (currentPlayer.type == PlayerType.ai) {
        _handleAiTurn();
      } else {
        rollDice();
      }
    }
  }
}
