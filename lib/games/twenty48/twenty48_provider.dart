import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database.dart';
import '../../data/providers/database_provider.dart';
import 'models/twenty48_state.dart';
import 'models/twenty48_tile.dart';

part 'twenty48_provider.g.dart';

final _random = Random();

@riverpod
class Twenty48Game extends _$Twenty48Game {
  Timer? _timer;

  @override
  Twenty48State build() {
    // Clean up timer when provider is disposed
    ref.onDispose(() {
      _timer?.cancel();
    });
    return Twenty48State.initial();
  }

  /// Start a new game with two initial tiles.
  void startNewGame() {
    _timer?.cancel();

    // Create empty grid
    final grid = List.generate(4, (_) => List<Twenty48Tile?>.filled(4, null));

    // Add two initial tiles
    _spawnTile(grid);
    _spawnTile(grid);

    state = Twenty48State(
      grid: grid,
      score: 0,
      bestScore: state.bestScore,
      status: Twenty48Status.playing,
      elapsedSeconds: 0,
      previousHadMerge: false,
      maxTile: 2,
    );

    _startTimer();
  }

  /// Load a saved game from the given state.
  void loadGame(Twenty48State savedState) {
    _timer?.cancel();
    state = savedState.copyWith(status: Twenty48Status.playing);
    _startTimer();
  }

  /// Move tiles in the given direction.
  void move(Twenty48Direction direction) {
    if (state.status != Twenty48Status.playing) return;

    // Clear merge/spawn flags from previous turn
    final clearedGrid = _clearTileFlags(state.grid);

    // Perform the move
    final result = _performMove(clearedGrid, direction);

    // Check if any tiles moved
    if (!result.tilesMoved) return;

    // Calculate score with multipliers
    final baseScore = result.mergeScore;
    int finalScore = baseScore;

    // Multiple merge bonus: merges in multiple positions in one swipe -> x1.5
    if (result.mergeCount > 1) {
      finalScore = (finalScore * 1.5).round();
    }

    // Consecutive merge bonus: current swipe has merge AND previous had merge -> x2
    if (result.hasMerge && state.previousHadMerge) {
      finalScore = finalScore * 2;
    }

    // Spawn new tile
    _spawnTile(result.grid);

    // Calculate max tile
    int maxTile = state.maxTile;
    for (final row in result.grid) {
      for (final tile in row) {
        if (tile != null && tile.value > maxTile) {
          maxTile = tile.value;
        }
      }
    }

    // Check for win condition
    bool hasWon = false;
    if (maxTile >= 2048 && state.status != Twenty48Status.won) {
      hasWon = true;
    }

    // Check for game over
    final isGameOver = !_canMove(result.grid);

    // Update best score
    final newScore = state.score + finalScore;
    final newBestScore = newScore > state.bestScore
        ? newScore
        : state.bestScore;

    state = state.copyWith(
      grid: result.grid,
      score: newScore,
      bestScore: newBestScore,
      status: hasWon
          ? Twenty48Status.won
          : isGameOver
          ? Twenty48Status.gameOver
          : Twenty48Status.playing,
      previousHadMerge: result.hasMerge,
      maxTile: maxTile,
    );

    if (state.status == Twenty48Status.gameOver ||
        state.status == Twenty48Status.won) {
      _timer?.cancel();
      _saveGameRecord();
    }
  }

  /// Pause the game.
  void pause() {
    if (state.status == Twenty48Status.playing) {
      _timer?.cancel();
      state = state.copyWith(status: Twenty48Status.paused);
    }
  }

  /// Resume the game from pause.
  void resume() {
    if (state.status == Twenty48Status.paused) {
      state = state.copyWith(status: Twenty48Status.playing);
      _startTimer();
    }
  }

  /// Save current game to a slot.
  Future<int> saveGame(int slotIndex) async {
    final dao = ref.read(twenty48SavesDaoProvider);

    // Calculate max tile
    int maxTile = 0;
    for (final row in state.grid) {
      for (final tile in row) {
        if (tile != null && tile.value > maxTile) {
          maxTile = tile.value;
        }
      }
    }

    return await dao.saveGame(
      Twenty48SavesCompanion.insert(
        slotIndex: Value(slotIndex),
        gameStateJson: jsonEncode(state.toJson()),
        score: state.score,
        maxTile: maxTile,
      ),
    );
  }

