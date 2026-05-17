import 'enums.dart';

class ConnectFourState {
  static const int rows = 7;
  static const int cols = 6;
  static const int connectCount = 4;

  final List<List<CellState>> board;
  final List<int> colHeight;
  final CellState currentTurn;
  final int moveCount;
  final GamePhase phase;
  final AiDifficulty difficulty;
  final GameResult result;
  final List<int> moveHistory;
  final int? lastMoveRow;
  final int? lastMoveCol;
  final int? winningCol;
  final List<List<bool>>? winningCells;

  const ConnectFourState({
    required this.board,
    required this.colHeight,
    required this.currentTurn,
    required this.moveCount,
    required this.phase,
    required this.difficulty,
    required this.result,
    required this.moveHistory,
    this.lastMoveRow,
    this.lastMoveCol,
    this.winningCol,
    this.winningCells,
  });

  factory ConnectFourState.initial({AiDifficulty difficulty = AiDifficulty.easy}) {
    return ConnectFourState(
      board: List.generate(rows, (_) => List.filled(cols, CellState.empty)),
      colHeight: List.filled(cols, 0),
      currentTurn: CellState.player,
      moveCount: 0,
      phase: GamePhase.idle,
      difficulty: difficulty,
      result: GameResult.none,
      moveHistory: [],
    );
  }

  ConnectFourState copyWith({
    List<List<CellState>>? board,
    List<int>? colHeight,
    CellState? currentTurn,
    int? moveCount,
    GamePhase? phase,
    AiDifficulty? difficulty,
    GameResult? result,
    List<int>? moveHistory,
    int? lastMoveRow,
    int? lastMoveCol,
    int? winningCol,
    List<List<bool>>? winningCells,
  }) {
    return ConnectFourState(
      board: board ?? this.board,
      colHeight: colHeight ?? this.colHeight,
      currentTurn: currentTurn ?? this.currentTurn,
      moveCount: moveCount ?? this.moveCount,
      phase: phase ?? this.phase,
      difficulty: difficulty ?? this.difficulty,
      result: result ?? this.result,
      moveHistory: moveHistory ?? this.moveHistory,
      lastMoveRow: lastMoveRow ?? this.lastMoveRow,
      lastMoveCol: lastMoveCol ?? this.lastMoveCol,
      winningCol: winningCol ?? this.winningCol,
      winningCells: winningCells ?? this.winningCells,
    );
  }

  bool get isBoardFull => moveCount >= rows * cols;

  static String colLabel(int col) => String.fromCharCode(65 + col);

  static String rowLabel(int row) => '${rows - row}';

  static String moveNotation(int col, int row) =>
      '${colLabel(col)}${rowLabel(row)}';

  List<String> get moveNotations {
    final result = <String>[];
    final heights = List.filled(cols, 0);
    for (final col in moveHistory) {
      final row = rows - 1 - heights[col];
      result.add(moveNotation(col, row));
      heights[col]++;
    }
    return result;
  }

  bool get canUndo =>
      phase == GamePhase.playing &&
      moveHistory.length >= 2 &&
      currentTurn == CellState.player;

  CellState cellAt(int row, int col) => board[row][col];

  bool isColumnFull(int col) => colHeight[col] >= rows;

  int getDropRow(int col) => rows - 1 - colHeight[col];

  List<int> get validColumns {
    final cols = <int>[];
    for (int c = 0; c < ConnectFourState.cols; c++) {
      if (!isColumnFull(c)) cols.add(c);
    }
    return cols;
  }

  Map<String, dynamic> toJson() {
    return {
      'board': board.map((row) => row.map((c) => c.value).toList()).toList(),
      'colHeight': colHeight,
      'currentTurn': currentTurn.value,
      'moveCount': moveCount,
      'phase': phase.index,
      'difficulty': difficulty.index,
      'result': result.index,
      'moveHistory': moveHistory,
      'lastMoveRow': lastMoveRow,
      'lastMoveCol': lastMoveCol,
    };
  }

  factory ConnectFourState.fromJson(Map<String, dynamic> json) {
    final boardData = json['board'] as List;
    final board = boardData
        .map((row) => (row as List).map((v) => CellStateExtension.fromValue(v as int)).toList())
        .toList();
    final colHeight = (json['colHeight'] as List).cast<int>();

    return ConnectFourState(
      board: board,
      colHeight: colHeight,
      currentTurn: CellStateExtension.fromValue(json['currentTurn'] as int),
      moveCount: json['moveCount'] as int,
      phase: GamePhase.values[json['phase'] as int],
      difficulty: AiDifficulty.values[json['difficulty'] as int],
      result: GameResult.values[json['result'] as int],
      moveHistory: (json['moveHistory'] as List).cast<int>(),
      lastMoveRow: json['lastMoveRow'] as int?,
      lastMoveCol: json['lastMoveCol'] as int?,
    );
  }
}
