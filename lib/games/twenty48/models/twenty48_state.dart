import 'twenty48_tile.dart';

/// The game status for the 2048 game.
enum Twenty48Status {
  /// The game has not started yet.
  idle,

  /// The game is currently being played.
  playing,

  /// The player has won (reached 2048 tile).
  won,

  /// The game is over (no more moves possible).
  gameOver,

  /// The game is paused.
  paused,
}

/// The move direction for the 2048 game.
enum Twenty48Direction { up, down, left, right }

/// Represents the complete state of a 2048 game.
class Twenty48State {
  /// The 4x4 grid of tiles. null represents an empty cell.
  final List<List<Twenty48Tile?>> grid;

  /// The current score.
  final int score;

  /// The best score achieved in this session.
  final int bestScore;

  /// The current game status.
  final Twenty48Status status;

  /// The elapsed time in seconds.
  final int elapsedSeconds;

  /// Whether the previous move had a merge (for consecutive bonus).
  final bool previousHadMerge;

  /// The maximum tile value achieved.
  final int maxTile;

  const Twenty48State({
    required this.grid,
    required this.score,
    required this.bestScore,
    required this.status,
    required this.elapsedSeconds,
    required this.previousHadMerge,
    required this.maxTile,
  });

  /// Creates the initial state for a new game.
  factory Twenty48State.initial() {
    return Twenty48State(
      grid: List.generate(4, (_) => List<Twenty48Tile?>.filled(4, null)),
      score: 0,
      bestScore: 0,
      status: Twenty48Status.idle,
      elapsedSeconds: 0,
      previousHadMerge: false,
      maxTile: 0,
    );
  }

  /// Creates a copy of this state with the given fields replaced.
  Twenty48State copyWith({
    List<List<Twenty48Tile?>>? grid,
    int? score,
    int? bestScore,
    Twenty48Status? status,
    int? elapsedSeconds,
    bool? previousHadMerge,
    int? maxTile,
  }) {
    return Twenty48State(
      grid: grid ?? this.grid,
      score: score ?? this.score,
      bestScore: bestScore ?? this.bestScore,
      status: status ?? this.status,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      previousHadMerge: previousHadMerge ?? this.previousHadMerge,
      maxTile: maxTile ?? this.maxTile,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Twenty48State) return false;

    // Compare grids
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (grid[i][j] != other.grid[i][j]) return false;
      }
    }

    return score == other.score &&
        bestScore == other.bestScore &&
        status == other.status &&
        elapsedSeconds == other.elapsedSeconds &&
        previousHadMerge == other.previousHadMerge &&
        maxTile == other.maxTile;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(grid.expand((row) => row)),
    score,
    bestScore,
    status,
    elapsedSeconds,
    previousHadMerge,
    maxTile,
  );

  /// Serializes this state to JSON for saving.
  Map<String, dynamic> toJson() => {
    'grid': grid
        .map((row) => row.map((tile) => tile?.toJson()).toList())
        .toList(),
    'score': score,
    'bestScore': bestScore,
    'status': status.name,
    'elapsedSeconds': elapsedSeconds,
    'previousHadMerge': previousHadMerge,
    'maxTile': maxTile,
  };

  /// Deserializes a state from JSON.
  factory Twenty48State.fromJson(Map<String, dynamic> json) {
    final gridData = json['grid'] as List<dynamic>;
    final grid = gridData.map((row) {
      final rowData = row as List<dynamic>;
      return rowData.map((tile) {
        if (tile == null) return null;
        return Twenty48Tile.fromJson(tile as Map<String, dynamic>);
      }).toList();
    }).toList();

    return Twenty48State(
      grid: grid,
      score: json['score'] as int,
      bestScore: json['bestScore'] as int,
      status: Twenty48Status.values.byName(json['status'] as String),
      elapsedSeconds: json['elapsedSeconds'] as int,
      previousHadMerge: json['previousHadMerge'] as bool? ?? false,
      maxTile: json['maxTile'] as int,
    );
  }

  @override
  String toString() =>
      'Twenty48State(score: $score, status: $status, maxTile: $maxTile)';
}
