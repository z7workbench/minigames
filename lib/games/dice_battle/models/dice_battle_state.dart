import 'dart:math';

import 'dice_battle_player.dart';
import 'battle_effect.dart';
import 'dice_set.dart';

/// Game status enumeration representing the complete turn flow.
///
/// The state machine follows a linear progression through each phase:
/// 1. idle → selectingDiceSet → coinFlip
/// 2. coinFlip → attackRolling (decides first player)
/// 3. Attack phase: attackRolling → attackSelecting → attackRerolling → attackEffectApply
/// 4. Defense phase: defenseRolling → defenseSelecting → defenseEffectApply
/// 5. Resolution: damageCalculating → damageAnimation → finalEffectApply → turnEnd
/// 6. turnEnd → attackRolling (next turn) OR gameOver
enum GameStatus {
  /// Initial state, no game started.
  idle,

  /// Players selecting their dice sets.
  selectingDiceSet,

  /// Coin flip animation to decide who goes first (display 1s).
  coinFlip,

  /// Attacker is rolling their dice.
  attackRolling,

  /// Attacker is selecting which dice to use for attack.
  /// Also can re-roll selected dice (max 2 times) in this state.
  attackSelecting,

  /// Defender is rolling their dice.
  defenseRolling,

  /// Defender is selecting which dice to use for defense.
  defenseSelecting,

  /// Applying defender's special effects.
  defenseEffectApply,

  /// Calculating damage based on attack vs defense.
  damageCalculating,

  /// Showing damage animation (display 1s).
  damageAnimation,

  /// Applying final effects (combo damage, etc.).
  finalEffectApply,

  /// Turn ended, checking for winner.
  turnEnd,

  /// Game over, winner determined.
  gameOver,
}

/// Represents which phase of the turn we're in.
enum TurnPhase {
  /// No active phase.
  none,

  /// Attack phase (rolling, selecting, rerolling).
  attack,

  /// Defense phase (rolling, selecting).
  defense,
}

/// Represents the dice battle game state.
///
/// This class manages the complete state machine for the dice battle game,
/// including player data, turn tracking, and damage calculation.
class DiceBattleState {
  // Core state
  final GameStatus status;
  final TurnPhase turnPhase;
  final List<DiceBattlePlayer> players;
  final int currentPlayerIndex;
  final int roundNumber;

  // Turn tracking
  final int attackerIndex;
  final int rerollsUsed;
  final int turnNumber; // Within a round (1 = attack, 2 = defense)

  // Battle effects
  final BattleEffect? currentEffect;
  final bool isComboActive;
  final int calculatedDamage;
  final int? comboDamage;

  // Game end
  final int? winnerIndex;
  final DateTime? startTime;
  final DateTime? endTime;

  // Legacy fields (kept for backward compatibility)
  final bool isFirstRound;
  final List<String> battleLog;

  const DiceBattleState({
    required this.status,
    required this.turnPhase,
    required this.players,
    required this.currentPlayerIndex,
    required this.roundNumber,
    required this.attackerIndex,
    required this.rerollsUsed,
    required this.turnNumber,
    this.currentEffect,
    this.isComboActive = false,
    this.calculatedDamage = 0,
    this.comboDamage,
    this.winnerIndex,
    this.startTime,
    this.endTime,
    this.isFirstRound = true,
    this.battleLog = const [],
  });

  /// Initial idle state.
  factory DiceBattleState.idle() {
    return const DiceBattleState(
      status: GameStatus.idle,
      turnPhase: TurnPhase.none,
      players: [],
      currentPlayerIndex: 0,
      roundNumber: 0,
      attackerIndex: 0,
      rerollsUsed: 0,
      turnNumber: 1,
      battleLog: [],
    );
  }

  /// Current player (active player in current phase).
  DiceBattlePlayer get currentPlayer => players.isNotEmpty
      ? players[currentPlayerIndex]
      : throw StateError('No players');

  /// Opponent player.
  DiceBattlePlayer get opponentPlayer {
    if (players.length != 2) throw StateError('Only 2-player games supported');
    return players[1 - currentPlayerIndex];
  }

