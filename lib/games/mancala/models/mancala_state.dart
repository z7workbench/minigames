/// Game status enumeration for Mancala.
enum MancalaStatus {
  /// Game is idle, not started.
  idle,

  /// Game is currently being played.
  playing,

  /// Game is paused.
  paused,

  /// Game has ended.
  gameOver,
}

/// AI difficulty levels for single-player mode.
enum AiDifficulty {
  /// Random pit selection.
  easy,

  /// Rule-based heuristics.
  medium,

  /// Minimax with alpha-beta pruning.
  hard,
}

/// Animation phase for visual feedback during AI turns.
enum AnimationPhase {
  /// No animation in progress.
  idle,

  /// Seeds are being picked up from a pit.
  pickingUp,

  /// Seeds are being sown around the board.
  sowing,

  /// Seeds are being captured.
  capturing,

  /// Turn is switching to other player.
  switchingTurn,

  /// Animation completed, waiting for AI delay.
  animationComplete,
}

/// State for tracking sowing animation progress.
class SowingAnimationState {
  /// Index of the pit where seeds were picked up from.
  final int sourcePitIndex;

  /// Number of seeds currently in hand (not yet dropped).
  final int seedsInHand;

  /// Current position in the sowing sequence.
  /// This is the index where the NEXT seed will be dropped.
  final int currentDropIndex;

  /// Number of seeds already dropped.
  final int seedsDropped;

  /// Total seeds to be sown.
  final int totalSeeds;

  /// Index where the last seed will land (for preview).
  final int? finalLandingIndex;

  /// Whether an extra turn is pending.
  final bool isExtraTurn;

  /// Number of seeds captured (if capture happened).
  final int capturedSeeds;

  /// Index of captured pit (if capture happened).
  final int? capturedPitIndex;

  const SowingAnimationState({
    required this.sourcePitIndex,
    required this.seedsInHand,
    required this.currentDropIndex,
    required this.seedsDropped,
    required this.totalSeeds,
    this.finalLandingIndex,
    this.isExtraTurn = false,
    this.capturedSeeds = 0,
    this.capturedPitIndex,
  });

  /// Initial state when starting a sowing animation.
  factory SowingAnimationState.start({
    required int sourcePitIndex,
    required int seeds,
    required int currentPlayer,
  }) {
    final firstDropIndex = _getNextIndex(sourcePitIndex, currentPlayer);
    return SowingAnimationState(
      sourcePitIndex: sourcePitIndex,
      seedsInHand: seeds,
      currentDropIndex: firstDropIndex,
      seedsDropped: 0,
      totalSeeds: seeds,
      finalLandingIndex: _calculateFinalLanding(
        sourcePitIndex,
        seeds,
        currentPlayer,
      ),
    );
  }

  /// Calculate the next index to drop a seed, skipping opponent's store.
  static int _getNextIndex(int currentIndex, int currentPlayer) {
    int nextIndex = (currentIndex + 1) % 14;
    // Skip opponent's store
    int opponentStore = currentPlayer == 0 ? 13 : 6;
    if (nextIndex == opponentStore) {
      nextIndex = (nextIndex + 1) % 14;
    }
    return nextIndex;
  }

  /// Calculate where the last seed will land.
  static int? _calculateFinalLanding(
    int startIndex,
    int seeds,
    int currentPlayer,
  ) {
    int currentIndex = startIndex;
    for (int i = 0; i < seeds; i++) {
      currentIndex = _getNextIndex(currentIndex, currentPlayer);
    }
    return currentIndex;
  }

