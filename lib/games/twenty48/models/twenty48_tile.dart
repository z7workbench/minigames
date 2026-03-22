/// Represents a single tile on the 2048 game board.
///
/// Each tile has a unique ID, a value (power of 2), and a position.
class Twenty48Tile {
  /// Unique identifier for this tile (used for animation tracking).
  final String id;

  /// The value of the tile (2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, etc.)
  final int value;

  /// Row position (0-3).
  final int row;

  /// Column position (0-3).
  final int col;

  /// Whether this tile was created from a merge in the current move.
  final bool isMerged;

  /// Whether this tile is newly spawned in the current move.
  final bool isNew;

  const Twenty48Tile({
    required this.id,
    required this.value,
    required this.row,
    required this.col,
    this.isMerged = false,
    this.isNew = false,
  });

  /// Creates a copy of this tile with the given fields replaced.
  Twenty48Tile copyWith({
    String? id,
    int? value,
    int? row,
    int? col,
    bool? isMerged,
    bool? isNew,
  }) {
    return Twenty48Tile(
      id: id ?? this.id,
      value: value ?? this.value,
      row: row ?? this.row,
      col: col ?? this.col,
      isMerged: isMerged ?? this.isMerged,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Twenty48Tile) return false;
    return id == other.id &&
        value == other.value &&
        row == other.row &&
        col == other.col &&
        isMerged == other.isMerged &&
        isNew == other.isNew;
  }

  @override
  int get hashCode => Object.hash(id, value, row, col, isMerged, isNew);

  /// Serializes this tile to JSON.
  Map<String, dynamic> toJson() => {
    'id': id,
    'value': value,
    'row': row,
    'col': col,
    'isMerged': isMerged,
    'isNew': isNew,
  };

  /// Deserializes a tile from JSON.
  factory Twenty48Tile.fromJson(Map<String, dynamic> json) => Twenty48Tile(
    id: json['id'] as String,
    value: json['value'] as int,
    row: json['row'] as int,
    col: json['col'] as int,
    isMerged: json['isMerged'] as bool? ?? false,
    isNew: json['isNew'] as bool? ?? false,
  );

  @override
  String toString() =>
      'Twenty48Tile(id: $id, value: $value, row: $row, col: $col)';
}