  /// Current attacker (the player whose turn it is to attack).
  DiceBattlePlayer get attacker => players.isNotEmpty
      ? players[attackerIndex]
      : throw StateError('No players');

  /// Current defender (the opponent of the attacker).
  DiceBattlePlayer get defender {
    if (players.length != 2) throw StateError('Only 2-player games supported');
    return players[1 - attackerIndex];
  }

  /// Check if game is over.
  bool get isGameOver => status == GameStatus.gameOver;

  /// Check if current player is AI.
  bool get isAiTurn => currentPlayer.isAi;

  /// Check if attacker is AI.
  bool get isAttackerAi => attacker.isAi;

  /// Check if defender is AI.
  bool get isDefenderAi => defender.isAi;

  /// Get winner (if any).
  DiceBattlePlayer? get winner =>
      winnerIndex != null ? players[winnerIndex!] : null;

  /// Duration of the game.
  Duration? get duration {
    if (startTime == null) return null;
    final end = endTime ?? DateTime.now();
    return end.difference(startTime!);
  }

  /// Check if can re-roll (attack phase only, max 2 times).
  bool get canReroll => status == GameStatus.attackSelecting && rerollsUsed < 2;

  /// Check if AI should act in the current state.
  ///
  /// This method ensures AI only acts on its own turn, preventing
  /// AI from controlling both players.
  bool shouldAiAct() {
    // No AI action in these states
    if (status == GameStatus.idle ||
        status == GameStatus.selectingDiceSet ||
        status == GameStatus.coinFlip ||
        status == GameStatus.damageAnimation ||
        status == GameStatus.turnEnd ||
        status == GameStatus.gameOver) {
      return false;
    }

    // Attack phase: AI acts if attacker is AI
    if (turnPhase == TurnPhase.attack) {
      return isAttackerAi;
    }

    // Defense phase: AI acts if defender is AI
    if (turnPhase == TurnPhase.defense) {
      return isDefenderAi;
    }

    return false;
  }

  /// Get the player who should act in the current state.
  DiceBattlePlayer? get activePlayer {
    switch (turnPhase) {
      case TurnPhase.attack:
        return attacker;
      case TurnPhase.defense:
        return defender;
      case TurnPhase.none:
        return null;
    }
  }

  // ============================================================
  // State Transition Methods
  // ============================================================

  /// Start a new game with the specified players.
  ///
  /// This creates the initial game state and enters the coin flip phase.
  factory DiceBattleState.startGame({
    AiDifficulty? aiDifficulty,
    required DiceSet player1Set,
    required DiceSet player2Set,
  }) {
    final players = aiDifficulty != null
        ? [
            DiceBattlePlayer.initial(
              name: 'Player',
              type: PlayerType.human,
              diceSet: player1Set,
            ),
            DiceBattlePlayer.initial(
              name: 'AI',
              type: PlayerType.ai,
              aiDifficulty: aiDifficulty,
              diceSet: player2Set,
            ),
          ]
        : [
            DiceBattlePlayer.initial(
              name: 'Player 1',
              type: PlayerType.human,
              diceSet: player1Set,
            ),
            DiceBattlePlayer.initial(
              name: 'Player 2',
              type: PlayerType.human,
              diceSet: player2Set,
            ),
          ];

    return DiceBattleState(
      status: GameStatus.coinFlip,
      turnPhase: TurnPhase.none,
      players: players,
      currentPlayerIndex: 0,
      roundNumber: 1,
      attackerIndex: 0,
      rerollsUsed: 0,
      turnNumber: 1,
      startTime: DateTime.now(),
      isFirstRound: true,
      battleLog: ['Game started!'],
    );
  }

  /// Flip coin to decide first player.
  ///
  /// Randomly selects who goes first and enters the attack rolling phase.
  DiceBattleState flipCoin() {
    final random = Random();
    final firstPlayerIndex = random.nextInt(2);
    final firstPlayerName = players[firstPlayerIndex].name;

    return copyWith(
      status: GameStatus.attackRolling,
      turnPhase: TurnPhase.attack,
      currentPlayerIndex: firstPlayerIndex,
      attackerIndex: firstPlayerIndex,
      battleLog: [...battleLog, '$firstPlayerName goes first!'],
    );
  }