  /// Get the next animation state after dropping one seed.
  SowingAnimationState nextDrop(int currentPlayer) {
    final newSeedsDropped = seedsDropped + 1;
    final newSeedsInHand = seedsInHand - 1;
    final nextDropIndex = newSeedsInHand > 0
        ? _getNextIndex(currentDropIndex, currentPlayer)
        : currentDropIndex;

    return SowingAnimationState(
      sourcePitIndex: sourcePitIndex,
      seedsInHand: newSeedsInHand,
      currentDropIndex: nextDropIndex,
      seedsDropped: newSeedsDropped,
      totalSeeds: totalSeeds,
      finalLandingIndex: finalLandingIndex,
      isExtraTurn: isExtraTurn,
      capturedSeeds: capturedSeeds,
      capturedPitIndex: capturedPitIndex,
    );
  }

  /// Check if this is the last seed being dropped.
  bool get isLastDrop => seedsInHand == 1;

  /// Check if animation is complete.
  bool get isComplete => seedsInHand == 0;

  /// Check if current drop index is player's store.
  bool isStore(int currentPlayer) {
    return currentPlayer == 0 ? currentDropIndex == 6 : currentDropIndex == 13;
  }
}

/// Immutable game state for Mancala.
///
/// Board layout (14 positions):
/// - Indices 0-5: Player 1's pits (bottom row, right to left)
/// - Index 6: Player 1's store (right side)
/// - Indices 7-12: Player 2's pits (top row, left to right)
/// - Index 13: Player 2's store (left side)
///
/// Sowing direction: counter-clockwise
/// Player 1 sows: 0→1→2→3→4→5→6(store)→7→8→9→10→11→12→skip13→0...
/// Player 2 sows: 7→8→9→10→11→12→13(store)→0→1→2→3→4→5→skip6→7...
class MancalaState {
  /// Current game status.
  final MancalaStatus status;

  /// Current player (0 = Player 1, 1 = Player 2).
  final int currentPlayer;

  /// Board state: 12 pits + 2 stores.
  /// See class documentation for index mapping.
  final List<int> board;

  /// AI difficulty for single-player mode (null for 2-player).
  final AiDifficulty? aiDifficulty;

  /// Elapsed time in seconds.
  final int elapsedSeconds;

  /// Current animation phase for UI feedback.
  final AnimationPhase animationPhase;

  /// Sowing animation state (null when not animating).
  final SowingAnimationState? sowingAnimation;

  /// Message to display during animation (e.g., "Extra Turn!", "Captured!").
  final String? animationMessage;

  const MancalaState({
    required this.status,
    required this.currentPlayer,
    required this.board,
    this.aiDifficulty,
    this.elapsedSeconds = 0,
    this.animationPhase = AnimationPhase.idle,
    this.sowingAnimation,
    this.animationMessage,
  });

  /// Creates a new game with 4 seeds per pit.
  factory MancalaState.newGame({AiDifficulty? aiDifficulty}) {
    // Board: [P1 pits 0-5, P1 store 6, P2 pits 7-12, P2 store 13]
    // Each pit starts with 4 seeds, stores are empty
    return MancalaState(
      status: MancalaStatus.playing,
      currentPlayer: 0, // Player 1 starts
      board: [4, 4, 4, 4, 4, 4, 0, 4, 4, 4, 4, 4, 4, 0],
      aiDifficulty: aiDifficulty,
    );
  }

  /// Creates an initial idle state.
  factory MancalaState.initial() {
    return const MancalaState(
      status: MancalaStatus.idle,
      currentPlayer: 0,
      board: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    );
  }

  /// Creates a copy with updated fields.
  MancalaState copyWith({
    MancalaStatus? status,
    int? currentPlayer,
    List<int>? board,
    AiDifficulty? aiDifficulty,
    int? elapsedSeconds,
    AnimationPhase? animationPhase,
    SowingAnimationState? sowingAnimation,
    String? animationMessage,
    bool clearAnimation = false,
  }) {
    return MancalaState(
      status: status ?? this.status,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      board: board ?? this.board,
      aiDifficulty: aiDifficulty ?? this.aiDifficulty,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      animationPhase: clearAnimation
          ? AnimationPhase.idle
          : (animationPhase ?? this.animationPhase),
      sowingAnimation: clearAnimation
          ? null
          : (sowingAnimation ?? this.sowingAnimation),
      animationMessage: clearAnimation
          ? null
          : (animationMessage ?? this.animationMessage),
    );
  }

