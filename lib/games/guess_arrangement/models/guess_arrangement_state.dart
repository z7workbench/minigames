import 'dart:math';

import 'playing_card.dart';

/// Game status enumeration.
enum GameStatus {
  idle, // Initial state, game not started
  dealing, // Cards are being dealt
  playing, // Game in progress
  switching, // Switching between players (2P mode)
  won, // Game ended with a winner
  drawn, // Game ended in a draw
}

/// Player type enumeration.
enum PlayerType { human, ai }

/// AI difficulty levels.
enum AiDifficulty { easy, medium, hard }

/// Represents a single guess made by a player.
class GuessRecord {
  final int position;
  final PlayingCard guessedCard;
  final bool wasCorrect;
  final DateTime timestamp;

  const GuessRecord({
    required this.position,
    required this.guessedCard,
    required this.wasCorrect,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'position': position,
    'guessedCard': guessedCard.toJson(),
    'wasCorrect': wasCorrect,
    'timestamp': timestamp.toIso8601String(),
  };

  factory GuessRecord.fromJson(Map<String, dynamic> json) {
    return GuessRecord(
      position: json['position'] as int,
      guessedCard: PlayingCard.fromJson(
        json['guessedCard'] as Map<String, dynamic>,
      ),
      wasCorrect: json['wasCorrect'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

/// Represents a player in the game.
class GuessPlayer {
  final String name;
  final PlayerType type;
  final AiDifficulty? aiDifficulty;
  final CardHand hand;
  final List<GuessRecord> guessHistory;
  final int currentCombo;
  final int maxCombo;

  const GuessPlayer({
    required this.name,
    required this.type,
    this.aiDifficulty,
    required this.hand,
    required this.guessHistory,
    required this.currentCombo,
    required this.maxCombo,
  });

  /// Create initial player with cards
  factory GuessPlayer.initial({
    required String name,
    required PlayerType type,
    AiDifficulty? aiDifficulty,
    required List<PlayingCard> cards,
  }) {
    // Sort cards by rank (low to high)
    final sortedCards = List<PlayingCard>.from(cards)
      ..sort((a, b) => a.compareTo(b));

    return GuessPlayer(
      name: name,
      type: type,
      aiDifficulty: aiDifficulty,
      hand: CardHand.initial(sortedCards),
      guessHistory: const [],
      currentCombo: 0,
      maxCombo: 0,
    );
  }

  /// Total number of guesses made
  int get totalGuesses => guessHistory.length;

  /// Number of correct guesses
  int get correctGuesses => guessHistory.where((g) => g.wasCorrect).length;

  /// Check if player has won (all opponent cards revealed)
  bool get hasWon => hand.isFullyRevealed;

  /// Make a guess (updates history and combo)
  GuessPlayer makeGuess(GuessRecord record) {
    final newCombo = record.wasCorrect ? currentCombo + 1 : 0;
    final newMaxCombo = newCombo > maxCombo ? newCombo : maxCombo;

    return copyWith(
      guessHistory: [...guessHistory, record],
      currentCombo: newCombo,
      maxCombo: newMaxCombo,
    );
  }

  /// Reset combo (after wrong guess or turn switch)
  GuessPlayer resetCombo() => copyWith(currentCombo: 0);

  GuessPlayer copyWith({
    String? name,
    PlayerType? type,
    AiDifficulty? aiDifficulty,
    CardHand? hand,
    List<GuessRecord>? guessHistory,
    int? currentCombo,
    int? maxCombo,
  }) {
    return GuessPlayer(
      name: name ?? this.name,
      type: type ?? this.type,
      aiDifficulty: aiDifficulty ?? this.aiDifficulty,
      hand: hand ?? this.hand,
      guessHistory: guessHistory ?? this.guessHistory,
      currentCombo: currentCombo ?? this.currentCombo,
      maxCombo: maxCombo ?? this.maxCombo,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type.name,
    'aiDifficulty': aiDifficulty?.name,
    'hand': hand.toJson(),
    'guessHistory': guessHistory.map((g) => g.toJson()).toList(),
    'currentCombo': currentCombo,
    'maxCombo': maxCombo,
  };

  factory GuessPlayer.fromJson(Map<String, dynamic> json) {
    return GuessPlayer(
      name: json['name'] as String,
      type: PlayerType.values.byName(json['type'] as String),
      aiDifficulty: json['aiDifficulty'] != null
          ? AiDifficulty.values.byName(json['aiDifficulty'] as String)
          : null,
      hand: CardHand.fromJson(json['hand'] as Map<String, dynamic>),
      guessHistory: (json['guessHistory'] as List)
          .map((g) => GuessRecord.fromJson(g as Map<String, dynamic>))
          .toList(),
      currentCombo: json['currentCombo'] as int,
      maxCombo: json['maxCombo'] as int,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GuessPlayer &&
        name == other.name &&
        type == other.type &&
        aiDifficulty == other.aiDifficulty &&
        hand == other.hand &&
        currentCombo == other.currentCombo &&
        maxCombo == other.maxCombo;
  }

  @override
  int get hashCode =>
      Object.hash(name, type, aiDifficulty, hand, currentCombo, maxCombo);
}

/// Main game state for Guess Arrangement.
class GuessArrangementState {
  final GameStatus status;
  final List<GuessPlayer> players;
  final int currentPlayerIndex;
  final int roundNumber;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? winnerIndex;
  final bool isDarkMode;

  const GuessArrangementState({
    required this.status,
    required this.players,
    required this.currentPlayerIndex,
    required this.roundNumber,
    this.startTime,
    this.endTime,
    this.winnerIndex,
    this.isDarkMode = false,
  });

  /// Initial idle state
  factory GuessArrangementState.idle({bool isDarkMode = false}) {
    return GuessArrangementState(
      status: GameStatus.idle,
      players: const [],
      currentPlayerIndex: 0,
      roundNumber: 0,
      isDarkMode: isDarkMode,
    );
  }

  /// Current player
  GuessPlayer get currentPlayer => players.isNotEmpty
      ? players[currentPlayerIndex]
      : throw StateError('No players');

  /// Opponent player (for 2-player games)
  GuessPlayer get opponentPlayer {
    if (players.length != 2) throw StateError('Only 2-player games supported');
    return players[1 - currentPlayerIndex];
  }

  /// Check if current player is AI
  bool get isAiTurn => currentPlayer.type == PlayerType.ai;

  /// Check if game is over
  bool get isGameOver => status == GameStatus.won || status == GameStatus.drawn;

  /// Get winner (if any)
  GuessPlayer? get winner => winnerIndex != null ? players[winnerIndex!] : null;

  /// Duration of the game
  Duration? get duration {
    if (startTime == null) return null;
    final end = endTime ?? DateTime.now();
    return end.difference(startTime!);
  }

  /// Create dealing state with generated cards
  /// Cards are drawn from a single 52-card deck without replacement
  factory GuessArrangementState.dealing({
    required AiDifficulty? aiDifficulty,
    required bool isDarkMode,
  }) {
    final random = Random();

    // Create a full 52-card deck
    final deck = <PlayingCard>[];
    for (var suitIndex = 0; suitIndex < 4; suitIndex++) {
      for (var rankValue = 1; rankValue <= 13; rankValue++) {
        deck.add(
          PlayingCard.fromValues(suitIndex: suitIndex, rankValue: rankValue),
        );
      }
    }

    // Shuffle the deck
    for (var i = deck.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = deck[i];
      deck[i] = deck[j];
      deck[j] = temp;
    }

    // Draw 8 cards for each player (total 16 cards from the deck)
    final player1Cards = deck.sublist(0, 8);
    final player2Cards = deck.sublist(8, 16);

    final players = aiDifficulty != null
        ? [
            GuessPlayer.initial(
              name: '玩家',
              type: PlayerType.human,
              cards: player1Cards,
            ),
            GuessPlayer.initial(
              name: 'AI',
              type: PlayerType.ai,
              aiDifficulty: aiDifficulty,
              cards: player2Cards,
            ),
          ]
        : [
            GuessPlayer.initial(
              name: '玩家1',
              type: PlayerType.human,
              cards: player1Cards,
            ),
            GuessPlayer.initial(
              name: '玩家2',
              type: PlayerType.human,
              cards: player2Cards,
            ),
          ];

    return GuessArrangementState(
      status: GameStatus.dealing,
      players: players,
      currentPlayerIndex: 0,
      roundNumber: 1,
      startTime: DateTime.now(),
      isDarkMode: isDarkMode,
    );
  }

  /// Start playing after dealing animation
  GuessArrangementState startPlaying() {
    return copyWith(status: GameStatus.playing);
  }

  /// Make a guess (only rank matters, not suit)
  /// Returns the new state. Caller is responsible for handling turn switching.
  GuessArrangementState makeGuess(int position, int guessedRankValue) {
    if (status != GameStatus.playing) return this;
    if (isAiTurn) return this; // AI guesses are handled separately

    final opponent = opponentPlayer;
    final actualCard = opponent.hand.cardAt(position);

    if (actualCard == null) return this;

    // Only compare rank, not suit
    final isCorrect = actualCard.rank.value == guessedRankValue;

    // Create a dummy card for the guess record
    final guessedCard = PlayingCard(
      suit: CardSuit.spades,
      rank: CardRank.values[guessedRankValue - 1],
    );

    // Record the guess
    final newCurrentPlayer = currentPlayer.makeGuess(
      GuessRecord(
        position: position,
        guessedCard: guessedCard,
        wasCorrect: isCorrect,
        timestamp: DateTime.now(),
      ),
    );

    // Reveal opponent's card if correct
    GuessPlayer newOpponent;
    if (isCorrect) {
      newOpponent = opponent.copyWith(
        hand: opponent.hand.revealPosition(position),
      );
    } else {
      newOpponent = opponent;
    }

    // Update players list
    final newPlayers = List<GuessPlayer>.from(players);
    newPlayers[currentPlayerIndex] = newCurrentPlayer;
    newPlayers[1 - currentPlayerIndex] = newOpponent;

    // Check for winner
    final winnerIdx = _checkWinnerState(newPlayers);

    if (winnerIdx != null) {
      return copyWith(
        players: newPlayers,
        status: GameStatus.won,
        winnerIndex: winnerIdx,
        endTime: DateTime.now(),
      );
    }

    // Don't auto-switch turns here - let the provider handle it
    // Just return the updated state
    return copyWith(players: newPlayers);
  }

  /// Switch to the next player (used after wrong guess)
  GuessArrangementState nextTurn() {
    return copyWith(
      currentPlayerIndex: 1 - currentPlayerIndex,
      roundNumber: roundNumber + 1,
    );
  }

  /// Make an AI guess (only rank matters, not suit)
  GuessArrangementState makeAiGuess(int position, int guessedRankValue) {
    if (status != GameStatus.playing) return this;
    if (!isAiTurn) return this;

    final opponent = opponentPlayer;
    final actualCard = opponent.hand.cardAt(position);

    if (actualCard == null) return this;

    // Only compare rank, not suit
    final isCorrect = actualCard.rank.value == guessedRankValue;

    // Create a dummy card for the guess record
    final guessedCard = PlayingCard(
      suit: CardSuit.spades,
      rank: CardRank.values[guessedRankValue - 1],
    );

    // Record the guess
    final newCurrentPlayer = currentPlayer.makeGuess(
      GuessRecord(
        position: position,
        guessedCard: guessedCard,
        wasCorrect: isCorrect,
        timestamp: DateTime.now(),
      ),
    );

    // Reveal opponent's card if correct
    GuessPlayer newOpponent;
    if (isCorrect) {
      newOpponent = opponent.copyWith(
        hand: opponent.hand.revealPosition(position),
      );
    } else {
      newOpponent = opponent;
    }

    // Update players list
    final newPlayers = List<GuessPlayer>.from(players);
    newPlayers[currentPlayerIndex] = newCurrentPlayer;
    newPlayers[1 - currentPlayerIndex] = newOpponent;

    // Check for winner
    final winnerIdx = _checkWinnerState(newPlayers);

    if (winnerIdx != null) {
      return copyWith(
        players: newPlayers,
        status: GameStatus.won,
        winnerIndex: winnerIdx,
        endTime: DateTime.now(),
      );
    }

    // Don't auto-switch turns here - let the provider handle it
    // Just return the updated state
    return copyWith(players: newPlayers);
  }

  /// Switch turns (for 2P mode with confirmation)
  GuessArrangementState switchTurn() {
    if (status != GameStatus.switching) return this;
    return copyWith(
      status: GameStatus.playing,
      currentPlayerIndex: 1 - currentPlayerIndex,
      roundNumber: roundNumber + 1,
    );
  }

  /// Enter switching state (for 2P mode)
  GuessArrangementState enterSwitching() {
    if (status != GameStatus.playing) return this;
    return copyWith(
      status: GameStatus.switching,
      players: players
          .asMap()
          .entries
          .map(
            (e) => e.key == currentPlayerIndex ? e.value.resetCombo() : e.value,
          )
          .toList(),
    );
  }

  /// Cancel switching (go back to playing)
  GuessArrangementState cancelSwitching() {
    if (status != GameStatus.switching) return this;
    return copyWith(status: GameStatus.playing);
  }

  static int? _checkWinnerState(List<GuessPlayer> players) {
    for (var i = 0; i < players.length; i++) {
      // If a player's hand is fully revealed, they LOSE
      // The OTHER player wins
      if (players[i].hand.isFullyRevealed) {
        return 1 - i; // Return the opponent's index as winner
      }
    }
    return null;
  }

  GuessArrangementState copyWith({
    GameStatus? status,
    List<GuessPlayer>? players,
    int? currentPlayerIndex,
    int? roundNumber,
    DateTime? startTime,
    DateTime? endTime,
    int? winnerIndex,
    bool? isDarkMode,
  }) {
    return GuessArrangementState(
      status: status ?? this.status,
      players: players ?? this.players,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      roundNumber: roundNumber ?? this.roundNumber,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      winnerIndex: winnerIndex ?? this.winnerIndex,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status.name,
    'players': players.map((p) => p.toJson()).toList(),
    'currentPlayerIndex': currentPlayerIndex,
    'roundNumber': roundNumber,
    'startTime': startTime?.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'winnerIndex': winnerIndex,
    'isDarkMode': isDarkMode,
  };

  factory GuessArrangementState.fromJson(Map<String, dynamic> json) {
    return GuessArrangementState(
      status: GameStatus.values.byName(json['status'] as String),
      players: (json['players'] as List)
          .map((p) => GuessPlayer.fromJson(p as Map<String, dynamic>))
          .toList(),
      currentPlayerIndex: json['currentPlayerIndex'] as int,
      roundNumber: json['roundNumber'] as int,
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'] as String)
          : null,
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      winnerIndex: json['winnerIndex'] as int?,
      isDarkMode: json['isDarkMode'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GuessArrangementState &&
        status == other.status &&
        _listEquals(players, other.players) &&
        currentPlayerIndex == other.currentPlayerIndex &&
        roundNumber == other.roundNumber &&
        startTime == other.startTime &&
        endTime == other.endTime &&
        winnerIndex == other.winnerIndex &&
        isDarkMode == other.isDarkMode;
  }

  @override
  int get hashCode => Object.hash(
    status,
    players,
    currentPlayerIndex,
    roundNumber,
    startTime,
    endTime,
    winnerIndex,
    isDarkMode,
  );

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