  /// Roll all dice for the current player.
  ///
  /// This transitions from rolling state to selecting state.
  DiceBattleState rollDice() {
    // Validate we're in a rolling state
    if (status != GameStatus.attackRolling &&
        status != GameStatus.defenseRolling) {
      return this;
    }

    final newPlayers = List<DiceBattlePlayer>.from(players);
    newPlayers[currentPlayerIndex] = currentPlayer.rollAllDice();

    final newStatus = status == GameStatus.attackRolling
        ? GameStatus.attackSelecting
        : GameStatus.defenseSelecting;

    return copyWith(status: newStatus, players: newPlayers);
  }

  /// Toggle dice selection at the given index.
  DiceBattleState toggleDiceSelection(int diceIndex) {
    // Validate we're in a selecting state
    if (status != GameStatus.attackSelecting &&
        status != GameStatus.defenseSelecting) {
      return this;
    }

    final newPlayers = List<DiceBattlePlayer>.from(players);
    newPlayers[currentPlayerIndex] = currentPlayer.selectDice(diceIndex);

    return copyWith(players: newPlayers);
  }

  /// Perform re-roll of selected dice.
  /// Only available in attackSelecting state with rerollsUsed < 2.
  /// Stays in attackSelecting state after reroll.
  DiceBattleState performReroll() {
    if (!canReroll) return this;
    if (currentPlayer.selectedDiceCount == 0) return this;

    final newPlayers = List<DiceBattlePlayer>.from(players);
    newPlayers[currentPlayerIndex] = currentPlayer.rerollSelected();

    // Stay in attackSelecting, just increment reroll count
    return copyWith(rerollsUsed: rerollsUsed + 1, players: newPlayers);
  }

  /// Finish the attack phase and transition to defense.
  ///
  /// This checks for effects and prepares the defender.
  DiceBattleState finishAttackPhase() {
    if (status != GameStatus.attackSelecting) return this;

    // Check if effect should be drawn
    BattleEffect? newEffect = currentEffect;
    final bool shouldDrawEffect = !isFirstRound;

    if (shouldDrawEffect) {
      newEffect = EffectProcessor.getRandomEffect();
    }

    final defenderIndex = 1 - attackerIndex;

    return copyWith(
      status: GameStatus.defenseRolling,
      turnPhase: TurnPhase.defense,
      currentPlayerIndex: defenderIndex,
      rerollsUsed: 0,
      currentEffect: newEffect,
      battleLog: newEffect != null && newEffect != currentEffect
          ? [...battleLog, 'Effect activated: ${newEffect.displayName}']
          : battleLog,
    );
  }

  /// Finish the defense phase and transition to damage calculation.
  DiceBattleState finishDefensePhase() {
    if (status != GameStatus.defenseEffectApply) return this;

    return copyWith(
      status: GameStatus.damageCalculating,
      turnPhase: TurnPhase.none,
    );
  }

  /// Calculate damage based on attack vs defense values.
  ///
  /// Applies effects and transitions to damage animation.
  DiceBattleState calculateDamage() {
    if (status != GameStatus.damageCalculating) return this;

    // Use attackValue/defenseValue which automatically selects highest dice
    // This ensures correct calculation regardless of isSelected state changes during reroll
    final attackValue = attacker.attackValue;
    final defenseValue = defender.defenseValue;

    int damage = attackValue - defenseValue;
    if (damage < 0) damage = 0;

    // Apply battle effects
    int modifiedDamage = _applyEffectModifiers(
      damage,
      attackValue,
      defenseValue,
    );

    // Calculate combo damage
    int? newComboDamage;
    if (isComboActive && modifiedDamage > 0) {
      newComboDamage = (modifiedDamage / 2).ceil();
    }

    return copyWith(
      status: GameStatus.damageAnimation,
      calculatedDamage: modifiedDamage,
      comboDamage: newComboDamage,
      battleLog: [
        ...battleLog,
        '${attacker.name} attacks with $attackValue power!',
        '${defender.name} defends with $defenseValue power!',
        'Damage: $modifiedDamage',
      ],
    );
  }