  /// Serializes state to JSON for persistence.
  Map<String, dynamic> toJson() => {
    'status': status.name,
    'currentPlayer': currentPlayer,
    'board': List<int>.from(board),
    'aiDifficulty': aiDifficulty?.name,
    'elapsedSeconds': elapsedSeconds,
  };

  /// Deserializes state from JSON.
  factory MancalaState.fromJson(Map<String, dynamic> json) {
    return MancalaState(
      status: MancalaStatus.values.byName(json['status'] as String),
      currentPlayer: json['currentPlayer'] as int,
      board: List<int>.from(json['board'] as List),
      aiDifficulty: json['aiDifficulty'] != null
          ? AiDifficulty.values.byName(json['aiDifficulty'] as String)
          : null,
      elapsedSeconds: json['elapsedSeconds'] as int? ?? 0,
    );
  }

  // ============ Computed Properties ============

  /// Player 1's store (right side).
  int get player1Store => board[6];

  /// Player 2's store (left side).
  int get player2Store => board[13];

  /// Player 1's pits (indices 0-5).
  List<int> get player1Pits => board.sublist(0, 6);

  /// Player 2's pits (indices 7-12).
  List<int> get player2Pits => board.sublist(7, 13);

  /// Check if game is over (one side is empty).
  bool get isGameOver {
    final p1Empty = player1Pits.every((p) => p == 0);
    final p2Empty = player2Pits.every((p) => p == 0);
    return p1Empty || p2Empty;
  }

  /// Get winner index (null if draw or game not over).
  int? get winner {
    if (!isGameOver) return null;

    // Calculate final scores
    final p1Final = player1Store + player1Pits.reduce((a, b) => a + b);
    final p2Final = player2Store + player2Pits.reduce((a, b) => a + b);

    if (p1Final > p2Final) return 0;
    if (p2Final > p1Final) return 1;
    return null; // Draw
  }

  /// Check if current player is AI.
  bool get isAiTurn => aiDifficulty != null && currentPlayer == 1;

  /// Get valid pits for current player (non-empty pits on their side).
  List<int> get validPits {
    if (currentPlayer == 0) {
      // Player 1's pits: indices 0-5
      return [
        for (int i = 0; i < 6; i++)
          if (board[i] > 0) i,
      ];
    } else {
      // Player 2's pits: indices 7-12
      return [
        for (int i = 7; i < 13; i++)
          if (board[i] > 0) i,
      ];
    }
  }

  /// Check if a pit index belongs to current player.
  bool isCurrentPlayerPit(int pitIndex) {
    if (currentPlayer == 0) {
      return pitIndex >= 0 && pitIndex < 6;
    } else {
      return pitIndex >= 7 && pitIndex < 13;
    }
  }

  // ============ Game Logic Methods ============

