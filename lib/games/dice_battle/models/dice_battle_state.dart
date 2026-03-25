import 'dart:math';

import 'dice_battle_player.dart';
import 'battle_effect.dart';
import 'dice_set.dart';

/// Game status enumeration.
enum GameStatus {
  idle, // Initial state
  selectingDiceSet, // Players selecting their dice sets
  coinFlip, // Deciding who goes first
  attacking, // Attack phase
  defending, // Defense phase
  calculating, // Calculating damage
  switching, // Switching turns (2P mode)
  gameOver, // Game ended
}

/// Game phase enumeration.
enum GamePhase {
  setup, // Initial setup
  rolling, // Rolling dice
  selectingDice, // Selecting which dice to use
  rerolling, // Re-rolling dice (attack only)
  effectApplying, // Applying battle effects
}

/// Represents the dice battle game state.
class DiceBattleState {
  final GameStatus status;
  final GamePhase phase;
  final List<DiceBattlePlayer> players;
  final int currentPlayerIndex;
  final int roundNumber;
  final int turnNumber; // Within a round (1 = attack, 2 = defense)
  final BattleEffect? currentEffect;
  final int? winnerIndex;
  final DateTime? startTime;
  final DateTime? endTime;
  final int rerollCount; // Only for attack phase
  final bool isFirstRound;
  final List<String> battleLog;

  const DiceBattleState({
    required this.status,
    required this.phase,
    required this.players,
    required this.currentPlayerIndex,
    required this.roundNumber,
    required this.turnNumber,
    this.currentEffect,
    this.winnerIndex,
    this.startTime,
    this.endTime,
    this.rerollCount = 0,
    this.isFirstRound = true,
    this.battleLog = const [],
  });

  /// Initial idle state.
  factory DiceBattleState.idle() {
    return DiceBattleState(
      status: GameStatus.idle,
      phase: GamePhase.setup,
      players: const [],
      currentPlayerIndex: 0,
      roundNumber: 0,
      turnNumber: 1,
      battleLog: const [],
    );
  }

  /// Current player (attacker or defender).
  DiceBattlePlayer get currentPlayer => players.isNotEmpty
      ? players[currentPlayerIndex]
      : throw StateError('No players');

  /// Opponent player.
  DiceBattlePlayer get opponentPlayer {
    if (players.length != 2) throw StateError('Only 2-player games supported');
    return players[1 - currentPlayerIndex];
  }

  /// Check if game is over.
  bool get isGameOver => status == GameStatus.gameOver;

  /// Check if current player is AI.
  bool get isAiTurn => currentPlayer.isAi;

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
  bool get canReroll =>
      phase == GamePhase.rerolling &&
      rerollCount < 2 &&
      status == GameStatus.attacking;

