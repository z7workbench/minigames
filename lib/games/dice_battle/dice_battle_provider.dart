import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';

import '../../../data/database.dart';
import '../../../data/providers/database_provider.dart';
import 'models/dice_battle_state.dart';
import 'models/dice_battle_player.dart';
import 'models/dice_set.dart';
import 'ai/dice_battle_ai.dart';
import 'ai/easy_ai.dart';
import 'ai/medium_ai.dart';
import 'ai/hard_ai.dart';

part 'dice_battle_provider.g.dart';

@riverpod
class DiceBattleGame extends _$DiceBattleGame {
  DiceBattleAi? _ai;

  @override
  DiceBattleState build() {
    return DiceBattleState.idle();
  }

  /// Start a new game with the specified mode and dice sets.
  void startGame({
    AiDifficulty? aiDifficulty,
    required DiceSet player1Set,
    required DiceSet player2Set,
  }) {
    state = DiceBattleState.startGame(
      aiDifficulty: aiDifficulty,
      player1Set: player1Set,
      player2Set: player2Set,
    );

    // Initialize AI if needed
    if (aiDifficulty != null) {
      _ai = _createAi(aiDifficulty);
    }

    // Perform coin flip to decide first player
    Future.delayed(const Duration(seconds: 1), () {
      if (state.status == GameStatus.coinFlip) {
        flipCoin();
      }
    });
  }

  /// Flip coin to decide first player.
  void flipCoin() {
    state = state.flipCoin();

    // If AI goes first, trigger AI turn
    if (state.isAiTurn && state.status == GameStatus.attacking) {
      _performAiTurn();
    }
  }

  /// Roll dice for current player.
  void rollDice() {
    if (state.status != GameStatus.attacking &&
        state.status != GameStatus.defending) {
      return;
    }

    state = state.rollDice();

    // If AI's turn, let it select dice
    if (state.isAiTurn) {
      _performAiSelection();
    }
  }

  /// Toggle dice selection.
  void toggleDiceSelection(int diceIndex) {
    if (state.phase != GamePhase.selectingDice) return;

    state = state.toggleDiceSelection(diceIndex);
  }

  /// Confirm dice selection and move to next phase.
  void confirmDiceSelection() {
    if (state.phase != GamePhase.selectingDice) return;

    state = state.confirmDiceSelection();

    // If AI's turn in attack phase, decide on re-roll
    if (state.isAiTurn &&
        state.status == GameStatus.attacking &&
        state.canReroll) {
      _performAiReroll();
    }
  }

  /// Re-roll selected dice.
  void rerollSelected() {
    if (!state.canReroll) return;

    state = state.rerollSelected();
  }

  /// Finish attack phase and move to defense.
  void finishAttack() {
    if (state.status != GameStatus.attacking) return;

    state = state.finishAttack();

    // Switch to AI if playing against AI
    if (state.isAiTurn) {
      _performAiTurn();
    }
  }

  /// Finish defense phase and calculate damage.
  void finishDefense() {
    if (state.status != GameStatus.defending) return;

    state = state.finishDefense();

    // Apply dice swap effect if active
    if (state.currentEffect != null &&
        state.currentEffect.toString() == 'BattleEffect.diceSwap') {
      _applyDiceSwap();
    }

    // Apply dice upgrade effect if active
    if (state.currentEffect != null &&
        state.currentEffect.toString() == 'BattleEffect.diceUpgrade') {
      _applyDiceUpgrade();
    }

    // Calculate damage after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _calculateDamage();
    });
  }

  /// AI Turn Logic
  Future<void> _performAiTurn() async {
    if (_ai == null || !state.isAiTurn) return;

    // Wait a bit for natural feel
    await Future.delayed(const Duration(milliseconds: 800));

    // Roll dice
    if (state.phase == GamePhase.rolling) {
      rollDice();
    }
  }

  /// AI Selection Logic
  Future<void> _performAiSelection() async {
    if (_ai == null || !state.isAiTurn) return;

    final decision = await _ai!.decideSelection(state);

    // Apply dice selections
    for (final index in decision.selectedDiceIndices) {
      toggleDiceSelection(index);
      await Future.delayed(const Duration(milliseconds: 200));
    }

    // Confirm selection
    await Future.delayed(const Duration(milliseconds: 500));
    confirmDiceSelection();
  }

  /// AI Reroll Logic
  Future<void> _performAiReroll() async {
    if (_ai == null || !state.isAiTurn) return;

    final rerollIndices = await _ai!.decideReroll(state);

    if (rerollIndices.isEmpty) {
      // AI decides not to re-roll
      finishAttack();
      return;
    }

    // Select dice to re-roll
    for (final index in rerollIndices) {
      toggleDiceSelection(index);
    }

    await Future.delayed(const Duration(milliseconds: 500));
    rerollSelected();

    await Future.delayed(const Duration(milliseconds: 800));
    finishAttack();
  }

  /// Calculate and apply damage.
  void _calculateDamage() {
    state = state.calculateDamage();

    // Save game record if game is over
    if (state.isGameOver) {
      _saveGameRecord();
    } else if (state.isAiTurn) {
      // AI's turn next
      _performAiTurn();
    }
  }

  /// Apply dice swap effect.
  void _applyDiceSwap() {
    // For simplicity, swap first dice of each player
    state = state.applyDiceSwap(0, 0);
  }

  /// Apply dice upgrade effect.
  void _applyDiceUpgrade() {
    state = state.applyDiceUpgrade();
  }

  /// Skip re-roll and finish attack.
  void skipReroll() {
    finishAttack();
  }

  /// Reset game to idle state.
  void resetGame() {
    state = DiceBattleState.idle();
    _ai = null;
  }

  /// Create AI instance based on difficulty.
  DiceBattleAi _createAi(AiDifficulty difficulty) {
    switch (difficulty) {
      case AiDifficulty.easy:
        return EasyAi();
      case AiDifficulty.medium:
        return MediumAi();
      case AiDifficulty.hard:
        return HardAi();
    }
  }

  /// Save game record to database.
  Future<void> _saveGameRecord() async {
    if (state.winnerIndex == null || state.startTime == null) return;

    final dao = ref.read(gameRecordsDaoProvider);
    final duration = state.duration ?? Duration.zero;

    // Calculate score based on remaining health
    final playerHealth = state.players[0].health;
    final score = playerHealth * 10;

    // Get AI difficulty if playing against AI
    String? difficulty;
    if (state.players[1].isAi) {
      difficulty = state.players[1].aiDifficulty?.name;
    }

    await dao.insertRecord(
      GameRecordsCompanion.insert(
        gameType: 'dice_battle',
        score: Value(score),
        durationSeconds: Value(duration.inSeconds),
        difficulty: Value(difficulty),
        playedAt: Value(DateTime.now()),
      ),
    );
  }
}