  /// Load a game from a slot.
  Future<void> loadFromSlot(int slotIndex) async {
    final dao = ref.read(twenty48SavesDaoProvider);
    final save = await dao.getSaveBySlot(slotIndex);

    if (save != null) {
      final loadedState = Twenty48State.fromJson(
        jsonDecode(save.gameStateJson) as Map<String, dynamic>,
      );
      loadGame(loadedState);
    }
  }

  /// Get all saved games.
  Future<List<Twenty48Save>> getAllSaves() async {
    final dao = ref.read(twenty48SavesDaoProvider);
    return await dao.getAllSaves();
  }

  /// Delete a saved game.
  Future<void> deleteSave(int slotIndex) async {
    final dao = ref.read(twenty48SavesDaoProvider);
    await dao.deleteSaveBySlot(slotIndex);
  }

  /// Check if there are any saved games.
  Future<bool> hasSaves() async {
    final dao = ref.read(twenty48SavesDaoProvider);
    return await dao.hasAnySaves();
  }

  /// Get the first available save slot.
  Future<int> getAvailableSlot() async {
    final dao = ref.read(twenty48SavesDaoProvider);
    final slot = await dao.getFirstEmptySlot();
    return slot >= 0
        ? slot
        : 0; // Return 0 if all slots are full (will overwrite)
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.status == Twenty48Status.playing) {
        state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
      }
    });
  }

  /// Clear merge and spawn flags from all tiles.
  List<List<Twenty48Tile?>> _clearTileFlags(List<List<Twenty48Tile?>> grid) {
    return grid.map((row) {
      return row.map((tile) {
        if (tile == null) return null;
        return tile.copyWith(isMerged: false, isNew: false);
      }).toList();
    }).toList();
  }

  /// Spawn a new tile at a random empty position.
  void _spawnTile(List<List<Twenty48Tile?>> grid) {
    final emptyCells = <int>[];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (grid[i][j] == null) {
          emptyCells.add(i * 4 + j);
        }
      }
    }

    if (emptyCells.isEmpty) return;

    final position = emptyCells[_random.nextInt(emptyCells.length)];
    final row = position ~/ 4;
    final col = position % 4;

    // 90% chance of 2, 10% chance of 4
    final value = _random.nextDouble() < 0.9 ? 2 : 4;

    grid[row][col] = Twenty48Tile(
      id: _generateId(),
      value: value,
      row: row,
      col: col,
      isNew: true,
    );
  }

  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(10000)}';
  }

  /// Perform a move in the given direction.
  _MoveResult _performMove(
    List<List<Twenty48Tile?>> grid,
    Twenty48Direction direction,
  ) {
    bool tilesMoved = false;
    int mergeScore = 0;
    int mergeCount = 0;
    bool hasMerge = false;

    // Rotate grid to always process left-to-right
    final rotatedGrid = _rotateGrid(grid, direction);

    // Process each row
    for (int i = 0; i < 4; i++) {
      final result = _processRow(rotatedGrid[i]);
      rotatedGrid[i] = result.row;

      if (result.moved) tilesMoved = true;
      if (result.mergeScore > 0) {
        mergeScore += result.mergeScore;
        mergeCount += result.mergeCount;
        hasMerge = true;
      }
    }

    // Rotate back
    final finalGrid = _rotateGridBack(rotatedGrid, direction);

    return _MoveResult(
      grid: finalGrid,
      tilesMoved: tilesMoved,
      mergeScore: mergeScore,
      mergeCount: mergeCount,
      hasMerge: hasMerge,
    );
  }

  /// Rotate grid so we always process left-to-right.
  List<List<Twenty48Tile?>> _rotateGrid(
    List<List<Twenty48Tile?>> grid,
    Twenty48Direction direction,
  ) {
    switch (direction) {
      case Twenty48Direction.left:
        return grid;
      case Twenty48Direction.right:
        return grid.map((row) => row.reversed.toList()).toList();
      case Twenty48Direction.up:
        return _transpose(grid);
      case Twenty48Direction.down:
        return _transpose(grid).map((row) => row.reversed.toList()).toList();
    }
  }

  /// Rotate grid back to original orientation.
  List<List<Twenty48Tile?>> _rotateGridBack(
    List<List<Twenty48Tile?>> grid,
    Twenty48Direction direction,
  ) {
    switch (direction) {
      case Twenty48Direction.left:
        return grid;
      case Twenty48Direction.right:
        return grid.map((row) => row.reversed.toList()).toList();
      case Twenty48Direction.up:
        return _transpose(grid);
      case Twenty48Direction.down:
        return _transpose(grid.map((row) => row.reversed.toList()).toList());
    }
  }

  /// Transpose the grid (swap rows and columns).
  List<List<Twenty48Tile?>> _transpose(List<List<Twenty48Tile?>> grid) {
    return List.generate(4, (i) => List.generate(4, (j) => grid[j][i]));
  }

  /// Process a single row: compress and merge.
  _RowResult _processRow(List<Twenty48Tile?> row) {
    bool moved = false;
    int mergeScore = 0;
    int mergeCount = 0;

    // Get all non-null tiles
    final tiles = row.whereType<Twenty48Tile>().toList();
    if (tiles.isEmpty) {
      return _RowResult(
        row: List.filled(4, null),
        moved: false,
        mergeScore: 0,
        mergeCount: 0,
      );
    }

    // Merge tiles
    final mergedTiles = <Twenty48Tile>[];
    int i = 0;
    while (i < tiles.length) {
      if (i + 1 < tiles.length && tiles[i].value == tiles[i + 1].value) {
        // Merge two tiles
        final mergedValue = tiles[i].value * 2;
        mergedTiles.add(
          Twenty48Tile(
            id: _generateId(),
            value: mergedValue,
            row: tiles[i].row,
            col: tiles[i].col,
            isMerged: true,
          ),
        );
        mergeScore += mergedValue;
        mergeCount++;
        i += 2;
        moved = true;
      } else {
        mergedTiles.add(tiles[i]);
        i++;
      }
    }

    // Update positions and check if tiles moved
    final newRow = List<Twenty48Tile?>.filled(4, null);
    for (int j = 0; j < mergedTiles.length; j++) {
      final oldTile = tiles.length > j ? tiles[j] : null;
      final newTile = mergedTiles[j];

      // Check if position changed
      if (oldTile != null && oldTile.col != j) {
        moved = true;
      }

      newRow[j] = newTile.copyWith(row: 0, col: j);
    }

    // Also check if any tile positions changed due to merging
    if (mergedTiles.length < tiles.length) {
      moved = true;
    }

    return _RowResult(
      row: newRow,
      moved: moved,
      mergeScore: mergeScore,
      mergeCount: mergeCount,
    );
  }

  /// Check if any moves are possible.
  bool _canMove(List<List<Twenty48Tile?>> grid) {
    // Check for empty cells
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (grid[i][j] == null) return true;
      }
    }

    // Check for possible merges horizontally
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[i][j]?.value == grid[i][j + 1]?.value) return true;
      }
    }

    // Check for possible merges vertically
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 4; j++) {
        if (grid[i][j]?.value == grid[i + 1][j]?.value) return true;
      }
    }

    return false;
  }

  void _saveGameRecord() {
    // Save to game records for leaderboard
    final dao = ref.read(gameRecordsDaoProvider);
    dao.insertRecord(
      GameRecordsCompanion.insert(
        gameType: 'twenty48',
        score: Value(state.score),
        durationSeconds: Value(state.elapsedSeconds),
      ),
    );
  }
}

class _MoveResult {
  final List<List<Twenty48Tile?>> grid;
  final bool tilesMoved;
  final int mergeScore;
  final int mergeCount;
  final bool hasMerge;

  _MoveResult({
    required this.grid,
    required this.tilesMoved,
    required this.mergeScore,
    required this.mergeCount,
    required this.hasMerge,
  });
}

class _RowResult {
  final List<Twenty48Tile?> row;
  final bool moved;
  final int mergeScore;
  final int mergeCount;

  _RowResult({
    required this.row,
    required this.moved,
    required this.mergeScore,
    required this.mergeCount,
  });
}