  /// Apply damage animation complete and transition to final effects.
  DiceBattleState finishDamageAnimation() {
    if (status != GameStatus.damageAnimation) return this;

    // Apply damage to defender
    final newPlayers = List<DiceBattlePlayer>.from(players);
    final totalDamage = calculatedDamage + (comboDamage ?? 0);
    newPlayers[1 - attackerIndex] = defender.takeDamage(totalDamage);

    return copyWith(status: GameStatus.finalEffectApply, players: newPlayers);
  }

  /// Apply final effects and check for game end.
  DiceBattleState applyFinalEffects() {
    if (status != GameStatus.finalEffectApply) return this;

    final newPlayers = List<DiceBattlePlayer>.from(players);

    // Check for winner
    final winnerIdx = _checkWinner(newPlayers);

    if (winnerIdx != null) {
      return copyWith(
        status: GameStatus.gameOver,
        players: newPlayers,
        winnerIndex: winnerIdx,
        endTime: DateTime.now(),
        battleLog: [
          ...battleLog,
          '${newPlayers[1 - attackerIndex].name} has been defeated!',
          '${players[winnerIdx].name} wins!',
        ],
      );
    }

    // Prepare for next turn
    return copyWith(
      status: GameStatus.turnEnd,
      players: newPlayers,
      battleLog: [
        ...battleLog,
        '${defender.name} has ${newPlayers[1 - attackerIndex].health} HP left',
      ],
    );
  }

  /// End the current turn and start the next.
  ///
  /// Swaps attacker/defender roles and resets turn state.
  DiceBattleState endTurn() {
    if (status != GameStatus.turnEnd) return this;

    // Swap attacker and defender
    final newAttackerIndex = 1 - attackerIndex;

    return copyWith(
      status: GameStatus.attackRolling,
      turnPhase: TurnPhase.attack,
      currentPlayerIndex: newAttackerIndex,
      attackerIndex: newAttackerIndex,
      roundNumber: roundNumber + 1,
      rerollsUsed: 0,
      turnNumber: 1,
      isFirstRound: false,
      calculatedDamage: 0,
      comboDamage: null,
      isComboActive: false,
    );
  }

  // ============================================================
  // Effect Application Methods
  // ============================================================

  /// Apply effect modifiers to damage.
  int _applyEffectModifiers(int baseDamage, int attackValue, int defenseValue) {
    int damage = baseDamage;

    if (currentEffect != null) {
      switch (currentEffect!) {
        case BattleEffect.oddBonus:
          final bonus = EffectProcessor.applyOddBonus(
            attacker.selectedDice.map((d) => d.value).toList(),
          );
          damage += bonus;
          break;
        case BattleEffect.evenBonus:
          final bonus = EffectProcessor.applyEvenBonus(
            defender.selectedDice.map((d) => d.value).toList(),
          );
          damage = (attackValue + bonus) - defenseValue;
          if (damage < 0) damage = 0;
          break;
        case BattleEffect.doubleDamage:
          if (EffectProcessor.shouldComboOnLowDamage(damage)) {
            damage *= 2;
          }
          break;
        default:
          break;
      }
    }

    return damage;
  }

  /// Apply dice swap effect.
  DiceBattleState applyDiceSwap(int attackerIndex, int defenderIndex) {
    final result = attacker.swapDiceWith(
      defender,
      attackerIndex,
      defenderIndex,
    );

    final newPlayers = List<DiceBattlePlayer>.from(players);
    newPlayers[this.attackerIndex] = result[0];
    newPlayers[1 - this.attackerIndex] = result[1];

    return copyWith(
      players: newPlayers,
      battleLog: [...battleLog, 'Dice values swapped between players!'],
    );
  }

  /// Apply dice upgrade effect.
  DiceBattleState applyDiceUpgrade() {
    final newPlayers = List<DiceBattlePlayer>.from(players);
    newPlayers[0] = players[0].upgradeRandomDice();
    newPlayers[1] = players[1].upgradeRandomDice();

    return copyWith(
      players: newPlayers,
      battleLog: [...battleLog, 'Both players upgraded a random dice!'],
    );
  }

