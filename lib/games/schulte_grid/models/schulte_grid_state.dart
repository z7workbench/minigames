import 'dart:math';

enum SchulteGridStatus { idle, running, paused, completed }

enum SchulteGridSize {
  fourByFour(4),
  fiveByFive(5),
  sixBySix(6);

  final int dimension;
  const SchulteGridSize(this.dimension);

  int get total => dimension * dimension;

  String get gameTypeKey => 'schulte_grid_${dimension}x$dimension';

  String get label => '${dimension}x$dimension';
}

class SchulteGridState {
  final SchulteGridSize gridSize;
  final List<List<int>> grid;
  final int nextNumber;
  final int elapsedMs;
  final SchulteGridStatus status;
  final int? startTimeMs;
  final int? wrongTapRow;
  final int? wrongTapCol;
  final bool isNewBest;

  const SchulteGridState({
    required this.gridSize,
    required this.grid,
    required this.nextNumber,
    required this.elapsedMs,
    required this.status,
    this.startTimeMs,
    this.wrongTapRow,
    this.wrongTapCol,
    this.isNewBest = false,
  });

  factory SchulteGridState.initial() {
    return const SchulteGridState(
      gridSize: SchulteGridSize.fourByFour,
      grid: [],
      nextNumber: 1,
      elapsedMs: 0,
      status: SchulteGridStatus.idle,
    );
  }

  static List<List<int>> generateGrid(SchulteGridSize size) {
    final total = size.total;
    final numbers = List<int>.generate(total, (i) => i + 1);
    final random = Random();
    for (int i = numbers.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = numbers[i];
      numbers[i] = numbers[j];
      numbers[j] = temp;
    }
    final grid = <List<int>>[];
    for (int row = 0; row < size.dimension; row++) {
      grid.add(numbers.sublist(
        row * size.dimension,
        (row + 1) * size.dimension,
      ));
    }
    return grid;
  }

  static String formatTime(int ms) {
    final minutes = ms ~/ 60000;
    final seconds = (ms % 60000) ~/ 1000;
    final hundredths = (ms % 1000) ~/ 10;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}.'
        '${hundredths.toString().padLeft(2, '0')}';
  }

  bool get isCompleted => nextNumber > gridSize.total;

  SchulteGridState copyWith({
    SchulteGridSize? gridSize,
    List<List<int>>? grid,
    int? nextNumber,
    int? elapsedMs,
    SchulteGridStatus? status,
    int? startTimeMs,
    int? wrongTapRow,
    int? wrongTapCol,
    bool? isNewBest,
  }) {
    return SchulteGridState(
      gridSize: gridSize ?? this.gridSize,
      grid: grid ?? this.grid,
      nextNumber: nextNumber ?? this.nextNumber,
      elapsedMs: elapsedMs ?? this.elapsedMs,
      status: status ?? this.status,
      startTimeMs: startTimeMs ?? this.startTimeMs,
      wrongTapRow: wrongTapRow,
      wrongTapCol: wrongTapCol,
      isNewBest: isNewBest ?? this.isNewBest,
    );
  }
}