  /// Sow seeds from a pit and return the resulting state.
  ///
  /// Returns a record with:
  /// - newState: the state after sowing
  /// - landedInStore: whether the last seed landed in player's store
  /// - captured: number of seeds captured (0 if no capture)
  /// - captureSource: index of captured pit (if capture happened)
  SowResult sowSeeds(int pitIndex) {
    if (status != MancalaStatus.playing) {
      return SowResult(newState: this, landedInStore: false, captured: 0);
    }

    if (!isCurrentPlayerPit(pitIndex) || board[pitIndex] == 0) {
      return SowResult(newState: this, landedInStore: false, captured: 0);
    }

    final seeds = board[pitIndex];
    final newBoard = List<int>.from(board);
    newBoard[pitIndex] = 0;

    int currentIndex = pitIndex;
    int storeIndex = currentPlayer == 0 ? 6 : 13;
    int opponentStoreIndex = currentPlayer == 0 ? 13 : 6;

    // Sow seeds counter-clockwise
    for (int i = 0; i < seeds; i++) {
      currentIndex = (currentIndex + 1) % 14;

      // Skip opponent's store
      if (currentIndex == opponentStoreIndex) {
        currentIndex = (currentIndex + 1) % 14;
      }

      newBoard[currentIndex]++;
    }

    // Check if last seed landed in player's store (extra turn)
    bool landedInStore = currentIndex == storeIndex;

    // Check for capture
    int captured = 0;
    int? captureSource;

    if (!landedInStore && newBoard[currentIndex] == 1) {
      // Check if landed in empty pit on own side
      bool isOwnPit = currentPlayer == 0
          ? (currentIndex >= 0 && currentIndex < 6)
          : (currentIndex >= 7 && currentIndex < 13);

      if (isOwnPit) {
        // Calculate opposite pit index
        int oppositeIndex;
        if (currentIndex < 6) {
          oppositeIndex = 12 - currentIndex;
        } else {
          oppositeIndex = 12 - currentIndex;
        }

        // Capture if opposite has seeds
        if (newBoard[oppositeIndex] > 0) {
          captured = newBoard[currentIndex] + newBoard[oppositeIndex];
          captureSource = oppositeIndex;
          newBoard[currentIndex] = 0;
          newBoard[oppositeIndex] = 0;
          newBoard[storeIndex] += captured;
        }
      }
    }

    // Check for game over AFTER capture is applied
    final p1Empty = newBoard.sublist(0, 6).every((p) => p == 0);
    final p2Empty = newBoard.sublist(7, 13).every((p) => p == 0);

    MancalaStatus newStatus = MancalaStatus.playing;
    if (p1Empty || p2Empty) {
      // Collect remaining seeds to stores
      // Note: capture has already been applied to store above
      newBoard[6] += newBoard.sublist(0, 6).fold(0, (a, b) => a + b);
      newBoard[13] += newBoard.sublist(7, 13).fold(0, (a, b) => a + b);
      for (int i = 0; i < 6; i++) newBoard[i] = 0;
      for (int i = 7; i < 13; i++) newBoard[i] = 0;
      newStatus = MancalaStatus.gameOver;
    }

    // Determine next player
    int nextPlayer = currentPlayer;
    if (!landedInStore && newStatus != MancalaStatus.gameOver) {
      nextPlayer = 1 - currentPlayer;
    }

    return SowResult(
      newState: copyWith(
        status: newStatus,
        currentPlayer: nextPlayer,
        board: newBoard,
      ),
      landedInStore: landedInStore,
      captured: captured,
      captureSource: captureSource,
      lastLandedIndex: currentIndex,
    );
  }

  /// Get final scores (call after game over).
  /// If game is over, the board should already be finalized
  /// (all seeds collected to stores, pits empty)
  /// But to be safe, we calculate the true final scores
  ({int player1, int player2}) get finalScores {
    if (status == MancalaStatus.gameOver) {
      // After game over, stores contain all seeds
      // Pits should be empty, but we add them just in case
      final p1Score = board[6] + player1Pits.fold<int>(0, (a, b) => a + b);
      final p2Score = board[13] + player2Pits.fold<int>(0, (a, b) => a + b);
      return (player1: p1Score, player2: p2Score);
    }
    // During gameplay, just return store values
    return (player1: board[6], player2: board[13]);
  }
}

/// Result of a sow operation.
class SowResult {
  /// The new game state after sowing.
  final MancalaState newState;

  /// Whether the last seed landed in player's store.
  final bool landedInStore;

  /// Number of seeds captured (0 if no capture).
  final int captured;

  /// Index of the pit that was captured from (opposite pit).
  final int? captureSource;

  /// Index where the last seed landed.
  final int? lastLandedIndex;

  const SowResult({
    required this.newState,
    required this.landedInStore,
    required this.captured,
    this.captureSource,
    this.lastLandedIndex,
  });
}