  /// Start a new game.
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
      phase: GamePhase.setup,
      players: players,
      currentPlayerIndex: 0,
      roundNumber: 1,
      turnNumber: 1,
      startTime: DateTime.now(),
      isFirstRound: true,
      battleLog: ['Game started!'],
    );
  }

  /// Flip coin to decide first player.
  DiceBattleState flipCoin() {
    final random = Random();
    final firstPlayerIndex = random.nextInt(2);
    final firstPlayerName = players[firstPlayerIndex].name;

    return copyWith(
      status: GameStatus.attacking,
      phase: GamePhase.rolling,
      currentPlayerIndex: firstPlayerIndex,
      battleLog: [...battleLog, '$firstPlayerName goes first!'],
    );
  }

  /// Roll all dice for current player.
  DiceBattleState rollDice() {
    final newPlayers = List<DiceBattlePlayer>.from(players);
    newPlayers[currentPlayerIndex] = currentPlayer.rollAllDice();

    return copyWith(phase: GamePhase.selectingDice, players: newPlayers);
  }

  /// Toggle dice selection.
  DiceBattleState toggleDiceSelection(int diceIndex) {
    final newPlayers = List<DiceBattlePlayer>.from(players);
    newPlayers[currentPlayerIndex] = currentPlayer.selectDice(diceIndex);

    return copyWith(players: newPlayers);
  }

  /// Confirm dice selection.
  DiceBattleState confirmDiceSelection() {
    final newPlayers = List<DiceBattlePlayer>.from(players);
    newPlayers[currentPlayerIndex] = currentPlayer.confirmSelection();

    return copyWith(phase: GamePhase.rerolling, players: newPlayers);
  }

  /// Re-roll selected dice.
  DiceBattleState rerollSelected() {
    if (!canReroll) return this;

    final newPlayers = List<DiceBattlePlayer>.from(players);
    newPlayers[currentPlayerIndex] = currentPlayer.rerollSelected();

    return copyWith(rerollCount: rerollCount + 1, players: newPlayers);
  }

  /// Finish attack phase and move to defense.
  DiceBattleState finishAttack() {
    // Check if effect should be drawn
    BattleEffect? newEffect = currentEffect;
    final bool isFirstAttack = isFirstRound && turnNumber == 1;

    if (!isFirstAttack && turnNumber == 2) {
      // Every 2 attack+defense rounds, draw new effect
      newEffect = EffectProcessor.getRandomEffect();
    }

    return copyWith(
      status: GameStatus.defending,
      phase: GamePhase.rolling,
      turnNumber: 2,
      currentEffect: newEffect,
      rerollCount: 0,
      battleLog: newEffect != null && newEffect != currentEffect
          ? [...battleLog, 'Effect activated: ${newEffect.displayName}']
          : battleLog,
    );
  }

  /// Finish defense phase and calculate damage.
  DiceBattleState finishDefense() {
    return copyWith(
      status: GameStatus.calculating,
      phase: GamePhase.effectApplying,
    );
  }

  /// Calculate and apply damage.
  DiceBattleState calculateDamage() {
    final attacker = currentPlayer;
    final defender = opponentPlayer;

    int attackValue = attacker.selectedDiceSum;
    int defenseValue = defender.selectedDiceSum;

    // Apply effects
    if (currentEffect != null) {
      switch (currentEffect!) {
        case BattleEffect.oddBonus:
          final bonus = EffectProcessor.applyOddBonus(
            attacker.selectedDice.map((d) => d.value).toList(),
          );
          attackValue += bonus;
          break;
        case BattleEffect.evenBonus:
          final bonus = EffectProcessor.applyEvenBonus(
            defender.selectedDice.map((d) => d.value).toList(),
          );
          defenseValue += bonus;
          break;
        case BattleEffect.diceSwap:
          // Handled separately before damage calculation
          break;
        default:
          break;
      }
    }

    int damage = attackValue - defenseValue;
    if (damage < 0) damage = 0;

    // Double damage effect
    if (currentEffect == BattleEffect.doubleDamage &&
        damage > 0 &&
        damage < 10) {
      damage *= 2;
    }

    final newPlayers = List<DiceBattlePlayer>.from(players);
    newPlayers[1 - currentPlayerIndex] = defender.takeDamage(damage);

    // Check for winner
    final winnerIdx = _checkWinner(newPlayers);

    if (winnerIdx != null) {
      return copyWith(
        status: GameStatus.gameOver,
        phase: GamePhase.setup,
        players: newPlayers,
        winnerIndex: winnerIdx,
        endTime: DateTime.now(),
        battleLog: [
          ...battleLog,
          '${attacker.name} deals $damage damage!',
          '${newPlayers[1 - currentPlayerIndex].name} has been defeated!',
          '${players[winnerIdx].name} wins!',
        ],
      );
    }

    // Switch turns
    return copyWith(
      status: GameStatus.attacking,
      phase: GamePhase.rolling,
      players: newPlayers,
      currentPlayerIndex: 1 - currentPlayerIndex,
      roundNumber: roundNumber + 1,
      turnNumber: 1,
      isFirstRound: false,
      rerollCount: 0,
      battleLog: [
        ...battleLog,
        '${attacker.name} deals $damage damage!',
        '${defender.name} has ${newPlayers[1 - currentPlayerIndex].health} HP left',
      ],
    );
  }

  /// Apply dice swap effect.
  DiceBattleState applyDiceSwap(int attackerIndex, int defenderIndex) {
    final result = currentPlayer.swapDiceWith(
      opponentPlayer,
      attackerIndex,
      defenderIndex,
    );

    final newPlayers = List<DiceBattlePlayer>.from(players);
    newPlayers[currentPlayerIndex] = result[0];
    newPlayers[1 - currentPlayerIndex] = result[1];

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

  /// Check if there's a winner.
  static int? _checkWinner(List<DiceBattlePlayer> players) {
    for (var i = 0; i < players.length; i++) {
      if (!players[i].isAlive) {
        return 1 - i; // Other player wins
      }
    }
    return null;
  }

  DiceBattleState copyWith({
    GameStatus? status,
    GamePhase? phase,
    List<DiceBattlePlayer>? players,
    int? currentPlayerIndex,
    int? roundNumber,
    int? turnNumber,
    BattleEffect? currentEffect,
    int? winnerIndex,
    DateTime? startTime,
    DateTime? endTime,
    int? rerollCount,
    bool? isFirstRound,
    List<String>? battleLog,
  }) {
    return DiceBattleState(
      status: status ?? this.status,
      phase: phase ?? this.phase,
      players: players ?? this.players,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      roundNumber: roundNumber ?? this.roundNumber,
      turnNumber: turnNumber ?? this.turnNumber,
      currentEffect: currentEffect ?? this.currentEffect,
      winnerIndex: winnerIndex ?? this.winnerIndex,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      rerollCount: rerollCount ?? this.rerollCount,
      isFirstRound: isFirstRound ?? this.isFirstRound,
      battleLog: battleLog ?? this.battleLog,
    );
  }
}