  // ============================================================
  // Helper Methods
  // ============================================================

  /// Check if there's a winner.
  static int? _checkWinner(List<DiceBattlePlayer> players) {
    for (var i = 0; i < players.length; i++) {
      if (!players[i].isAlive) {
        return 1 - i; // Other player wins
      }
    }
    return null;
  }

  // ============================================================
  // Backward Compatibility Methods
  // ============================================================

  /// Legacy getter for rerollCount compatibility.
  ///
  /// Use rerollsUsed for new code.
  int get rerollCount => rerollsUsed;

  /// Legacy getter for GamePhase compatibility.
  ///
  /// This maps the new GameStatus to the old GamePhase for UI compatibility.
  GamePhase get phase {
    switch (status) {
      case GameStatus.idle:
      case GameStatus.selectingDiceSet:
        return GamePhase.setup;
      case GameStatus.coinFlip:
        return GamePhase.setup;
      case GameStatus.attackRolling:
      case GameStatus.defenseRolling:
        return GamePhase.rolling;
      case GameStatus.attackSelecting:
        return GamePhase.selectingDice;
      case GameStatus.defenseSelecting:
        return GamePhase.selectingDice;
      case GameStatus.defenseEffectApply:
      case GameStatus.damageCalculating:
      case GameStatus.damageAnimation:
      case GameStatus.finalEffectApply:
      case GameStatus.turnEnd:
        return GamePhase.effectApplying;
      case GameStatus.gameOver:
        return GamePhase.setup;
    }
  }

  /// Confirm defense selection and move to effect apply.
  DiceBattleState confirmDefenseSelection() {
    if (status != GameStatus.defenseSelecting) return this;

    final newPlayers = List<DiceBattlePlayer>.from(players);
    newPlayers[currentPlayerIndex] = currentPlayer.confirmSelection();

    return copyWith(status: GameStatus.defenseEffectApply, players: newPlayers);
  }

  /// Legacy re-roll method for backward compatibility.
  DiceBattleState rerollSelected() => performReroll();

  /// Legacy finish attack method.
  DiceBattleState finishAttack() => finishAttackPhase();

  /// Legacy finish defense method.
  DiceBattleState finishDefense() {
    // Transition from defense selecting to effect apply
    if (status == GameStatus.defenseSelecting) {
      return confirmDefenseSelection();
    }
    return finishDefensePhase();
  }

  // ============================================================
  // Copy With
  // ============================================================

  DiceBattleState copyWith({
    GameStatus? status,
    TurnPhase? turnPhase,
    List<DiceBattlePlayer>? players,
    int? currentPlayerIndex,
    int? roundNumber,
    int? attackerIndex,
    int? rerollsUsed,
    int? turnNumber,
    BattleEffect? currentEffect,
    bool? isComboActive,
    int? calculatedDamage,
    int? comboDamage,
    int? winnerIndex,
    DateTime? startTime,
    DateTime? endTime,
    bool? isFirstRound,
    List<String>? battleLog,
  }) {
    return DiceBattleState(
      status: status ?? this.status,
      turnPhase: turnPhase ?? this.turnPhase,
      players: players ?? this.players,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      roundNumber: roundNumber ?? this.roundNumber,
      attackerIndex: attackerIndex ?? this.attackerIndex,
      rerollsUsed: rerollsUsed ?? this.rerollsUsed,
      turnNumber: turnNumber ?? this.turnNumber,
      currentEffect: currentEffect ?? this.currentEffect,
      isComboActive: isComboActive ?? this.isComboActive,
      calculatedDamage: calculatedDamage ?? this.calculatedDamage,
      comboDamage: comboDamage ?? this.comboDamage,
      winnerIndex: winnerIndex ?? this.winnerIndex,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isFirstRound: isFirstRound ?? this.isFirstRound,
      battleLog: battleLog ?? this.battleLog,
    );
  }
}

/// Legacy GamePhase enum for backward compatibility.
///
/// Use TurnPhase for new code.
enum GamePhase { setup, rolling, selectingDice, rerolling, effectApplying }
