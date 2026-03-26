import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';

import '../../../data/database.dart';
import '../../../data/providers/database_provider.dart';
import 'models/dice_battle_state.dart';
import 'models/dice_battle_player.dart';
import 'models/dice_set.dart';
import 'models/battle_effect.dart';
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

    // Perform coin flip to decide first player after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      if (state.status == GameStatus.coinFlip) {
        flipCoin();
      }
    });
  }

  /// Flip coin to decide first player.
  void flipCoin() {
    state = state.flipCoin();

    // If AI should act, trigger AI turn
    if (state.shouldAiAct()) {
      _performAiTurn();
    }
  }

  /// Roll dice for current player.
  void rollDice() {
    if (state.status != GameStatus.attackRolling &&
        state.status != GameStatus.defenseRolling) {
      return;
    }

    state = state.rollDice();

    // If AI should act, let it select dice
    if (state.shouldAiAct()) {
      _performAiSelection();
    }
  }

  /// Toggle dice selection.
  void toggleDiceSelection(int diceIndex) {
    if (state.status != GameStatus.attackSelecting &&
        state.status != GameStatus.defenseSelecting) {
      return;
    }

    state = state.toggleDiceSelection(diceIndex);
  }

  /// Re-roll selected dice (attack phase only).
  void rerollSelected() {
    if (!state.canReroll) return;
    if (state.currentPlayer.selectedDiceCount == 0) return;

    state = state.performReroll();
  }

  /// Finish attack phase and move to defense.
  void finishAttackPhase() {
    if (state.status != GameStatus.attackSelecting) return;

    state = state.finishAttackPhase();

    // Apply dice upgrade effect if active
    if (state.currentEffect == BattleEffect.diceUpgrade) {
      _applyDiceUpgrade();
    }

    // If AI should defend, trigger AI turn
    if (state.shouldAiAct()) {
      _performAiTurn();
    }
  }

  /// Confirm defense selection and move to damage calculation.
  void confirmDefenseSelection() {
    if (state.status != GameStatus.defenseSelecting) return;

    state = state.confirmDefenseSelection();

    // Handle defense effect apply
    _handleDefenseEffectApply();
  }

  /// Finish defense phase and calculate damage.
  /// Legacy method for backward compatibility.
  void finishDefense() {
    confirmDefenseSelection();
  }

  /// Handle defense effect application and damage calculation.
  void _handleDefenseEffectApply() {
    if (state.status != GameStatus.defenseEffectApply) return;

    // Apply dice swap effect if active
    if (state.currentEffect == BattleEffect.diceSwap) {
      _applyDiceSwap();
    }

    // Move to damage calculation
    state = state.finishDefensePhase();

    // Calculate damage after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _calculateDamage();
    });
  }

  /// Calculate and apply damage.
  void _calculateDamage() {
    state = state.calculateDamage();

    // Show damage animation for 1 second
    Future.delayed(const Duration(seconds: 1), () {
      _finishDamageAnimation();
    });
  }

  /// Finish damage animation and apply final effects.
  void _finishDamageAnimation() {
    if (state.status != GameStatus.damageAnimation) return;

    state = state.finishDamageAnimation();
    state = state.applyFinalEffects();

    // Check if game is over
    if (state.isGameOver) {
      _saveGameRecord();
    } else if (state.status == GameStatus.turnEnd) {
      // End turn and start next round
      Future.delayed(const Duration(milliseconds: 500), () {
        _endTurn();
      });
    }
  }

  /// End turn and start next round.
  void _endTurn() {
    state = state.endTurn();

    // If AI should act, trigger AI turn
    if (state.shouldAiAct()) {
      _performAiTurn();
    }
  }

  // ============================================================
  // AI Logic
  // ============================================================

  /// AI Turn Logic
  Future<void> _performAiTurn() async {
    if (_ai == null || !state.shouldAiAct()) return;

    // Wait for natural feel (1.5 seconds)
    await Future.delayed(const Duration(milliseconds: 1500));

    // Roll dice if in rolling phase
    if (state.status == GameStatus.attackRolling ||
        state.status == GameStatus.defenseRolling) {
      rollDice();
    }
  }

  /// AI Selection Logic
  Future<void> _performAiSelection() async {
    if (_ai == null || !state.shouldAiAct()) return;

    final decision = await _ai!.decideSelection(state);

    // Apply dice selections with delays
    for (final index in decision.selectedDiceIndices) {
      toggleDiceSelection(index);
      await Future.delayed(const Duration(milliseconds: 300));
    }

    // Wait before confirming (1.5 seconds total feel)
    await Future.delayed(const Duration(milliseconds: 800));

    // For attack, AI might want to reroll first
    if (state.status == GameStatus.attackSelecting) {
      await _performAiAttackTurn();
    } else if (state.status == GameStatus.defenseSelecting) {
      confirmDefenseSelection();
    }
  }

  /// AI Attack Turn - handles selection and optional rerolls
  Future<void> _performAiAttackTurn() async {
    if (_ai == null || !state.shouldAiAct()) return;
    if (state.status != GameStatus.attackSelecting) return;

    // Check if AI wants to reroll
    if (state.canReroll) {
      final rerollIndices = await _ai!.decideReroll(state);

      if (rerollIndices.isNotEmpty) {
        // Select dice to reroll
        for (final index in rerollIndices) {
          toggleDiceSelection(index);
        }

        await Future.delayed(const Duration(milliseconds: 800));
        rerollSelected();

        // After reroll, wait then finish
        await Future.delayed(const Duration(milliseconds: 1000));
      }
    }

    // Finish attack phase
    finishAttackPhase();
  }

  // ============================================================
  // Effect Application
  // ============================================================

  /// Apply dice swap effect.
  void _applyDiceSwap() {
    // For simplicity, swap first dice of each player
    state = state.applyDiceSwap(0, 0);
  }

  /// Apply dice upgrade effect.
  void _applyDiceUpgrade() {
    state = state.applyDiceUpgrade();
  }

  // ============================================================
  // Utility Methods
  // ============================================================

  /// Legacy finish attack method for backward compatibility.
  void finishAttack() => finishAttackPhase();

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
